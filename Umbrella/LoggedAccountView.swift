//
//  LoggedAccountView.swift
//  Umbrella
//
//  Created by Ettore Zamponi on 17/04/2020.
//  Copyright © 2020 Ettore Zamponi. All rights reserved.
//

import SwiftUI

struct LoggedAccountView: View {
    @EnvironmentObject var session: SessionStore
    
    var body: some View {
        VStack{
            HStack {
                Text("Account")
                    .font(.system(size: 50))
                    .fontWeight(.heavy)
                    .padding(.leading)
                
                Spacer()
            }
            Spacer()
            
            Button(action: session.signOut) {
                Text("Sign Out")
                    .frame(width: 310, height: 55)
                    .foregroundColor(.white)
                    .font(.system(size: 16, weight: .bold))
                    .background(Color.black)
                    .cornerRadius(20)
            }
        }
    }
}

struct LoggedAccountView_Previews: PreviewProvider {
    static var previews: some View {
        LoggedAccountView()
    }
}
