//
//  ChairView.swift
//  Umbrella
//
//  Created by Ettore Zamponi on 08/07/2020.
//  Copyright © 2020 Ettore Zamponi. All rights reserved.
//

import SwiftUI


struct ChairView: View {
    
    var width: CGFloat = 50
    var accentColor: Color = .blue
    var seat = Seat.default
    @State var isSelected = false
    var isSelectable = true
    var onSelect: ((Seat)->()) = {_ in }
    var onDeselect: ((Seat)->()) = {_ in }
    
    
    var body: some View {
        VStack(spacing: 3) {
            Circle()
                .frame(width: 32, height: 32)
                .foregroundColor(isSelectable ? isSelected ? accentColor : Color.green.opacity(0.5) : accentColor)
            
        }.onTapGesture {
            if self.isSelectable{
                self.isSelected.toggle()
                if self.isSelected{
                    self.onSelect(self.seat)
                } else {
                    self.onDeselect(self.seat)
                }
            }
        }
    }
}

struct ChairView_Previews: PreviewProvider {
    static var previews: some View {
        ChairView()
    }
}
