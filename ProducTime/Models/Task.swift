//
//  Task.swift
//  ProducTime
//
//  Created by Andrew Yu on 4/17/20.
//  Copyright © 2020 Andrew Yu. All rights reserved.
//

//Original Task struct inspired by Todos struct: https://medium.com/flawless-app-stories/how-to-build-a-firebase-app-with-swiftui-5919d2d8a396

import Firebase

struct Task: Identifiable {
    
    let ref: DatabaseReference?
    let key: String
    let task: String
    let isComplete: String
    let tracking: Bool = false
    let log: [NSDate] = []
    let id: String
    
    init(task: String, isComplete: String,key: String = ""){
        self.ref = nil
        self.key = key
        self.task = task
        self.isComplete = isComplete
        self.id = key
    }
    
    init?(snapshot: DataSnapshot){
        guard
            let value = snapshot.value as? [String: AnyObject],
            let task = value["task"] as? String,
            let isComplete = value["isComplete"] as? String
            else {
                return nil
            }
        self.ref = snapshot.ref
        self.key = snapshot.key
        self.task = task
        self.isComplete = isComplete
        self.id = snapshot.key
    }
    
    func toAnyObject() -> Any {
        return [
            "task": task,
            "isComplete":  isComplete,
        ]
    }
}
