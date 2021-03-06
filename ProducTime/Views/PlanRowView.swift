//
//  PlanRowView.swift
//  ProducTime
//
//  Created by Andrew Yu on 4/23/20.
//  Copyright © 2020 Andrew Yu. All rights reserved.
//

import SwiftUI

struct PlanRowView: View {
    
    //MARK: Properties
    @EnvironmentObject var session : Session
    @ObservedObject var task : Task
    
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        return formatter
    }
    
    var body: some View {
        NavigationLink(destination: TaskDetailView(task: self.task)){
            HStack{
                VStack {
                    HStack{
                        Circle()
                            .frame(width: 13, height: 13, alignment: .trailing)
                            .modifier(importanceModifier(importance: self.task.importance))
                        Text(self.task.name)
                            .font(.headline)
                        Spacer()
                    }//HStack
                    HStack{
                        Text(self.task.status.rawValue)
                            .modifier(statusModifier(status: self.task.status))
                        Spacer()
                    }//HStack
                }//VStack
                Text("\(self.dateFormatter.string(from: Date(timeIntervalSinceReferenceDate: self.task.due)))")
                .font(.subheadline)
            }//HStack
            
        }//NavLink
    }//body
    
}//PlanRowView

struct PlanRowView_Previews: PreviewProvider {
    
    static var previews: some View {
        PlanRowView(task: Task(name: "Finish Final Project", due: Date(), importance: .maximum)).environmentObject(Session())
    }//previews
}


