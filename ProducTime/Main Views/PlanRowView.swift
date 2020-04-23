//
//  PlanRowView.swift
//  ProducTime
//
//  Created by Andrew Yu on 4/23/20.
//  Copyright © 2020 Andrew Yu. All rights reserved.
//

import SwiftUI

struct PlanRowView: View {
    
    @State var task : Task
    //@ObservedObject var task: Task
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter
    }
    
    var body: some View {
        return NavigationView{
            VStack(alignment: .leading){
                HStack{
                    Text(task.task)
                        .font(.headline)
                    Spacer()
                    Circle()
                        .frame(width: 13, height: 13, alignment: .trailing)
                    Text("Secs: \(getTimeElapsed())")
                    Button(action: startTracking){
                        if(task.isTracking()){
                            Image(systemName: "pause.circle")
                        }else{
                            Image(systemName: "play.circle")
                        }
                    }
                }
                HStack{
                    Text("Est Hrs: 00.00")
                        .font(.subheadline)
                    Spacer()
                    Text("Due: \(self.dateFormatter.string(from: task.due))")
                        .font(.subheadline)
                }
            }//VStack
        }
    }//body
    
    func getTimeElapsed() -> Int{ //in seconds
        var elapsedTime : Int = 0
        var index : Int = 0
        var startTime : Date = Date()
        var endTime : Date
        for time in task.log {
            if index % 2 == 0{
                startTime = time
            }else{
                endTime = time
                elapsedTime = elapsedTime + Int(endTime.timeIntervalSince(startTime))
            }
            index = index + 1
        }
        return elapsedTime
    }
    
    func startTracking(){
        task.startTracking()
    }
}//PlanView

struct PlanRowView_Previews: PreviewProvider {
    
    static var previews: some View {
        PlanRowView(task: Task(task: "Finish Final Project", due: "04/23/20", importance: .maximum))
    }
}

