//
//  CurrentWeather.swift
//  Umbrella
//
//  Created by Ettore Zamponi on 27/04/2020.
//  Copyright © 2020 Ettore Zamponi. All rights reserved.
//

import SwiftUI

struct CurrentWeather: View {
    var weather: Weather?
    var height: CGFloat = 0
    
    var body: some View {
        
        VStack(alignment: .center, spacing: 18) {
            Text("Today in \(weather?.name ?? "Unkown")")
                .font(.title)
                .foregroundColor(.white)
                .bold()
                .frame(width: 135)
                .multilineTextAlignment(.center)
            
            HStack {
                
                Text("\(weather?.main.temp.round ?? 0)°")
                    .foregroundColor(.white)
                    .fontWeight(Font.Weight.heavy)
                    .font(.system(size: 24))
                    .multilineTextAlignment(.center)
            }
            Text("\(weather?.weather.last?.description ?? "unkown")")
                .foregroundColor(.white)
                .font(.body)
                .underline()
                .multilineTextAlignment(.center)
            
//            Text("\(weather?.main.tempMax.round ?? 0)")
//                .foregroundColor(.white)
//                .font(.body)
            
//teoricamente "width: width" ma con un valore il testo viene centrato meglio
        }.frame(width: 183, height: height)
            .background(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .topLeading, endPoint: .bottomTrailing))
    }
}

struct CurrentWeather_Previews: PreviewProvider {
    static var previews: some View {
        CurrentWeather()
    }
}
