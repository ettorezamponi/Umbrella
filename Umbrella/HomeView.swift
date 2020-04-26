//
//  HomeView.swift
//  Umbrella
//
//  Created by Ettore Zamponi on 28/03/2020.
//  Copyright © 2020 Ettore Zamponi. All rights reserved.
//

import SwiftUI
import SDWebImageSwiftUI
import Firebase

struct HomeView: View {
    @EnvironmentObject var session: SessionStore
    @State var url = ""
    @State var username = ""
    
    var body: some View {
        
        VStack {
            
            HStack {
                Text("Hello!")
                    .font(.system(size: 55))
                    .fontWeight(.heavy)
                    .padding(.leading)
                
                Spacer()
            }
            
            if (session.session?.email == nil) {
                HStack(alignment: .center) {
                    Image(systemName: Constants.accountImageAbsent)
                        .padding(.leading)
                        .frame(width: 60, height: 60)
                        .font(.system(size: 50))
                    
                    Text ("Accedi o registrati nella sezione account per avere tutte le funzionalità di questa app")
                        .font(.system(size: 25))
                        .fontWeight(.bold)
                        .frame(width:300, height: 150)
                    
                }.background(Color(red: 0.63, green: 0.81, blue: 0.96))
                    .cornerRadius(30).frame(width: 50)
                
            } else if (url != "") {
                HStack(alignment: .center) {
                    AnimatedImage(url: URL(string: url)).resizable().frame(width: 100, height: 150).clipShape(Circle())
                    
                    Text ("Bentornato, \(username)")
                        .font(.system(size: 25))
                        .fontWeight(.bold)
                        .frame(width:300, height: 150)
                    
                }.background(Color(red: 0.63, green: 0.81, blue: 0.96))
                    .cornerRadius(30).frame(width: 50)
                
            } else {
                //logged but without info
                HStack(alignment: .center) {
                    Loader()
                    
                    Text ("Tell us more about you in the account section")
                        .font(.system(size: 25))
                        .fontWeight(.bold)
                        .frame(width:300, height: 150)
                    
                }.background(Color(red: 0.63, green: 0.81, blue: 0.96))
                    .cornerRadius(30).frame(width: 50)
            }
            
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
        .onAppear(){
            let uid = Auth.auth().currentUser?.uid
            let storage = Storage.storage().reference()
            let db = Firestore.firestore()
            
            if (uid != nil) {
                storage.child("profilepics").child(uid!).downloadURL { (url, err) in
                    if err != nil {
                        print((err?.localizedDescription)!)
                        return
                    }
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
            } else {
                return
            }
        }
    }
}

struct Loader : UIViewRepresentable {
    func makeUIView(context: UIViewRepresentableContext<Loader>) -> UIActivityIndicatorView {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.startAnimating()
        return indicator
    }
    func updateUIView(_ uiView: UIActivityIndicatorView, context: UIViewRepresentableContext<Loader>) {
        
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
