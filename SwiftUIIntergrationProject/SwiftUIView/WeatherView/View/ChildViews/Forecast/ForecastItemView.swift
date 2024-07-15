//
//  ForecastItemView.swift
//  SwiftUIIntergrationProject
//
//  Created by Abhishek Dilip Srivastava on 15/07/24.
//

import SwiftUI

struct ForecastItemView: View {
    var data: ForecastItemDisplayData
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8.0) {
            configureTextView(displayText: data.timeDateText)
            configureTextView(displayText: data.temperatureText, font: .subheadline)
            configureTextView(displayText: data.weatherText, font: .subheadline)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    @ViewBuilder
    func configureTextView(displayText: String, font: Font = .headline) -> some View {
        Text(displayText)
            .font(font)
            .foregroundStyle(.gray)
            .background(.clear)
            .multilineTextAlignment(.leading)
    }
}
