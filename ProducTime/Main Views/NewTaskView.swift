//
//  NewTask.swift
//  ProducTime
//
//  Created by Andrew Yu on 4/22/20.
//  Copyright © 2020 Andrew Yu. All rights reserved.
//

import SwiftUI

struct NewTaskView: View {
    
    //MARK: Properties
    @EnvironmentObject var session : Session
    @State var taskName : String = "Task Name (make it actionable!)"
    @State var dueDate : Date = Date()
    @State var importance: Importance = .medium
    @Binding var isAddingNew : Bool
    
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
                        TextField("Task Name", text: $taskName)
                        DatePicker(selection: $dueDate, in: Date()..., displayedComponents: .date){
                            Text("Due Date")
                        }
                        Picker(selection: $importance, label: Text("Importance")){
                            ForEach(Importance.allCases, id: \.self){
                                Text($0.rawValue)
                            }
                        }
                    }
                }
                Text("\(taskName) by \(dueDate, formatter: dateFormatter)")
                Spacer()
                
            }
                
            .navigationBarTitle(Text("Add New Task"))
            .navigationBarItems(trailing:
                Button(action: {
                    self.session.uploadTask(task: self.taskName, due: self.dueDate, importance: self.importance)
                    self.session.getTasks()
                    self.isAddingNew.toggle()
                    print("Pressed add")
                }){
                    Text("Add")
                }
            )
        }
    }
}//PlanView

struct NewTaskView_Previews: PreviewProvider {
    
    static var previews: some View {
        NewTaskView(isAddingNew: .constant(true)).environmentObject(Session())
    }

}

