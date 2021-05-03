//
//  AmusementParkViewModel.swift
//  AmusementPark
//
//  Created by kwangmin kim on 2021/04/29.
//

import Foundation
import Combine

final class AmusementParkViewModel: ObservableObject {
    let park: AmusementPark
    let squareViewModel: SquareViewModel
    let machineViewModels: [MachineViewModel]
    
    private let simulator: Simulator
    
    private var storage = Set<AnyCancellable>()
    
    init() {
        let config = SimulatorConfiguration(accommodation: 20, numberOfMachines: 1)
        simulator = Simulator(configuration: config)
        
        park = simulator.park
        squareViewModel = SquareViewModel(square: park.square)

        var viewModels = [MachineViewModel]()
        for each in park.machines {
            let viewModel = MachineViewModel(machine: each)
            viewModels.append(viewModel)
        }
        machineViewModels = viewModels
        
        simulator.simulatePeopleComing()
        simulator.simulatePeopleGettingIntoMachines()
    }
}
