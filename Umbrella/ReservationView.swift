//
//  ReservationView.swift
//  Umbrella
//
//  Created by Ettore Zamponi on 12/07/2020.
//  Copyright © 2020 Ettore Zamponi. All rights reserved.
//

import SwiftUI
import Firebase
import Grid

struct ReservationView: View {
    var body: some View {
        Reservation()
    }
}

struct ReservationView_Previews: PreviewProvider {
    static var previews: some View {
        ReservationView()
    }
}

struct Reservation : View {
    @ObservedObject var Umbrell = getUmbrella()
    @State var docnumber = ""
    @State var docID = ""
    @State var docavailable = ""
    
    var body: some View {
        
        //NavigationView {
            
            VStack{
                
                HStack {
                    Text("Booking")
                        .font(.system(size: 30))
                        .fontWeight(.heavy)
                        .padding(.leading, 15)
                        .padding(.top, 50)
                    
                    Spacer()
                }
                
                ZStack{
                    
                    Rectangle()
                        .fill(LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.3), .clear]) , startPoint: .init(x: 0.5, y: 0.0), endPoint: .init(x: 0.5, y: 0.5)) )
                        .frame(height: 420)
                        .clipShape(ScreenShape(isClip: true))
                        .cornerRadius(20)
                    
                    ScreenShape()
                        .stroke(style:  StrokeStyle(lineWidth: 5,  lineCap: .square ))
                        .frame(height: 420)
                        .foregroundColor(Color.blue)
                    
                    if self.Umbrell.data.isEmpty {
                        Text("Database updating...")
                    }
                    else
                    {
                        Grid(self.Umbrell.data){ i in
                            Button(action: {
                                self.docID = i.id
                                self.docnumber = i.number
                                //print(i.id)
                                
                            }) {
                                HStack{
                                    ChairViewTry(umbrella: i)
                                }
                            }
                        }
                        .gridStyle(StaggeredGridStyle(tracks: 5, spacing: 15))
                        
                    }
                    
                }
                ZStack{
                    RoundedRectangle(cornerRadius: 10).stroke(Color.blue, lineWidth: 1).frame(width: 330, height: 60).padding(.bottom, 70).padding(.horizontal, 20)
                    createSeatsLegend()
                }
            }
        //.navigationBarTitle("Booking")
       // }
    }
    
    fileprivate func createSeatsLegend() -> some View{
        HStack{
            //ChairLegend(text: "Selected", color: .blue)
            ChairLegend(text: "Reserved", color: .red)
            ChairLegend(text: "Available", color: .green)
        }.padding(.horizontal, 20)
         .padding(.bottom, 70)
    }
    
}




struct ChairViewTry: View {
    @ObservedObject var umbrella: Umbrella
    let db = Firestore.firestore()
    @EnvironmentObject var session: SessionStore
    @State private var showingAlert = false
     @State private var alertItem: AlertItem?
    
    var body: some View {
        
//        if (session.session?.email == nil) {
//            logged = false
//        } else {
//            logged = true
//        }
        
//        VStack(spacing: 4) {
//            Circle()
//                .frame(width: 32, height: 32)
//                .foregroundColor(self.umbrella.available ? Color.green : Color.red)
//        }.onTapGesture {
//
//            self.db.collection("umbrellaXY").document(self.umbrella.id).updateData(["available": false])
//            self.showingAlert = true
//            self.foregroundColor(Color.red)
//
//        }.allowsHitTesting(true)
//        .alert(isPresented: $showingAlert) {
        //            Alert(title: Text("Umbrella reserved"), message: Text("Your umbrella is booked, close and re-open the app to see your position reserved"), dismissButton: .default(Text("OK")))
        //        }
        VStack{
            
            Button (action: {
                if (self.session.session?.email == nil) {
                    
                    self.alertItem = AlertItem(title: Text("Account missing"), message: Text("You need to log in or sign in to book your umbrella"), dismissButton:.cancel(Text("Ok")))
                
                } else if (self.umbrella.available) {
                    
                    self.db.collection("umbrellaXY").document(self.umbrella.id).updateData(["available": false])
                    self.alertItem = AlertItem(title: Text("Umbrella reserved"), message: Text("Successful confirmation, enjoy your holiday"), dismissButton:.cancel(Text("Ok")))
                } else {
                    self.alertItem = AlertItem(title: Text("Umbrella not available"), message: Text("You can not reserve this umbrella, try with another available"), dismissButton:.cancel(Text("Ok")))

                }
                
            }) {
                Circle()
                    .frame(width: 32, height: 32)
                    .foregroundColor(self.umbrella.available ? Color.green : Color.red)
            }
                //.disabled(session.session?.email == nil && self.umbrella.available)
                .alert(item: $alertItem) {
                    alertItem in
                    Alert(title: alertItem.title, message: alertItem.message, dismissButton: alertItem.dismissButton)
            }
        }
    }
}

struct AlertItem: Identifiable {
    var id = UUID()
    var title: Text
    var message: Text?
    var dismissButton: Alert.Button?
}


class getUmbrella : ObservableObject {
    @Published var data = [Umbrella]()
    
    init() {
        
        let db = Firestore.firestore()
        
        db.collection("umbrellaXY").addSnapshotListener { (snap, err) in
            if err != nil {
                print((err?.localizedDescription)!)
                return
            } else if (snap?.documentChanges.isEmpty)! {
                Text("DATABASE EMPTY")
            }
            
            for i in snap!.documentChanges {
                
                if i.type == .added {
                    let id = i.document.documentID
                    let umbrellas = i.document.get("number") as! String
                    let available = i.document.get("available") as! Bool
                    self.data.append(Umbrella(id: id, number: umbrellas, available: available))
                }
                
                if i.type == .modified {
                    let id = i.document.documentID
                    let umbrellas = i.document.get("available") as! Bool
                    for i in 0..<self.data.count {
                        if self.data[i].id == id {
                            self.data[i].available = umbrellas
                        }
                    }
                }
            }
        }
    }
    
}

class Umbrella : ObservableObject, Identifiable {
    var id : String
    var number : String
    @Published var available : Bool
    
    init(id: String, number: String, available: Bool) {
        self.id = id
        self.number = number
        self.available = available
    }
}
