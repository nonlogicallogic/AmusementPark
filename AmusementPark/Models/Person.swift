//
//  Person.swift
//  UnitTestSample
//
//  Created by kwangmin kim on 2021/04/28.
//

import Combine
import Foundation

struct Person: Naming, Equatable {
    
    static var count = 1
    
    let name = "\(count)"
    
    static func == (lhs: Person, rhs: Person) -> Bool { lhs.name == rhs.name }
    
    init() {
        Person.count += 1
    }
}

extension Person: Identifiable {
    var id: String { name }
}

extension Person {
    func enter(_ place: Place) {
        place.welcome(self)
    }
    
    func exit(_ place: Place) {
        place.farewell(self)
    }
}
