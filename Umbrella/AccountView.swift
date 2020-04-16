//
//  AccountView.swift
//  Umbrella
//
//  Created by Ettore Zamponi on 28/03/2020.
//  Copyright © 2020 Ettore Zamponi. All rights reserved.
//

import SwiftUI

struct AccountView: View {
    @EnvironmentObject var session: SessionStore
    
    func getUser() {
        session.listen()
    }
    
    var body: some View {
        Group {
            if (session.session != nil) {
                Button(action: session.signOut) {
                    Text("Sign Out")
                        .fontWeight(.heavy)
                    Text("Ciao ancora di nuovo ancora nduoss")
                }
            } else {
                LoginView()
            }
        }.onAppear(perform: getUser)
        
    }
}

struct AccountView_Previews: PreviewProvider {
    static var previews: some View {
        AccountView().environmentObject(SessionStore())
    }
}
