//
//  AddressButtonList.swift
//  SwiftUIIntergrationProject
//
//  Created by Abhishek Dilip Srivastava on 15/07/24.
//

import SwiftUI

struct AddressButtonList<ViewModel>: View where ViewModel: WeatherViewModelable {
    @ObservedObject var viewModel: ViewModel

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(viewModel.addressList.indices, id: \.self) { indexOfAddress in
                    Button(action: {
                        viewModel.getCurrentWeatherAndForecast(address: viewModel.addressList[indexOfAddress])
                    }, label: {
                        Text("Address \(indexOfAddress + 1)")
                    })
                    .padding(10)
                    .foregroundColor(.blue.opacity(0.9))
                    .background(.blue.opacity(0.4))
                    .cornerRadius(8)
                }
            }
            .padding()
        }
    }
}
