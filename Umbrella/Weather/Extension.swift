//
//  Extension.swift
//  Umbrella
//
//  Created by Ettore Zamponi on 27/04/2020.
//  Copyright © 2020 Ettore Zamponi. All rights reserved.
//

import Foundation

extension Double {
    var round: Int {
        return Int(self)
    }
}

extension URL {
    func withQueries (_ queries: [String: String]) -> URL? {
        guard var component = URLComponents(url: self, resolvingAgainstBaseURL: true) else {
            fatalError()
        }
        component.queryItems = queries.map { URLQueryItem(name: $0.key, value: $0.value)}
        return component.url
    }
}
//
//extension DateFormatter{
//    convenience init (dateFormat: String) {
//        self.init()
//        self.dateFormat = dateFormat
//    }
//}
//
//extension Date {
//    static func dateFromUnixTimestamp (_ timestamp: TimeInterval) -> Date {
//        return Date(timeIntervalSince1970: timestamp)
//    }
//
//    var day : String{
//        let dateFormatter = DateFormatter(dateFormat: "EEEE")
//        return dateFormatter.string(from: self)
//    }
//}
//
//func dayOfTheWeekFromTimestamp (_ timestamp: TimeInterval) -> String {
//    let date = Date.dateFromUnixTimestamp(timestamp)
//    return date.day
//}
