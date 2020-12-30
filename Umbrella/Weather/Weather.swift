//
//  Weather.swift
//  Umbrella
//
//  Created by Ettore Zamponi on 27/04/2020.
//  Copyright © 2020 Ettore Zamponi. All rights reserved.
//

import Foundation

//this is our model
class Weather: Codable {
    let id, dt, cod, timezone: Int //all Int value
    let name, base: String
    let coord: Coord
    let weather: [WeatherData]
    let main: Main
//    let clouds: Clouds
//    let sys: Sys
}

struct Coord: Codable {
    let lon, lat: Double
}

struct WeatherData: Codable, Identifiable {
    let id: Int
    let main, description, icon: String
}

struct Main: Codable {
    let temp, tempMin, tempMax: Double
    let pressure, humidity: Int
}

struct Clouds: Codable {
    let all: String
}

struct Sys: Codable {
    let id, type, sunrise, sunset: Int
    let country: String
}
