//
//  HomeView.swift
//  Umbrella
//
//  Created by Ettore Zamponi on 28/03/2020.
//  Copyright © 2020 Ettore Zamponi. All rights reserved.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var session: SessionStore
    
    
    var body: some View {
        
        
        VStack {
            
            HStack {
                Text("Hello!")
                    .font(.system(size: 55))
                    .fontWeight(.heavy)
                    .padding(.leading)
                    
                Spacer()
            }
            
            HStack(alignment: .center) {
                Image(systemName: Constants.accountImageAbsent)
                    .padding(.leading)
                    .frame(width: 60, height: 60)
                    .font(.system(size: 50))
                
                Text ("Ciao, \(session.session?.email ?? "log in to insert your info")")
                    .font(.system(size: 25))
                    .fontWeight(.bold)
                    .frame(width:300, height: 150)
                
            }.background(Color(red: 0.63, green: 0.81, blue: 0.96))
                .cornerRadius(30)
            
            HStack {
                VStack{
                    VStack{
                        Image(systemName: Constants.sunTry)
                            .padding(.top, 30.0)
                            .frame(width: 60, height: 60)
                            .font(.system(size: 50))
                        
                        Text ("bella giornata!")
                            .font(.headline)
                            .frame(width:175, height:125)
                    }.background(Color.orange).cornerRadius(30)
                    
                    VStack{
                        Image(systemName: Constants.positionImage)
                            .padding(.top, 30.0)
                            .frame(width: 60, height: 60)
                            .font(.system(size: 50))
                        
                        Text ("ecco le indicazioni!")
                            .font(.headline)
                            .frame(width:175, height:125)
                    }.background(Color.yellow).cornerRadius(30)
                }
                
                VStack{
                    Image(systemName: Constants.forkImage)
                        .padding(.top, 30.0)
                        .frame(width: 60, height: 60)
                        .font(.system(size: 50))
                    
                    Text ("il menu del giorno propone: spaghetti alle vongole, arrosto misto alla brace")
                        .font(.headline)
                        .frame(width:175, height:330)
                }.background(Color.green).cornerRadius(30)
                
            }
            
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
