//
//  SwiftUIMixController.swift
//  SwiftUIIntergrationProject
//
//  Created by Yuchen Nie on 4/9/24.
//

import Foundation
import UIKit
import SwiftUI

class SwiftUIController: UIViewController {
    override func viewDidLoad() {
        let swiftUIView = SwiftUIView(viewModel: WeatherViewModel())
        let hosting = UIHostingController(rootView: swiftUIView)
        addChild(hosting)
        view.addSubview(hosting.view)
        hosting.view.snp.updateConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
