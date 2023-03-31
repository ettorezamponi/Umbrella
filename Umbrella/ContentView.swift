//
//  ContentView.swift
//  Umbrella
//
//  Created by Ettore Zamponi on 24/02/2020.
//  Copyright © 2020 Ettore Zamponi. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedSeats: [Seat] = []
    
    //test for GIT, da eliminare
    
    init() {
        UITabBar.appearance().backgroundColor = UIColor.white
    }
    
    @State var selected = 0
    
    var body: some View {
        
        TabView(selection: $selected) {
            HomeView().tabItem({
                Image(systemName: Constants.TabBarImage.tabBar0)
                Text("\(Constants.TabBarText.tabBar0)")
            }).tag(0)
            
            ReservationView().tabItem({
                Image(systemName: Constants.TabBarImage.tabBar1)
                Text("\(Constants.TabBarText.tabBar1)")
            }).tag(1)
            
            ReviewsView().tabItem({
                Image(systemName: Constants.TabBarImage.tabBar2)
                Text("\(Constants.TabBarText.tabBar2)")
            }).tag(2)
            
            AccountView().tabItem({
                Image(systemName: Constants.TabBarImage.tabBar3)
                Text("\(Constants.TabBarText.tabBar3)")
            }).tag(3)
        }.accentColor(Color.blue)
    }
}

#if DEBUG
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView() //quale view mostrare nel canvas
    }
}
#endif
