//
//  CurrentWeatherViewModel.swift
//  Umbrella
//
//  Created by Ettore Zamponi on 27/04/2020.
//  Copyright © 2020 Ettore Zamponi. All rights reserved.
//
// viewmodel between view and api service request, this model will update our view based on single property marked as @Published (very powerfulof swiftUI Combine)

import SwiftUI
import Combine

final class CurrentWeatherViewModel: ObservableObject {
    @Published var current : Weather?
    
    init () {
        self.fetch()
    }
}

extension CurrentWeatherViewModel {
    func fetch (_ city: String = "ancona") {
        API.fetchCurrentWeather(by: city) {
            self.current = $0
        }
    }
}
