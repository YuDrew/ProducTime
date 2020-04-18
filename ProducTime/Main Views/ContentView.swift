//
//  ContentView.swift
//  ProducTime
//
//  Created by Andrew Yu on 4/17/20.
//  Copyright © 2020 Andrew Yu. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView{
            PlanView()
            .tabItem{
                Image(systemName: "square.and.pencil")
                Text("Plan")
            }//PlanView()
            TrackView()
            .tabItem{
                Image(systemName: "clock")
                Text("Track")
            }//TrackView()
            ReflectView()
                .tabItem{
                    Image(systemName: "flowchart")
                    Text("Reflect")
            }//ReflectView()
        }//TabView()
    }//body
}//ContentView()

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }//previews
}//ContentView_Previews
