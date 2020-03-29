//
//  AccountView.swift
//  Umbrella
//
//  Created by Ettore Zamponi on 28/03/2020.
//  Copyright © 2020 Ettore Zamponi. All rights reserved.
//

import SwiftUI

struct AccountView: View {
    var body: some View {
        VStack{
            HStack {
                Text("Login")
                    .font(.system(size: 55))
                    .fontWeight(.heavy)
                    .padding(.leading)
                
                Spacer()
            }
            Spacer()
        }
    }
}

struct AccountView_Previews: PreviewProvider {
    static var previews: some View {
        AccountView()
    }
}
