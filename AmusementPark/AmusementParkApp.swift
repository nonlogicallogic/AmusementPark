//
//  AmusementParkApp.swift
//  AmusementPark
//
//  Created by kwangmin kim on 2021/04/29.
//

import SwiftUI

@main
struct AmusementParkApp: App {
    let viewModel = AmusementParkViewModel()
    
    var body: some Scene {
        WindowGroup {
            AmusementParkView(viewModel: viewModel)
        }
    }
}
