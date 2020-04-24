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
    @State var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State var task : Task
    @State var elapsed: String = "0:00:00"
    @State var trackingImage: String = "play.circle"
    
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        return formatter
    }
    
    var body: some View {
        
        VStack {
            HStack{
                Text(self.task.name)
                    .font(.headline)
                Circle()
                    .frame(width: 13, height: 13, alignment: .trailing)
                    .modifier(importanceModifier(importance: self.task.importance))
                Spacer()
                Text(self.elapsed)
                    .onReceive(timer){ input in
                        self.elapsed = self.task.getTimeElapsed()
                    }
                Button(action:
                {
                    if(self.task.isTracking()){
                        self.trackingImage = "play.circle"
                    }else{
                        self.trackingImage = "pause.circle"
                    }
                    self.task.logCurrentDate()
                }, label: {
                    if(self.task.isTracking()){
                        Image(systemName: "pause.circle")
                            .foregroundColor(.blue)
                    }else{
                        Image(systemName: "play.circle")
                        .foregroundColor(.blue)
                    }
                })
            }//HStack
            HStack{
                Text("Est Hrs: 00.00")
                    .font(.subheadline)
                Spacer()
                Text("Due: \(self.dateFormatter.string(from: Date(timeIntervalSinceReferenceDate: self.task.due)))")
                    .font(.subheadline)
            }//HStack
        }//VStack
        .gesture(
            DragGesture(minimumDistance: 50)
                .onEnded{ _ in
                    print("Wowie what a drag")
                }
        )
    }//body
    
}//PlanRowView

struct PlanRowView_Previews: PreviewProvider {
    
    static var previews: some View {
        PlanRowView(task: Task(task: "Finish Final Project", due: Date(), importance: .maximum)).environmentObject(Session())
    }//previews
}


