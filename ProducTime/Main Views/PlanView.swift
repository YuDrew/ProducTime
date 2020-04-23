//
//  PlanView.swift
//  ProducTime
//
//  Created by Andrew Yu on 4/17/20.
//  Copyright © 2020 Andrew Yu. All rights reserved.
//

import SwiftUI

struct PlanView: View {
    
    @EnvironmentObject var session : Session
    @State var isAddingNew : Bool = false
    @State var currTask : Task = Task(task: "filler", due: "01/01/2020", importance: .medium)
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }
    
    var body: some View {
        return NavigationView{
            List(session.tasks){ task in
                PlanRowView(task: task)
            }//List
            .navigationBarTitle(Text("Planning out \(session.tasks.count) tasks"), displayMode: .inline)
            .navigationBarItems(trailing:
                Button(action: {
                    self.isAddingNew.toggle()
                }){
                    Image(systemName: "plus")
                }.sheet(isPresented: $isAddingNew){
                    NewTaskView(isAddingNew: self.$isAddingNew).environmentObject(self.session)
                }
            )
        }
    }//body
    
}//PlanView

struct PlanView_Previews: PreviewProvider {
    
    
    static var previews: some View {
        let session : Session = Session();
        session.logIn(email: "testing@test.com", password: "Testing"){ (result, error) in
            if error != nil{
                session.tasks = testData
            }else{
                print("not logged in")
            }
        }
        return PlanView().environmentObject(session)
    }
}

