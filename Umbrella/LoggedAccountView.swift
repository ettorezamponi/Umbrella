//
//  LoggedAccountView.swift
//  Umbrella
//
//  Created by Ettore Zamponi on 17/04/2020.
//  Copyright © 2020 Ettore Zamponi. All rights reserved.
//

import SwiftUI
import Firebase
import FirebaseStorage
import SDWebImageSwiftUI

struct LoggedAccountView: View {
    @EnvironmentObject var session: SessionStore
    @State var isModal: Bool = false
    @State var url = ""
    @State var username = ""
    
    var body: some View {
        VStack{
            VStack(alignment: .center){
                HStack(alignment: .center) {
                    
                    if url.count < 6 {
                        Image(systemName: Constants.accountImageAbsent)
                        .padding(.leading)
                        .frame(width: 60, height: 60)
                        .font(.system(size: 50))
                        
                    } else {
                        AnimatedImage(url: URL(string: url)).resizable().frame(width: 100, height: 150).clipShape(Circle())
                    }
                    
                    if username.count > 0 {
                        Text ("Welcome back \(username)")
                            .font(.system(size: 25))
                            .fontWeight(.bold)
                            .frame(width:250, height: 60)
                    } else {
                        Text ("Welcome, tell us more about you")
                        .font(.system(size: 25))
                        .fontWeight(.bold)
                        .frame(width:250, height: 60)
                    }
                }
                
                Button("Edit info") {
                    self.isModal = true
                    }.sheet(isPresented: $isModal, content: {
                        EditProfileView()
                    }).foregroundColor(Color.blue)
                }
            .padding(.top, 50)
            .onAppear(){
                let uid = Auth.auth().currentUser?.uid
                let storage = Storage.storage().reference()
                let db = Firestore.firestore()
                
                storage.child("profilepics").child(uid!).downloadURL { (url, err) in
                    if err != nil {
                        print((err?.localizedDescription)!)
                        return
                    }
                    //controllo da implementare se visualizzare l'immagine di default per l'utente
                    self.url = "\(url!)"
                }
                
                db.collection("users").document(uid!).getDocument { (document, error) in
                    if let document = document, document.exists {
                        let property = document.get("username")
                        self.username = property as! String
                    } else {
                        print("Document does not exist")
                    }
                }
            }
            
            Spacer()
            
            VStack{
                VStack{
                    Text ("Booking")
                        .font(.system(size: 22))
                        .fontWeight(.semibold)
                        .padding(.leading)
                    
                    Text("Prenotazione dal 12/7 al 16/7")
                        .font(.system(size: 15))
                }
                .frame(width:365, height: 80)
                .padding(.bottom, 40)
                .background(Color(red: 0.63, green: 0.81, blue: 0.96))
                .cornerRadius(20)
                
                Spacer()
                
                VStack{
                    Text("Reviews")
                        .font(.system(size: 22))
                        .fontWeight(.semibold)
                        .frame(height: 100)
                    
                    Text("Stabilimento molto pulito e tenuto maniacalmente. Un paradiso per i bagnanti. Tornerò presto a trovarvi, servizio super gentile ed educato")
                        .font(.system(size: 15))
                        .padding(.bottom, 15)

                    
                    Divider()
                    
                    Text("Sono tornato una seconda volta con la mia famiglia e le buone impressioni sono state confermate !! Complimneti allo staff")
                    .font(.system(size: 15))
                        .padding(.top, 15)
                }
                .frame(width:365, height: 300)
                .padding(.bottom, 30.0)
                .padding(.horizontal, 10.0)
                .background(Color.yellow)
                .cornerRadius(20)
                
            }
            
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
