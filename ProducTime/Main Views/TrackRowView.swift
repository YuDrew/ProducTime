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
                    .modifier(statusModifier(status: self.task.status))
                Circle()
                    .frame(width: 15, height: 15, alignment: .trailing)
                    .modifier(importanceModifier(importance: self.task.importance))
                Spacer()
                Text(self.task.elapsed)
                    .onReceive(timer){ input in
                        if(self.task.isTracking()){
                            self.task.calcTimeElapsed()
                        }
                }.onAppear(perform: {self.task.calcTimeElapsed()})
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
        }//VStack
    }//body
    
}//PlanRowView

struct TrackRowView_Previews: PreviewProvider {
    
    static var previews: some View {
        TrackRowView(task: Task(name: "Finish Final Project", due: Date(), importance: .maximum)).environmentObject(Session())
    }//previews
}


