//
//  LogView.swift
//  ProducTime
//
//  Created by Andrew Yu on 4/24/20.
//  Copyright © 2020 Andrew Yu. All rights reserved.
//

import SwiftUI

struct LogView : View {
    
    @EnvironmentObject var session : Session
    @ObservedObject var task : Task
    
    @State var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State private var editMode = EditMode.inactive
    
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }
    
    var body : some View {
        VStack{
            HStack{
                Text("Timetracking Total: ")
                    .font(.headline)
                Text(self.task.elapsed)
                .onReceive(timer){ input in
                    self.task.getTimeElapsed()
                }
                .onAppear(perform: {
                    self.task.getTimeElapsed()
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


struct LogView_Previews: PreviewProvider {
    
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
            LogView(task: task).environmentObject(Session())
        }
    }

}
