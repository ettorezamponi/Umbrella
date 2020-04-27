//
//  API.swift
//  Umbrella
//
//  Created by Ettore Zamponi on 27/04/2020.
//  Copyright © 2020 Ettore Zamponi. All rights reserved.

//api fetch request function

import SwiftUI

private let baseUrlForCurrentWeather = URL(string: "https://api.openweathermap.org/data/2.5/weather")!
private let appid = "f9d9fd2fce5fdc978a9748a0ddcda349"
private let baseUrlForWeeklyWeather = URL(string: "https://api.openweathermap.org/data/2.5/forecast/daily")!

//json decoder
private var decoder: JSONDecoder {
    let decode = JSONDecoder()
    decode.keyDecodingStrategy = .convertFromSnakeCase //this to make sure the key for our data value is converted from item_name to itemName
    return decode
}

class API {
    class func fetchCurrentWeather (by city: String, onSuccess: @escaping (Weather)->Void) {
        //make sure i have all the info to fetch data
        let query = ["q": "\(city)", "appid": appid, "units": "Metric"]
        
        guard let url = baseUrlForCurrentWeather.withQueries(query)
            else {
                fatalError()
        }
        URLSession.shared.dataTask(with: url) { (data, res, err) in
            guard let data = data, err == nil
                else { fatalError(err!.localizedDescription) }
            do {
                let weather = try decoder.decode(Weather.self, from: data)
                DispatchQueue.main.async {
                    onSuccess(weather)
                }
            } catch {
                fatalError(error.localizedDescription)
            }
        }.resume()
    }
}

extension URL {
    func withQueries (_ queries: [String: String]) -> URL? {
        guard var component = URLComponents(url: self, resolvingAgainstBaseURL: true)
            else {
                fatalError()
        }
        component.queryItems = queries.map { URLQueryItem(name: $0.key, value: $0.value) }
        return component.url
    }
}

