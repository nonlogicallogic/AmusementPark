//
//  Machine.swift
//  UnitTestSample
//
//  Created by kwangmin kim on 2021/04/28.
//

import Foundation
import Combine


protocol MachineType: Place {
    
    var status: AnyPublisher<Machine.Status, Never> { get set }
    
    var peopleOnSeat: AnyPublisher<[Person], Never> { get set }
    
    var peopleInLine: AnyPublisher<[Person], Never> { get set }
    
    var peopleExiting: AnyPublisher<[Person], Never> { get set }
    
    var remainingTime: AnyPublisher<Int?, Never> { get set }
    
    var configuration: MachineConfiguration { get }
    
}


final class Machine: MachineType {
    
    enum Status: String {
        case ready
        case operating
    }
    
    
    // MARK: - Interface
    lazy var status: AnyPublisher<Status, Never> = { _status.eraseToAnyPublisher() }()
    
    lazy var peopleOnSeat: AnyPublisher<[Person], Never> = { _peopleOnSeat.eraseToAnyPublisher() }()
    
    lazy var peopleInLine: AnyPublisher<[Person], Never> = { _peopleInLine.eraseToAnyPublisher() }()
    
    lazy var peopleExiting: AnyPublisher<[Person], Never> = { _peopleExiting.eraseToAnyPublisher() }()
    
    lazy var remainingTime: AnyPublisher<Int?, Never> = { _remainingTime.eraseToAnyPublisher() }()
    
    private(set) var configuration: MachineConfiguration
    
    
    // MARK: - Private
    private var _remainingTime = CurrentValueSubject<Int?, Never>(nil)
    
    private var _status = CurrentValueSubject<Status, Never>(.ready)
    
    private var _peopleOnSeat = CurrentValueSubject<[Person], Never>([])
    
    private var _peopleInLine = CurrentValueSubject<[Person], Never>([])
    
    private var _peopleExiting = PassthroughSubject<[Person], Never>()
    
    private var hasEmptySeat: Bool { _peopleOnSeat.value.count < configuration.accommodation }
    
    private var full: Bool { !hasEmptySeat }
    
    private var satisfiedRequirements: Bool { _peopleOnSeat.value.count > configuration.minimumPeopleRequired }
    
    private let serialQueue: DispatchQueue
    
    private var decisionWorkItem: DispatchWorkItem?
    
    private var storage = Set<AnyCancellable>()
    
    init(configuration: MachineConfiguration, queue: DispatchQueue? = nil) {
        self.configuration = configuration
        
        if let queue = queue {
            self.serialQueue = queue
        } else {
            self.serialQueue = DispatchQueue(label: "machine-queue-\(UUID().uuidString)")
        }
        
        _status
            .receive(on: serialQueue)
            .filter { $0 == .ready }
            .sink { [weak self] _ in
                self?.emptyPeopleOnSeat()
                self?.getPeopleInLineOnSeat()
                self?.determinStartOrWait()
            }
            .store(in: &storage)
    }
    
    private func curate(new: Person) {
        switch _status.value {
        case .ready:
            if hasEmptySeat {
                _peopleOnSeat.value.append(new)
            } else {
                _peopleInLine.value.append(new)
            }
            determinStartOrWait()
        case .operating:
            _peopleInLine.value.append(new)
        }
    }
    
    private func emptyPeopleOnSeat() {
        _peopleExiting.send(_peopleOnSeat.value)
        _peopleOnSeat.value.forEach {
            $0.exit(self)
        }
    }
    
    private func getPeopleInLineOnSeat() {
        while hasEmptySeat && _peopleInLine.value.isEmpty == false {
            let person = _peopleInLine.value.removeFirst()
            _peopleOnSeat.value.append(person)
        }
    }
    
    private func determinStartOrWait() {
        decisionWorkItem?.cancel()
        decisionWorkItem = nil
        
        if full {
            start()
        } else {
            if satisfiedRequirements {
                decisionWorkItem = DispatchWorkItem { [weak self] in
                    guard let self = self else { return }
                    self.start()
                }
                serialQueue.asyncAfter(deadline: .now() + configuration.waitDuration, execute: decisionWorkItem!)
            }
        }
    }
    
    private func start() {
        serialQueue.async { [weak self] in
            self?._start()
        }
    }
    
    private func _start() {
        guard case .ready = _status.value else { return }
        _status.value = .operating
        run()
    }
    
    private func run() {
        if _remainingTime.value == nil {
            _remainingTime.value = Int(configuration.runningDuration)
        }
        
        if _remainingTime.value! < 1 {
            stop()
            return
        }
        
        serialQueue.asyncAfter(deadline: .now() + 1) { [weak self] in
            guard let self = self else { return }
            guard self._remainingTime.value != nil else { return }
            self._remainingTime.value = self._remainingTime.value! - 1
            self.run()
        }
    }

    private func stop() {
        guard case .operating = _status.value else { return }
        _remainingTime.value = nil
        _status.value = .ready
    }
}


extension Machine: Place {

    func welcome(_ person: Person) {
        serialQueue.async { [weak self] in
            guard let self = self else { return }
            self.curate(new: person)
        }
    }

    func farewell(_ person: Person) {
        if let found = self._peopleOnSeat.value.firstIndex(of: person) {
            self._peopleOnSeat.value.remove(at: found)
        }
    }
    
}
