//
//  Modifiers.swift
//  ProducTime
//
//  Created by Andrew Yu on 4/23/20.
//  Copyright © 2020 Andrew Yu. All rights reserved.
//

import SwiftUI

struct importanceModifier: ViewModifier {
    
    @State var importance : Importance = .medium
    
    func body(content: Content) -> some View{
        var color : Color = Color.black
        switch(self.importance){
            case .maximum: color = Color.red
            case .high: color = Color.orange
            case .medium: color = Color.yellow
            case .low: color = Color.green
            case .minimal: color = Color.blue
        }
        return content
            .foregroundColor(color)
    }
    
    
}//importanceModifier

struct statusModifier: ViewModifier {
    
    @State var status : Status = .notStarted
    
    func body(content: Content) -> some View{
        var color : Color = Color.black
        switch(self.status){
            case .notStarted: color = Color.orange
            case .onHold: color = Color.blue
            case .done: color = Color.green
            case .overdue: color = Color.red
            case .doneLate: color = Color.purple
        }
        return content
            .foregroundColor(color)
    }
    
    
}//importanceModifier

struct backgroundRectModifier: ViewModifier {
    
    @State var color : Color = Color.white
    
    func body(content: Content) -> some View{
        var foregroundColor : Color = Color.black
        switch(self.color){
        case .red, .blue, .purple, .green: foregroundColor = Color.white
        case .yellow, .white: foregroundColor = Color.black
        default: foregroundColor = Color.black
        }
        return content
            .foregroundColor(foregroundColor)
            .padding(3)
            .background(RoundedRectangle(cornerRadius: 3, style: .circular).foregroundColor(color))
    }
    
    
}//backgroundRectModifier
