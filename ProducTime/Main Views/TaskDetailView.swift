//
//  TaskDetailView.swift
//  ProducTime
//
//  Created by Andrew Yu on 4/23/20.
//  Copyright © 2020 Andrew Yu. All rights reserved.
//

import SwiftUI

/*struct TaskDetailView: View {
    
    //MARK: Properties
    @EnvironmentObject var session : Session
    @Binding var task : Task
    
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
                        TextField("Task Name", text: task.task)
                        DatePicker(selection: $task.due, in: Date()..., displayedComponents: .date){
                            Text("Due Date")
                        }
                        Picker(selection: $task.importance, label: Text("Importance")){
                            ForEach(Importance.allCases, id: \.self){
                                Text($0.rawValue)
                            }
                        }
                    }
                }
                Text("\(task.task) by \(task.due, formatter: dateFormatter)")
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

struct TaskDetailView_Previews: PreviewProvider {
    
    static var previews: some View {
        NewTaskView(isAddingNew: .constant(true)).environmentObject(Session())
    }

}
*/
