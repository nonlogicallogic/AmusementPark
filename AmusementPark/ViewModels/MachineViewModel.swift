//
//  MachineViewModel.swift
//  UnitTestSample
//
//  Created by kwangmin kim on 2021/04/27.
//

import Combine
import Foundation

struct Seat: Naming, Identifiable {
    
    let id: String = UUID().uuidString
    
    var person: Person?
    
    var name: String { person?.name ?? "" }
}


final class MachineViewModel: ObservableObject, Identifiable {
    
    let id: String = UUID().uuidString
    
    let machine: MachineType
    
    @Published var seats = [Seat]()
    @Published var peopleOnSeat = [Person]()
    @Published var peopleInLine = [Person]()
    @Published var status: Machine.Status = .ready
    @Published var remaingTime: Int? = nil
    
    var name: String { machine.configuration.name }
    
    var img: String? { machine.configuration.img }
    
    @Published var accommodationInfo: String = ""
    
    var needMorePeople: Bool { peopleOnSeat.count < machine.configuration.minimumPeopleRequired }
    
    private var storage = Set<AnyCancellable>()
    
    init(machine: MachineType) {
        self.machine = machine
        
        machine
            .peopleOnSeat
            .receive(on: RunLoop.main)
            .sink { [weak self] people in
                guard let self = self else { return }
                self.peopleOnSeat = people
                self.updateAccommodationInfo()
            }
            .store(in: &storage)
        
        machine
            .peopleOnSeat
            .receive(on: RunLoop.main)
            .sink { [weak self] people in
                guard let self = self else { return }
                
                var seats = people.map { Seat(person: $0) }
                while seats.count < self.machine.configuration.accommodation {
                    seats.append(Seat())
                }
                self.seats = seats
            }
            .store(in: &storage)
        
        machine
            .peopleInLine
            .receive(on: RunLoop.main)
            .assign(to: &$peopleInLine)
        
        machine
            .status
            .receive(on: RunLoop.main)
            .assign(to: &$status)
        
        machine
            .remainingTime
            .receive(on: RunLoop.main)
            .assign(to: &$remaingTime)
    }
    
    private func updateAccommodationInfo() {
        var info = ["\(peopleOnSeat.count) / \(machine.configuration.accommodation)"]
        
        if peopleOnSeat.count == machine.configuration.accommodation {
            info.append("(Full)")
        } else {
            if peopleOnSeat.count < machine.configuration.minimumPeopleRequired {
                info.append("(minimum \(machine.configuration.minimumPeopleRequired))")
            }
        }
        
        accommodationInfo = info.joined(separator: " ")
    }
}
