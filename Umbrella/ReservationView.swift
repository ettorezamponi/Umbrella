//
//  ReservationView.swift
//  Umbrella
//
//  Created by Ettore Zamponi on 12/07/2020.
//  Copyright © 2020 Ettore Zamponi. All rights reserved.
//

import SwiftUI
import Firebase

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
    let row = 3
    let numberPerRow = 5
    
    var body: some View {
        VStack{
            
            HStack {
                Text("Booking")
                    .font(.system(size: 45))
                    .fontWeight(.heavy)
                    .padding(.leading)
                
                Spacer()
            }
            
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
                        
                        ForEach(self.Umbrell.data){ i in
                            
                            HStack {
                                
                                Button(action: {
                                    self.docID = i.id
                                    self.docnumber = i.number
                                    print(i.id)
                                    
                                }) {
                                    HStack{
                                        ChairViewTry()
                                    }
                                }
                            }
                            
                        }
                     
                }
                
            }
        }
    }
}




struct ChairViewTry: View {
    @State private var TAP: Bool = true
    @ObservedObject var Umbrell = getUmbrella()
    let db = Firestore.firestore()
    //let uid = Umbrella.ID.self as! String
    
    var body: some View {
        
        VStack(spacing: 4) {
            Circle()
                .frame(width: 32, height: 32)
                .foregroundColor(TAP ? Color.green : Color.red)
        }.onTapGesture {
            //self.db.collection("umbrellaXY").document(self.Umbrell)
            //var x = self.Umbrell.data
            //var y = x.map {$0.id}
            //print(y)
            self.TAP = false
            //db.collection("umbrellaXY").document(x).setData
        }
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

struct Umbrella : Identifiable {
    var id : String
    var number : String
    var available : Bool
    
    init(id: String, number: String, available: Bool) {
        self.id = id
        self.number = number
        self.available = available
    }
}
