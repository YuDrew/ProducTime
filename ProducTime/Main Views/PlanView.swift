//
//  PlanView.swift
//  ProducTime
//
//  Created by Andrew Yu on 4/17/20.
//  Copyright © 2020 Andrew Yu. All rights reserved.
//

import SwiftUI

struct PlanView: View {
    
    @EnvironmentObject var session : Session
    @State var isAddingNew : Bool = false
    @State var currTask : Task = Task(task: "filler", due: "01/01/2020", importance: .medium)
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }
    
    var body: some View {
        return NavigationView{
            List(session.tasks){ task in
                return HStack{
                    return VStack(alignment: .leading){
                        HStack{
                            Text(task.task)
                                .font(.headline)
                            Spacer()
                            Circle()
                                .frame(width: 13, height: 13, alignment: .trailing)
                            Text("Secs: \(self.getTimeElapsed())")
                            Button(action: self.startTracking){
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
            }//List
                .navigationBarTitle(Text("Planning out \(session.tasks.count) tasks"), displayMode: .inline)
            .navigationBarItems(trailing:
                Button(action: {self.isAddingNew.toggle()}){
                    Image(systemName: "plus")
                }.sheet(isPresented: $isAddingNew){
                    NewTaskView(isAddingNew: self.$isAddingNew).environmentObject(self.session)
                }
            )
        }
    }//body
    
    func startTracking(){
        self.currTask.startTracking()
    }
    
    func getTimeElapsed() -> Int{ //in seconds
        var elapsedTime : Int = 0
        var index : Int = 0
        var startTime : Date = Date()
        var endTime : Date
        for time in self.currTask.log {
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
}//PlanView

struct PlanView_Previews: PreviewProvider {
    
    
    static var previews: some View {
        let session : Session = Session();
        session.logIn(email: "testing@test.com", password: "Testing"){ (result, error) in
            if error != nil{
                session.tasks = testData
            }else{
                print("not logged in")
            }
        }
        return PlanView().environmentObject(session)
    }
}

