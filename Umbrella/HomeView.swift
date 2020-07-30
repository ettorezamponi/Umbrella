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
    @State var receipe = ""
    //per il meteo
    @State private var selected = 0
    @ObservedObject var weather = CurrentWeatherViewModel()
    
    func getUser() {
        session.listen()
    }
    
    var body: some View {
        
        NavigationView {
        
            VStack {
                
                if (session.session == nil) {
                    
                    HStack(alignment: .center) {
                        
                        Image(systemName: Constants.accountImageAbsent)
                            .padding(.leading)
                            .frame(width: 60, height: 120)
                            .font(.system(size: 50))
                            .foregroundColor(.white)

                        Text ("Log in or sign in to use all functionalities of this app")
                            .font(.system(size: 25))
                            .fontWeight(.bold)
                            .frame(width:285, height: 140)
                            .foregroundColor(.white)
                        
                    }
                     .background(Color(red: 0.90, green: 0.18, blue: 0.15))
                     .cornerRadius(30)
                     .frame(width: 60)
                    
                } else if (url != "") {
                    
                    HStack(alignment: .center) {
                        AnimatedImage(url: URL(string: url)).resizable()
                            .frame(width: 90, height: 120)
                            .clipShape(Circle())
                            .padding(.leading)
                        
                        Text ("Welcome back, \(username)")
                            .font(.system(size: 22))
                            .fontWeight(.bold)
                            .frame(width:245, height: 140)
                            .foregroundColor(.white)

                        
                    }.background(Color(red: 0.63, green: 0.81, blue: 0.96))
                     .cornerRadius(30)
                     .frame(width: 50)
                    
                } else {
                    //logged but without info
                    HStack(alignment: .center) {
                        
                        Image(systemName: Constants.accountImageAbsent)
                            .padding(.leading)
                            .frame(width: 65, height: 50)
                            .font(.system(size: 50))
                            .foregroundColor(.white)
                        
                        Text ("Tell us more about you in the account section")
                            .font(.system(size: 25))
                            .fontWeight(.bold)
                            .frame(width:285, height: 140)
                            .foregroundColor(.white)

                    }.background(Color(red: 0.63, green: 0.81, blue: 0.96))
                     .cornerRadius(30)
                     .frame(width: 50)
                }
                
                HStack {
                    //Weather and Maps
                    VStack{
                        VStack{
                            GeometryReader { gr in
                                CurrentWeather(weather: self.weather.current, height: self.selected == 0 ? gr.size.height: gr.size.height * 0.50).animation(.easeInOut(duration: 0.5))
                            }
    //                        VStack {
    //                            Picker ("", selection: $selected) {
    //                                Text("Today")
    //                                .tag(0)
    //                                Text("Week")
    //                                .tag(1)
    //                            }.pickerStyle(SegmentedPickerStyle()).padding(.horizontal)
    //                        }
                        }.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity).cornerRadius(30)
                        
                        VStack{
                            Maps()
    //                        Image(systemName: Constants.positionImage)
    //                            .padding(.top, 30.0)
    //                            .frame(width: 60, height: 60)
    //                            .font(.system(size: 50))
    //
    //                        Text ("ecco le indicazioni!")
    //                            .font(.headline)
    //                            .frame(width:175, height:125)
                        }.cornerRadius(30)
                    }.padding(.horizontal, 8)
                     //.padding(.vertical, 6)
                    
                    VStack {
                        Image(systemName: Constants.forkImage)
                            .padding(.top, 60.0)
                            .frame(width: 60, height: 60)
                            .font(.system(size: 50))
                            .foregroundColor(.white)
                        
                        if (receipe.count > 5) {
                            
                            Text ("\(receipe)")
                            .font(.headline)
                            .font(.system(size: 45))
                            .frame(width:140, height:340)
                            .padding(.horizontal)
                            .foregroundColor(.white)
                            
                        } else {
                            
                            Text ("Menu non ancora aggiornato!")
                                .font(.headline)
                                .frame(width:170, height:340)
                                .foregroundColor(.white)
                            
                        }
                    }
                     .background(Color(red: 0.45, green: 0.70, blue: 0.60))
                     .cornerRadius(30)
                     .padding(.horizontal, 10)
                    
                    
                }.padding(.bottom, 30)
                    
            }
            .navigationBarTitle("Home")
            .onAppear(){
                let uid = Auth.auth().currentUser?.uid
                let storage = Storage.storage().reference()
                let db = Firestore.firestore()
                //get week day
                let date = Date()
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "EEEE"
                let dayInWeek = dateFormatter.string(from: date)
                
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
                    db.collection("restaurants").document(dayInWeek).getDocument { (document, error) in
                        if let document = document, document.exists {
                            let prop = document.get("receipe")
                            self.receipe = prop as! String
                        } else {
                            print("Document does not exist")
                        }
                    }
                } else {
                    
                    db.collection("restaurants").document(dayInWeek).getDocument { (document, error) in
                        if let document = document, document.exists {
                            let prop = document.get("receipe")
                            self.receipe = prop as! String
                        } else {
                            print("Document does not exist")
                        }
                    }
                    return
                }
                
                }
            
        }
        //per caricare subito l'utente loggato nella home al primo avvio
        .onAppear(perform: getUser)
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
