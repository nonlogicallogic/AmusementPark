//
//  ItemView.swift
//  UnitTestSample
//
//  Created by kwangmin kim on 2021/04/27.
//

import SwiftUI

protocol Naming {
    var name: String { get }
}

struct ItemView<Item: Naming>: View {
    
    let item: Item
    
    var body: some View {
        Text(item.name)
            .font(.system(size: 13, weight: .medium))
            .frame(width: 40, height: 20, alignment: .center)
    }
}
