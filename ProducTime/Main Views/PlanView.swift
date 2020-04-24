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
    @State var isShowingDetail : Bool = false
    @State private var editMode = EditMode.inactive
    
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }
    
    var body: some View {
        return NavigationView{
            List(session.tasks){ task in
                PlanRowView(task: task).environmentObject(self.session)
            }//List
            .navigationBarTitle(Text("Planning out \(session.tasks.count) tasks"), displayMode: .inline)
            .navigationBarItems(
                trailing: Button(action: {
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
        session.logIn(email: "Debug@project.com", password: "DebugIt!"){ (result, error) in
            if error != nil{
                print(error.debugDescription)
            }else{
                print("not logged in")
            }
        }
        return PlanView().environmentObject(session)
    }
}

