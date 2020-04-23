//
//  Task.swift
//  ProducTime
//
//  Created by Andrew Yu on 4/17/20.
//  Copyright © 2020 Andrew Yu. All rights reserved.
//
//Original Task struct inspired by Todos struct: https://medium.com/flawless-app-stories/how-to-build-a-firebase-app-with-swiftui-5919d2d8a396

import Firebase

enum Importance: String, CaseIterable, Hashable{
    case maximum
    case high
    case medium
    case low
    case minimal
}//Importance

enum Status: String, CaseIterable, Hashable{
    case doneLate = "Done Late"
    case done = "Done"
    case overdue = "Overdue"
    case onHold = "On Hold"
    case notStarted = "Not Started"
}//Status

class Task: Identifiable {
    
    let ref: DatabaseReference?
    let key: String
    let id: String
    
    let task: String
    let due: Date
    var log: [Date]
    let importance: Importance
    let status: Status
    
    init(task: String, due: Date, importance: Importance, key: String = ""){
        self.ref = nil
        self.key = key
        self.id = key
        
        self.task = task
        self.due = due
        self.log = []
        self.importance = importance
        self.status = .notStarted
    }//init by user
    
    init(task: String, due: String, importance: Importance, key: String = ""){
        self.ref = nil
        self.key = key
        self.id = key
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .none
        let dueDate = dateFormatter.date(from: due)!
        
        self.task = task
        self.due = dueDate
        self.log = []
        self.importance = importance
        self.status = .notStarted
    }//init by user
    
    init?(snapshot: DataSnapshot){
        print("try to create task from snapshot")
        guard
            let value = snapshot.value as? [String: AnyObject],
            let task = value["task"] as? String,
            let due = value["due"] as? String,
            //let log = value["log"] as? [String],
            let importance = value["importance"] as? String,
            let status = value["status"] as? String
            else {
                print("failed to create task")
                return nil
            }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        let dueDate = dateFormatter.date(from: due)!
        dateFormatter.timeStyle = .long
        var logDates : [Date] = []
        /*for date in log{
            if let newDate = dateFormatter.date(from: date){
                logDates.append(newDate)
            }else{
                print("your date formatting in Firebase is whack")
            }
        }*/
        self.ref = snapshot.ref
        self.key = snapshot.key
        self.id = snapshot.key
        
        self.task = task
        self.due = dueDate
        self.log = logDates
        self.importance = Importance(rawValue: importance)!
        self.status = Status(rawValue: status)!
    }//init from a DataSnapshot
    
    func toAnyObject() -> Any {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .none
        let dueDate = dateFormatter.string(from: due)
        dateFormatter.timeStyle = .long
        var logDates : [String] = []
        for time in log {
            let logTime = dateFormatter.string(from: time)
            logDates.append(logTime)
        }
        return [
            "task": task,
            "due": dueDate,
            "log": logDates,
            "importance": importance.rawValue,
            "status": status.rawValue,
        ]
    }//toAnyObject
    
    func isTracking() -> Bool{
        return (log.count % 2 != 0)
    }
    
    func startTracking(){
        log.append(Date())
    }
}//Task


let testData : [Task] = [
    Task(task: "Submit Milestone II", due: "04/19/2020", importance: .high),
    Task(task: "Get some sleep", due: "04/22/2020", importance: .maximum),
    Task(task: "Record Demo Video", due: "04/23/2020", importance: .high),
    Task(task: "Get Firebase to save tasks", due: "04/23/2020", importance: .high),
    Task(task: "Logout Functionality", due: "04/23/2020", importance: .medium)
]
