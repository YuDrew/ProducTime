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
                if self.session.isLoggedIn {
                    Group{
                        return TabView{
                            PlanView().environmentObject(self.session)
                            .tabItem{
                                Image(systemName: "square.and.pencil")
                                Text("Plan and Track")
                            }//PlanView()
                            /*TrackView().environmentObject(session)
                            .tabItem{
                                Image(systemName: "clock")
                                Text("Track")
                            }//TrackView()
                            */
                            ReflectView().environmentObject(self.session)
                                .tabItem{
                                    Image(systemName: "flowchart")
                                    Text("Reflect")
                            }//ReflectView()
                        }//TabView()
                            .navigationBarItems(
                                leading: Text("Welcome, \(self.session.user?.email ?? "Email not found")"),
                                trailing: Button(action: self.session.logOut){
                                    NavigationLink(destination: LoginView().environmentObject(self.session)){Text("Logout")}
                                }
                        )
                    }
                } else {
                    Group{
                        LoginView()
                            .environmentObject(self.session)
                    }
                }//conditionals on session existence
            }//Group
                .onAppear(perform:
                    getUserAndTasks
                    )
        }//NavigationView
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
        let session : Session = Session();
        session.logIn(email: "Testing@test.com", password: "testing"){ (result, error) in
            if error != nil{
                session.tasks = testData
            }else{
                print("not logged in")
            }
        }
        return Group{
            if (session.isLoggedIn) {
                ContentView().environmentObject(session)
                
            }else{
                Text("Not In")
            }
        }
    }//previews
}//ContentView_Previews
