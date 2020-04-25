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
    
    @State var isEditing : Bool = false
    
    var body: some View{
        NavigationView{
            VStack{
                TaskPropertiesView(task: task).environmentObject(session)
                TaskLogView(task: task).environmentObject(session)
                .navigationBarTitle(Text("Task Details"), displayMode: .inline)
                    .navigationBarItems(trailing: Button(action: {
                        self.isEditing.toggle()
                    }){
                        Text("Edit")
                    }.sheet(isPresented: $isEditing){
                        TaskEditorView(
                            task: self.task,
                            taskName: self.task.name,
                            dueDate: Date(timeIntervalSinceReferenceDate: self.task.due),
                            importance: self.task.importance,
                            status: self.task.status,
                            isEditingTask: self.$isEditing
                        ).environmentObject(self.session)
                    })
            }//VStack
        }//NavView
    }//body
    
    
    struct TaskPropertiesView: View{
        
        //MARK: Properties and State
        @EnvironmentObject var session: Session
        @ObservedObject var task: Task
        
        @Environment(\.editMode) var mode
        
        var dateFormatter: DateFormatter {
            let formatter = DateFormatter()
            formatter.dateStyle = .short
            return formatter
        }
        
        var body: some View{
            Form{
                Section{
                    HStack{
                        Text("Task")
                            .frame(width: 60)
                        Divider()
                        Text(task.name)
                        Spacer()
                    }
                    HStack{
                        Text("Due")
                            .frame(width: 60)
                        Divider()
                        Text("\(dateFormatter.string(from: Date(timeIntervalSinceReferenceDate: task.due)))")
                        Spacer()
                    }
                    HStack{
                        Text("Priority")
                            .frame(width: 60)
                        Divider()
                        Text(task.importance.rawValue)
                        .modifier(importanceModifier(importance: task.importance))
                        Spacer()
                    }
                    HStack{
                        Text("Status")
                            .frame(width: 60)
                        Divider()
                        Text(task.status.rawValue)
                        Spacer()
                    }
                }//.navigationBarTitle(Text("Task Details"), displayMode: .inline)
                //.navigationBarItems(trailing: EditButton())
            }//Form
        }//View
    }//TaskPropertiesView
    
    struct TaskLogView : View {
        
        @EnvironmentObject var session : Session
        @ObservedObject var task : Task
        
        @State var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
        @State private var editMode = EditMode.inactive
        
        var dateFormatter: DateFormatter {
            let formatter = DateFormatter()
            formatter.dateStyle = .short
            formatter.timeStyle = .medium
            return formatter
        }
        
        var body : some View {
            VStack{
                HStack{
                    Text("Timetracking Total: ")
                        .font(.headline)
                    Text(self.task.elapsed)
                        .onReceive(timer){ input in
                            self.task.calcTimeElapsed()
                        }
                    .onAppear(perform: {
                        self.task.calcTimeElapsed()
                    })
                    Spacer()
                }.padding()
                
                HStack{
                    List(0..<task.log.count){ index in
                        Text("\(self.dateFormatter.string(from: Date(timeIntervalSinceReferenceDate: self.task.log[index])))")
                    }//List
                }//HStack
            }//VStack
        }//body
    }//LogView
    
    //MARK: Views for Editing
    struct TaskEditorView: View {
        
        //MARK: Properties
        @EnvironmentObject var session : Session
        @ObservedObject var task: Task
        
        @State var taskName : String
        @State var dueDate : Date
        @State var importance: Importance
        @State var status: Status
        
        @Binding var isEditingTask : Bool
        
        var body: some View{
            NavigationView{
                VStack{
                    Form{
                        Section{
                            TextField("Task Name", text: $taskName)
                            DatePicker(selection: $dueDate, in: Date()..., displayedComponents: .date){
                                Text("Due Date")
                            }//DatePicker
                            Picker(selection: $importance, label: Text("Importance")){
                                ForEach(Importance.allCases, id: \.self){
                                    Text($0.rawValue)
                                    }//Enumerate Importance Cases
                            }//Importance Picker
                            Picker(selection: $status, label: Text("Status")){
                                ForEach(Status.allCases, id: \.self){
                                    Text($0.rawValue)
                                }//Enumerate Status Cases
                            }//Status Picker
                        }//Form Section
                    }//Form
                    Spacer()
                }//VStack
                .navigationBarTitle(Text("Edit Task"))
                .navigationBarItems(
                    //leading: EditButton(),
                    trailing:
                    Button(action: {
                        self.task.updateTask(name: self.taskName, due: self.dueDate, importance: self.importance, status: self.status)
                        self.isEditingTask.toggle()
                        print("Pressed Done")
                    }){
                        Text("Done")
                    }//Add Button
                )//NavigationBarItems
            }//NavigationView
        }//body
    }//PlanView
    
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
