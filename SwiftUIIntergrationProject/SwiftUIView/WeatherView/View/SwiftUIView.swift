//
//  SwiftUIMixView.swift
//  SwiftUIIntergrationProject
//
//  Created by Yuchen Nie on 4/8/24.
//

import Foundation
import SwiftUI

// TODO: Create SwiftUI View that either pre-selects address or user enters address, and retrieves current weather plus weather forecast
struct SwiftUIView<ViewModel>: View where ViewModel: WeatherViewModelable {
    @ObservedObject var viewModel: ViewModel
    @State private var isShowingError = false
    @State private var isLoading = false

    var body: some View {
        GeometryReader(content: { geometry in
            VStack {
                AddressButtonList(viewModel: viewModel)
                WeatherReportDetailView(viewModel: viewModel)
                ForecastListView(viewModel: viewModel)
            }
        })
        .onAppear(perform: {
            viewModel.getCurrentWeatherAndForecast(address: viewModel.addressList[0])
        })
        .alert(isPresented: $isShowingError) {
            Alert(
                title: Text("An error occured"),
                message: Text(viewModel.errorMessage ?? "Error fetching weather report at the moment."),
                dismissButton: .default(Text("Ok")) {
                    isShowingError = false
                    viewModel.errorMessage = nil
                }
            )
        }
        .onChange(of: viewModel.errorMessage) { _ , _ in
            isShowingError = viewModel.errorMessage != nil ? true : false
        }
    }
}
