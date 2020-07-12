//
//  BeachView.swift
//  Umbrella
//
//  Created by Ettore Zamponi on 08/07/2020.
//  Copyright © 2020 Ettore Zamponi. All rights reserved.
//
//

import SwiftUI


struct TheatreView: View {
    @State var isModal: Bool = false
    @Binding var selectedSeats:[Seat]
    
    var body: some View {
        VStack{
            HStack {
                Text("Disposition")
                    .font(.system(size: 45))
                    .fontWeight(.heavy)
                    .padding(.leading)
                
                Spacer()
            }
            
            ZStack {
                Rectangle()
                    .fill(LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.3), .clear]) , startPoint: .init(x: 0.5, y: 0.0), endPoint: .init(x: 0.5, y: 0.5)) )
                    .frame(height: 420)
                    .clipShape(ScreenShape(isClip: true))
                    .cornerRadius(20)
                
                ScreenShape()
                    .stroke(style:  StrokeStyle(lineWidth: 5,  lineCap: .square ))
                    .frame(height: 420)
                    .foregroundColor(Color.blue)
                
                
                VStack {
                    createUmbrellaView()
                    createSeatsLegend()
                    
                }.onAppear(){
                    
                }
                
            }
            
            Button("Checkout") {
            self.isModal = true
            }.sheet(isPresented: $isModal, content: {
                CheckoutView()
            })
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
    
    fileprivate func createUmbrellaView() -> some View {
        
        let rows: Int = 6
        let numbersPerRow: Int = 8
        
        return
            
            VStack {
                ForEach(0..<rows, id: \.self) { row in
                    HStack{
                        ForEach(0..<numbersPerRow, id: \.self){ number in
                            ChairView(width: 30, accentColor: .blue, seat: Seat(id: UUID(), row: row + 1, number: number + 1) , onSelect: { seat in
                                self.selectedSeats.append(seat)
                            }, onDeselect: { seat in
                                self.selectedSeats.removeAll(where: {$0.id == seat.id})
                            },onReserved: { seat in
                                self.selectedSeats.append(seat)
                            })
                        }
                    }
                }
        }
    }
    
    
    fileprivate func createSeatsLegend() -> some View{
        HStack{
            ChairLegend(text: "Selected", color: .blue)
            ChairLegend(text: "Reserved", color: .red)
            ChairLegend(text: "Available", color: .green)
        }.padding(.horizontal, 20).padding(.top)
    }
}

struct TheatreView_Previews: PreviewProvider {
    static var previews: some View {
        TheatreView(selectedSeats: .constant([]))
    }
}

struct Seat: Identifiable {
    var id: UUID
    var row: Int
    var number: Int
    
    static var `default`: Seat { Seat(id: UUID(), row: 0, number: 0) }
}

