//
//  SquareView.swift
//  AmusementPark
//
//  Created by kwangmin kim on 2021/04/29.
//

import SwiftUI

struct SquareView: View {
    @ObservedObject var viewModel: SquareViewModel
    
    private let columnSize = 20
    private var rowSize: Int { Int((Double(viewModel.people.count) / Double(columnSize)).rounded(.up)) }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack {
                Text("\(viewModel.people.count) people in")
                    .font(.subheadline)
                
                Text("Square")
                    .bold()
            }
            
            ForEach(0..<rowSize, id: \.self) { i in
                HStack {
                    ForEach(lowerBound(for: i)..<upperBound(for: i), id: \.self) { index in
                        ItemView(item: viewModel.people[index])
                            .background(Color.yellow)
                    }
                }
            }
        }
        .frame(height: 150)
    }
    
    func lowerBound(for row: Int) -> Int { row * columnSize }
    
    func upperBound(for row: Int) -> Int { min((row + 1) * columnSize, viewModel.people.count) }
}
