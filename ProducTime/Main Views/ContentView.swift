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
    @EnvironmentObject var session : Session
    
    var body: some View {
        return NavigationView{
            Group{
                if session.isLoggedIn {
                    Group{
                        return TabView{
                            PlanView().environmentObject(self.session)
                            .tabItem{
                                Image(systemName: "square.and.pencil")
                                Text("Plan")
                            }//PlanView()
                            TrackView().environmentObject(session)
                            .tabItem{
                                Image(systemName: "clock")
                                Text("Track")
                            }//TrackView()
                            ReflectView().environmentObject(self.session)
                                .tabItem{
                                    Image(systemName: "flowchart")
                                    Text("Reflect")
                            }//ReflectView()
                        }//TabView()
                        .navigationBarTitle(Text(""), displayMode: .inline)
                        .navigationBarItems(
                            leading:                               Text("\(self.session.user?.displayName ?? self.session.user?.email ?? "Email not found")")
                                .modifier(backgroundRectModifier(color: Color.yellow)),
                            trailing:
                                Button(action: {self.session.logOut()}){
                                Text("Logout")
                                }
                        )//navBarItems
                            
                    }
                } else { 
                    LoginView().environmentObject(self.session)
                }//conditionals on session existence
            }//Group
                .onAppear(perform: getUserAndTasks)
        }//NavigationView
        .navigationBarHidden(true)
    }//body
    
    //MARK: Functions
    func getUserAndTasks(){
        session.listen()
        session.getTasks()
        print("called getUserAndTasks")
    }//getUser
    
}//ContentView()

struct ContentView_Previews: PreviewProvider {
    
    
    
    static var previews: some View {
        let debugSession : Session = Session()
        debugSession.logIn(email: "Debug@project.com", password: "DebugIt!"){ (result, error) in
            if error != nil{
                print(error.debugDescription)
            }else{
                print("Started Debug Session")
            }
        }
        return ContentView().environmentObject(debugSession)
    }//previews
}//ContentView_Previews


