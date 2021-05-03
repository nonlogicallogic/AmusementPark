//
//  MachineView.swift
//  UnitTestSample
//
//  Created by kwangmin kim on 2021/04/27.
//

import SwiftUI

struct MachineView: View {
    @ObservedObject var viewModel: MachineViewModel
    
    var statusColor: Color {
        switch viewModel.status {
        case .ready: return Color.yellow
        case .operating: return Color.green
        }
    }
    
    func seatColor(_ seat: Seat) -> Color {
        if seat.person == nil {
            return .gray
        } else {
            return statusColor
        }
    }
    
    var accommodationColor: Color {
        if viewModel.needMorePeople {
            return .red
        } else {
            return .green
        }
    }
    
    private let columnSize = 2
    private var rowSize: Int { Int((Double(viewModel.seats.count) / Double(columnSize)).rounded(.up)) }
    
    func lowerBound(for row: Int) -> Int { row * columnSize }
    
    func upperBound(for row: Int) -> Int { min((row + 1) * columnSize, viewModel.seats.count) }

    var body: some View {
        VStack {
            Text(viewModel.name)
                .bold()
            
            Text("\(viewModel.status.rawValue)")
                .font(.headline)
                .foregroundColor(statusColor)
            
            if let remainingTime = viewModel.remaingTime {
                HStack(spacing: 0) {
                    ForEach(0..<remainingTime, id: \.self) { _ in
                        Color.green
                            .frame(width: 6, height: 6)
                    }
                    
                    ForEach(0..<(Int(viewModel.machine.configuration.runningDuration) - remainingTime), id: \.self) { _ in
                        Color.red
                            .frame(width: 6, height: 6)
                    }

                }
            }
            
            Text("\(viewModel.peopleOnSeat.count) on seat")
                .font(.subheadline)
            
            Text(viewModel.accommodationInfo)
                .font(.caption)
                .foregroundColor(accommodationColor)
            
            Text("\(viewModel.peopleInLine.count) in line")
                .font(.subheadline)
            
            
            if let img = viewModel.img {
                Image(img)
                    .resizable()
                    .frame(width: 150, height: 120)
                    .border(statusColor, width: 10)
            }
            
            ScrollView {
                VStack {
                    ForEach(0..<rowSize, id: \.self) { i in
                        HStack(spacing: 0) {
                            ForEach(lowerBound(for: i)..<upperBound(for: i), id: \.self) { index in
                                ItemView(item: viewModel.seats[index])
                                    .border(seatColor(viewModel.seats[index]), width: 1)
                            }
                        }
                    }
                    
                    Spacer()
                    
                    ForEach(viewModel.peopleInLine) { person in
                        ItemView(item: person)
                            .background(Color.orange)
                    }
                }
            }
        }
    }
}
