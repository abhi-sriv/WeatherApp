//
//  WeatherReportDetailView.swift
//  SwiftUIIntergrationProject
//
//  Created by Abhishek Dilip Srivastava on 15/07/24.
//

import SwiftUI

struct WeatherReportDetailView<ViewModel>: View where ViewModel: WeatherViewModelable {
    @ObservedObject var viewModel: ViewModel
    
    var body: some View {
        VStack(alignment: .center) {
            if let weatherData = viewModel.weatherDisplayData {
                configureTextView(displayText: weatherData.nameOfLocationText)
                configureTextView(displayText: weatherData.currentWeatherText, font: .callout)
                configureTextView(displayText: weatherData.temperatureText, font: .subheadline)
            } else {
                Text("Report unavailable")
                    .foregroundColor(.gray.opacity(0.8))
                    .border(.gray, width: 1)
                    .padding()
            }
        }
    }
    
    @ViewBuilder
    func configureTextView(displayText: String, font: Font = .title) -> some View {
        Text(displayText)
            .font(font)
            .multilineTextAlignment(.center)
            .padding(6)
    }
}
