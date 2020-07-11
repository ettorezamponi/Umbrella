  
//
//  CheckoutView.swift
//  Umbrella
//
//  Created by Ettore Zamponi on 08/07/2020.
//  Copyright © 2020 Ettore Zamponi. All rights reserved.
//
import SwiftUI

struct CheckoutView: View {
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack{
            HStack {
                Text("Disposition")
                    .font(.system(size: 45))
                    .fontWeight(.heavy)
                    .padding(.leading)
                
                Spacer()
            }
            HStack(alignment: .center) {
                Image(systemName: Constants.accountImageAbsent)
                    .padding(.leading)
                    .frame(width: 100, height: 100)
                    .font(.system(size: 50))
                
                Text ("Tre ombrelloni in prima fila")
                    .font(.system(size: 20))
                    .fontWeight(.regular)
                    .frame(width:300, height: 150)
            }
            HStack{
                Text("Duration: 7 giorni")
                    .font(.system(size: 10))
                
                Text("Total: €63")
                .font(.system(size: 12))
                    .fontWeight(.heavy)
            }
             Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                 }) {
                   Text("Pay Now")
                 }
            .frame(minWidth: 0, maxWidth: .infinity)
            .frame(height: 50)
            .foregroundColor(.white)
            .font(.system(size: 16, weight: .bold))
            .background(Color.black)
            .cornerRadius(20)
            .padding(.horizontal, 32)
            .padding(.bottom, 10)
            
        }
    }
}

struct CheckoutView_Previews: PreviewProvider {
    static var previews: some View {
        CheckoutView()
    }
}
