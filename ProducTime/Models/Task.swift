//
//  Task.swift
//  ProducTime
//
//  Created by Andrew Yu on 4/17/20.
//  Copyright © 2020 Andrew Yu. All rights reserved.
//
//Original Task struct inspired by Todos struct: https://medium.com/flawless-app-stories/how-to-build-a-firebase-app-with-swiftui-5919d2d8a396

import Firebase

enum Importance: String{
    case maximum
    case high
    case medium
    case low
    case minimal
}//Importance

enum Status: String{
    case doneLate = "Done Late"
    case done = "Done"
    case overdue = "Overdue"
    case onHold = "On Hold"
    case notStarted = "Not Started"
}//Status

struct Task: Identifiable {
    
    let ref: DatabaseReference?
    let key: String
    let id: String
    
    let task: String
    let due: Date
    let log: [Date]
    let importance: Importance
    let status: Status
    let tracking: Bool
    
    init(task: String, due: Date, importance: Importance, key: String = ""){
        self.ref = nil
        self.key = key
        self.id = key
        
        self.task = task
        self.due = due
        self.log = []
        self.importance = importance
        self.status = .notStarted
        self.tracking = false
    }//init by user
    
    init(task: String, due: String, importance: Importance, key: String = ""){
        self.ref = nil
        self.key = key
        self.id = key
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        let dueDate = dateFormatter.date(from: due)!
        
        self.task = task
        self.due = dueDate
        self.log = []
        self.importance = importance
        self.status = .notStarted
        self.tracking = false
    }//init by user
    
    init?(snapshot: DataSnapshot){
        guard
            let value = snapshot.value as? [String: AnyObject],
            let task = value["task"] as? String,
            let due = value["due"] as? Date,
            let log = value["log"] as? [Date],
            let importance = value["importance"] as? Importance,
            let status = value["status"] as? Status,
            let tracking = value["tracking"] as? Bool
            else {
                return nil
            }
        
        self.ref = snapshot.ref
        self.key = snapshot.key
        self.id = snapshot.key
        
        self.task = task
        self.due = due
        self.log = log
        self.importance = importance
        self.status = status
        self.tracking = tracking
    }//init from a DataSnapshot
    
    func toAnyObject() -> Any {
        return [
            "task": task,
            "due":  due,
            "log": log,
            "importance": importance,
            "status": status,
            "tracking": tracking
        ]
    }//toAnyObject
    
}//Task


let testData : [Task] = [
    Task(task: "Submit Milestone II", due: "04/19/2020", importance: .high),
    Task(task: "Get some sleep", due: "04/22/2020", importance: .maximum),
    Task(task: "Record Demo Video", due: "04/23/2020", importance: .high),
    Task(task: "Get Firebase to save tasks", due: "04/23/2020", importance: .high),
    Task(task: "Logout Functionality", due: "04/23/2020", importance: .medium)
]
