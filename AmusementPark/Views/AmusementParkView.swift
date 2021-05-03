//
//  AmusementParkView.swift
//  AmusementPark
//
//  Created by kwangmin kim on 2021/04/29.
//

import SwiftUI

struct AmusementParkView: View {
    
    @ObservedObject var viewModel: AmusementParkViewModel
    
    var body: some View {
        VStack {
            SquareView(viewModel: viewModel.squareViewModel)
            
            Spacer()
            
            Divider()
            
            Spacer()
            
            HStack {
                ForEach(viewModel.machineViewModels) { each in
                    MachineView(viewModel: each)
                }
            }
        }
    }
}


