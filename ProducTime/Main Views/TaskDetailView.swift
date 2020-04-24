//
//  TaskDetailView.swift
//  ProducTime
//
//  Created by Andrew Yu on 4/23/20.
//  Copyright © 2020 Andrew Yu. All rights reserved.
//

import SwiftUI

struct TaskDetailView: View {
    
    //MARK: Properties
    @EnvironmentObject var session : Session
    @ObservedObject var task : Task
    
    //@State var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State private var editMode = EditMode.inactive
    //@State var trackingImage: String = "play.circle"
    //@State var elapsed: String = "0:00:
    
    
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter
    }
    
    var body: some View{
        NavigationView{
            VStack{
                Form{
                    Section{
                        Text(task.name)
                        Text("Due: \(dateFormatter.string(from: Date(timeIntervalSinceReferenceDate: task.due)))")
                        Text(task.importance.rawValue)
                            .modifier(importanceModifier(importance: task.importance))
                        Text(task.status.rawValue)
                    }.navigationBarTitle(Text(task.name), displayMode: .large)

                }//Form
                
                LogView(task: task).environmentObject(session)
                    
                .navigationBarTitle(Text(task.name), displayMode: .inline)
                .navigationBarItems(trailing: EditButton())
                    .environment(\.editMode, $editMode)
            }//VStack
        }//NavView
    }//body
    
}//PlanView

struct TaskDetailView_Previews: PreviewProvider {
    
    static var previews: some View {
        let debugSession : Session = Session()
        debugSession.logIn(email: "Debug@project.com", password: "DebugIt!"){ (result, error) in
            if error != nil{
                print(error.debugDescription)
            }else{
                print("Started Debug Session")
            }
        }
        let task : Task = Task(name: "Debug Task", due: Date(), importance: .medium)
        return PreviewWrapper(task: task).environmentObject(debugSession)
    }
    
    struct PreviewWrapper: View{
        @EnvironmentObject var session: Session
        @State var task: Task
        
        var body: some View{
            TaskDetailView(task: task).environmentObject(Session())
        }
    }

}
