//
//  MachineOperator.swift
//  UnitTestSample
//
//  Created by kwangmin kim on 2021/04/27.
//

import Combine
import Foundation

//class MachineOperator {
//    
//    private let serialQueue = DispatchQueue(label: "machine-operator-queue")
//    
//    var machine = Machine()
//    
//    private var line = [Person]()
//    private var storage = Set<AnyCancellable>()
//    
//    private let durationForWaiting = 2.0
    private var waitingWorkItem: DispatchWorkItem?
//    
//    init() {
//        machine.$status
//            .filter { $0 == .ready }
//            .receive(on: serialQueue)
//            .sink { [weak self] _ in
//                guard let self = self else { return }
//                self.getCutomersOnSeat()
//                self.determineStartOrWait()
//            }
//            .store(in: &storage)
//    }
//    
//    func coordinate(customer: Person) {
//        serialQueue.async { [weak self] in
//            guard let self = self else { return }
//            self._coordinate(customer: customer)
//        }
//    }
//    
//    private func _coordinate(customer: Person) {
//        switch machine.status {
//        case .ready:
//            if machine.hasEmptySeat {
//                machine.seat(customers: [customer])
//            } else {
//                customer.status = .inLine
//                line.append(customer)
//            }
//            determineStartOrWait()
//        case .operating:
//            customer.status = .inLine
//            line.append(customer)
//        }
//    }
//    
//    func getCutomersOnSeat() {
//        serialQueue.async { [weak self] in
//            guard let self = self else { return }
//            self._getCutomersOnSeat()
//        }
//    }
//    
//    private func _getCutomersOnSeat() {
//        guard machine.hasEmptySeat else { return }
//        let availableCount = min(machine.numberOfEmptySeats, line.count)
//        let earlyCustomers = [Person](line.dropFirst(availableCount))
//        machine.seat(customers: earlyCustomers)
//        line.removeFirst(availableCount)
//    }
//    
//    private func determineStartOrWait() {
//        waitingWorkItem?.cancel()
//        waitingWorkItem = nil
//        
//        if machine.hasEmptySeat {
//            if machine.satisfiedRequirements {
//                waitingWorkItem = DispatchWorkItem { [weak self] in
//                    guard let self = self else { return }
//                    if self.line.isEmpty {
//                        print("determined to start")
//                        self.machine.start()
//                    } else {
//                        // do nothing and wait
//                        print("determined to wait")
//                    }
//                }
//                serialQueue.asyncAfter(deadline: .now() + durationForWaiting, execute: waitingWorkItem!)
//            } else {
//                // do nothing and wait
//                print("determined to wait")
//            }
//        } else {
//            machine.start()
//            print("determined to start")
//        }
//    }
//}
