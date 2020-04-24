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
    @State var isModal: Bool = false
    
    var body: some View {
        VStack{
            VStack{
                HStack(alignment: .center) {
                    Image(systemName: Constants.accountImageAbsent)
                        .padding(.leading)
                        .frame(width: 60, height: 60)
                        .font(.system(size: 50))
                    
                    Text ("Ciao, \((session.session?.email ?? "inserisci il tuo username"))")
                        .font(.system(size: 25))
                        .fontWeight(.bold)
                        .frame(width:300, height: 150)
                }
                Button("Edit info") {
                    self.isModal = true
                }.sheet(isPresented: $isModal, content: {
                    EditProfileView()
                })
            }
            
            
            HStack(alignment: .center) {
                VStack{
                    Text ("Booking")
                        .font(.system(size: 22))
                        .fontWeight(.bold)
                        .frame(width:300, height: 150)
                    
                    Text("Prenotazione dal 12/7 al 16/7")
                        .font(.system(size: 15))
                }
            }.background(Color(red: 0.63, green: 0.81, blue: 0.96))
                .cornerRadius(30)
            
            HStack(alignment: .center) {
                VStack{
                    Text("Reviews")
                        .font(.system(size: 22))
                        .fontWeight(.bold)
                        .frame(width:300, height: 150)
                    
                    Text("Stabilimento molto pulito e tenuto maniacalmente. Un paradiso per i bagnanti. Tornerò presto a trovarvi, servizio super gentile ed ecuato")
                        .font(.system(size: 15))
                }
            }.background(Color.yellow).cornerRadius(30)
            
            Spacer()
            
            Button(action: session.signOut) {
                Text("Sign Out")
                    .frame(width: 310, height: 55)
                    .foregroundColor(.red)
                    .font(.system(size: 16, weight: .bold))
                    .background(Color.white)
                    .cornerRadius(20)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.black, lineWidth: 1))
                
            }
            .padding(.bottom, 10.0)
        }
    }
}

struct LoggedAccountView_Previews: PreviewProvider {
    static var previews: some View {
        LoggedAccountView()
    }
}
