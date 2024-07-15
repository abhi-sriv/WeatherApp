//
//  ForcastView.swift
//  SwiftUIIntergrationProject
//
//  Created by Abhishek Dilip Srivastava on 15/07/24.
//

import SwiftUI

struct ForecastListView<ViewModel>: View where ViewModel: WeatherViewModelable {
    @ObservedObject var viewModel: ViewModel
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            ForEach(viewModel.forecast?.forecastItems ?? [ForecastItemDisplayData](), id: \.self) { item in
                ForecastItemView(data: item)
                Divider()
                    .padding(.vertical)
            }
            .padding(10)
            .background(Color.clear)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.primary)
    }
}

#Preview {
    ForecastListView(viewModel: WeatherViewModel())
}
