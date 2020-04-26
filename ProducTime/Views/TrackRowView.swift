//
//  TrackRowView.swift
//  ProducTime
//
//  Created by Andrew Yu on 4/24/20.
//  Copyright © 2020 Andrew Yu. All rights reserved.
//

import SwiftUI

struct TrackRowView: View {
    
    //MARK: Properties
    @EnvironmentObject var session : Session
    @State var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @ObservedObject var task : Task
    
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        return formatter
    }
    
    var body: some View {
        HStack{
            Circle()
                .frame(width: 15, height: 15, alignment: .trailing)
                .modifier(importanceModifier(importance: self.task.importance))
            Text(self.task.name)
                .font(.headline)
                .modifier(statusModifier(status: self.task.status))
            Spacer()
            Text(self.task.elapsed)
                .onReceive(timer){ input in
                    if(self.task.isTracking()){
                        self.task.calcTimeElapsed()
                    }
            }.onAppear(perform: self.task.calcTimeElapsed)
            Button(action: self.task.logCurrentDate){
                Image(systemName: self.task.isTracking() ? "pause.circle" : "play.circle")
                    .foregroundColor(.blue)
            }//logButton
        }//HStack
        .animation(nil)
    }//body
    
}//PlanRowView

struct TrackRowView_Previews: PreviewProvider {
    
    static var previews: some View {
        TrackRowView(task: Task(name: "Finish Final Project", due: Date(), importance: .maximum)).environmentObject(Session())
    }//previews
}


