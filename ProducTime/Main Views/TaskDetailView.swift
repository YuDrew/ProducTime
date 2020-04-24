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
    @Binding var task : Task
    @State private var editMode = EditMode.inactive

    
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter
    }
    
    var body: some View{
        VStack{
            Form{
                Section{
                    Text(task.name)
                    Text("Due: \(dateFormatter.string(from: Date(timeIntervalSinceReferenceDate: task.due)))")
                    Text(task.importance.rawValue)
                        .modifier(importanceModifier(importance: task.importance))
                    Text(task.status.rawValue)
                }
            }
        }.navigationBarTitle(Text(task.name), displayMode: .inline)
        .navigationBarItems(trailing: EditButton())
            .environment(\.editMode, $editMode)
    }//body
    
}//PlanView

/*struct TaskDetailView_Previews: PreviewProvider {
    
    static var previews: some View {
        TaskDetailView(task: Task(task: "Test", due: Date(), importance: .maximum), isShowingDetail: .constant(true)).environmentObject(Session())
    }

}*/
