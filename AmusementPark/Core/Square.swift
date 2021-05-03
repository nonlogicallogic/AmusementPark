//
//  Square.swift
//  AmusementPark
//
//  Created by kwangmin kim on 2021/04/29.
//

import Foundation
import Combine

final class Square {
    
    lazy var people: AnyPublisher<[Person], Never> = { _people.eraseToAnyPublisher() }()
    
    private var _people = CurrentValueSubject<[Person], Never>([])
    
    private let serialQueue: DispatchQueue
    
    init(queue: DispatchQueue? = nil) {
        if let queue = queue {
            self.serialQueue = queue
        } else {
            self.serialQueue = DispatchQueue(label: "squre-queue")
        }
    }
}


extension Square: Place {

    func welcome(_ person: Person) {
        serialQueue.async { [weak self] in
            self?._people.value.append(person)
        }
    }
    
    func farewell(_ person: Person) {
        serialQueue.async { [weak self] in
            guard let self = self else { return }
            if let index = self._people.value.firstIndex(of: person) {
                self._people.value.remove(at: index)
            }
        }
    }
}
