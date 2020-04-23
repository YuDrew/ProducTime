//
//  PlanRowView.swift
//  ProducTime
//
//  Created by Andrew Yu on 4/23/20.
//  Copyright © 2020 Andrew Yu. All rights reserved.
//

import SwiftUI

struct PlanRowView: View {
    @State var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State var task : Task
    @State var elapsed: String = "0:00:00"
    @State var trackingImage: String = "play.circle"
    //@ObservedObject var task: Task
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        return formatter
    }
    
    var body: some View {
        return VStack {
            HStack{
                Text(self.task.name)
                    .font(.headline)
                Spacer()
                Circle()
                    .frame(width: 13, height: 13, alignment: .trailing)
                Text(self.elapsed)
                    .onReceive(timer){ input in
                        self.elapsed = self.task.getTimeElapsed()
                    }
                Button(action:
                {
                    if(self.task.isTracking()){
                            self.task.startTracking()
                            self.trackingImage = "play.circle"
                        }else{
                            self.task.stopTracking()
                            self.trackingImage = "pause.circle"
                            
                        }
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
                Text(self.task.importance.rawValue)
                Spacer()
                Text("Due: \(self.dateFormatter.string(from: self.task.due))")
                    .font(.subheadline)
            }//HStack
        }//VStack
    }//body
    
}//PlanRowView

struct PlanRowView_Previews: PreviewProvider {
    
    static var previews: some View {
        PlanRowView(task: Task(task: "Finish Final Project", due: "04/23/20", importance: .maximum))
    }
}

