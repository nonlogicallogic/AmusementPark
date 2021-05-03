//
//  TitleView.swift
//  UnitTestSample
//
//  Created by kwangmin kim on 2021/04/27.
//

import SwiftUI

struct TitleView: View {
    let title: String
    
    var body: some View {
        Text(title)
            .font(.subheadline)
            .padding(5)
            .foregroundColor(.black)
    }
}
