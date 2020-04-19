//
//  ContentView.swift
//  ProducTime
//
//  Created by Andrew Yu on 4/17/20.
//  Copyright © 2020 Andrew Yu. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    //MARK: Properties
    @ObservedObject var session = Session()
    
    var body: some View {
        return NavigationView{
            Group{
                if session.session != nil {
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
                    }//TabView()`
                } else {
                    LoginView()
                        .environmentObject(self.session)
                        .navigationBarItems(trailing: Text(""))
                }//conditionals on session existence
            }//Group
            .onAppear(perform: getUser)
            .navigationBarTitle(Text("ProducTime"))
        }//NavigationView
    }//body
    
    //MARK: Functions
    func getUser(){
        session.listen()
    }//getUser
}//ContentView()

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }//previews
}//ContentView_Previews
