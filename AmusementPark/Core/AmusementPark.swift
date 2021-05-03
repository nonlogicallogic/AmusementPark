//
//  AmusementPark.swift
//  AmusementPark
//
//  Created by kwangmin kim on 2021/04/29.
//

import Foundation
import Combine

final class AmusementPark {
    let square = Square()
    var machines = [Machine]()
    let configuration: AmusementParkConfiguration
    
    private var _accommodated = 0
    var accommodated: Int {
        get {
            serialQueue.sync {
                return _accommodated
            }
        }
        
        set {
            serialQueue.async {
                self._accommodated = newValue
            }
        }
    }
    
    private var storage = Set<AnyCancellable>()
    
    private let serialQueue: DispatchQueue
    
    init(configuration: AmusementParkConfiguration, queue: DispatchQueue? = nil) {
        self.configuration = configuration
        
        if let queue = queue {
            self.serialQueue = queue
        } else {
            self.serialQueue = DispatchQueue(label: "amusement-park-queue")
        }
        
        configuration.machineConfigurations.forEach {
            self.machines.append(Machine(configuration: $0))
        }
        
        machines.forEach { machine in
            machine
                .peopleExiting
                .receive(on: serialQueue)
                .sink { [weak self] peopleFromMachine in
                    peopleFromMachine.forEach { person in
                        guard let self = self else { return }
                        person.enter(self.square)
                    }
                }
                .store(in: &storage)
        }
    }
}
