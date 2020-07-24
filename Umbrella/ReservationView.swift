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
                
                ZStack{
                    
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
                        .gridStyle(StaggeredGridStyle(tracks: 5, spacing: 20))
                        
                    }
                    
                }
            }
        //.navigationBarTitle("Booking")
       // }
    }
}




struct ChairViewTry: View {
    @ObservedObject var umbrella: Umbrella
    let db = Firestore.firestore()
    
    var body: some View {
        
        VStack(spacing: 4) {
            Circle()
                .frame(width: 32, height: 32)
                .foregroundColor(self.umbrella.available ? Color.green : Color.red)
        }.onTapGesture {
            //self.db.collection("umbrellaXY").document(self.Umbrell)
            //var x = self.Umbrell.data
            //var y = x.map {$0.id}
            //print(y)
            self.db.collection("umbrellaXY").document(self.umbrella.id).updateData(["available": false])
        }.disabled(self.umbrella.available == false)
    }
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
                    let umbrellas = i.document.get("number") as! String
                    for i in 0..<self.data.count {
                        if self.data[i].id == id {
                            self.data[i].number = umbrellas
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
