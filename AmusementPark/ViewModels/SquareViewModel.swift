//
//  SquareViewModel.swift
//  AmusementPark
//
//  Created by kwangmin kim on 2021/04/30.
//

import Foundation
import Combine

final class SquareViewModel: ObservableObject {
    let square: Square
    
    @Published var people = [Person]()
    
    private var storage = Set<AnyCancellable>()
    
    init(square: Square) {
        self.square = square
        
        square
            .people
            .receive(on: RunLoop.main)
            .assign(to: &$people)
    }
}
