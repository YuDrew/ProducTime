//
//  Task.swift
//  ProducTime
//
//  Created by Andrew Yu on 4/17/20.
//  Copyright © 2020 Andrew Yu. All rights reserved.
//
//Original Task struct inspired by Todos struct: https://medium.com/flawless-app-stories/how-to-build-a-firebase-app-with-swiftui-5919d2d8a396

import Firebase
import FirebaseDatabase

enum Importance: String, CaseIterable, Hashable{
    case maximum
    case high
    case medium
    case low
    case minimal
}//Importance

enum Status: String, CaseIterable, Hashable{
    case notStarted = "Not Started"
    case inProgress = "In Progress"
    case complete = "Complete"
    case completedLate = "Complete [LATE]"
    case onHold = "On Hold"
}//Status

class Task: Identifiable, Equatable, ObservableObject {
 
    //MARK: Properties
    //For remote data
    let ref: DatabaseReference?
    let key: String
    
    //Important model properties
    @Published var name: String
    @Published var due: Double
    @Published var log: [Double]
    @Published var importance: Importance
    @Published var status: Status
    @Published var elapsed: String = "0"
    @Published var elapsedDouble: Double = 0
    //helper properties
    private var logID: Int = 0
    
    //MARK: Constructors
    init(name: String, due: Date, importance: Importance, key: String, ref: DatabaseReference){
        
        self.ref = ref
        self.key = key
        
        self.name = name
        self.due = due.timeIntervalSinceReferenceDate
        self.log = []
        self.importance = importance
        self.status = .notStarted
    }//init by Session; used to link to Firebase
    
    init(name: String, due: Date, importance: Importance, key: String = ""){
        
        self.ref = nil
        self.key = key
        
        self.name = name
        self.due = due.timeIntervalSinceReferenceDate
        self.log = []
        self.importance = importance
        self.status = .notStarted
    }//init by user, used only for testing
    
    init?(snapshot: DataSnapshot){
        print("Task: Try to create a task from snapshot")
        guard
            let value = snapshot.value as? [String : AnyObject],
            let name = value["task"] as? String,
            let due = value["due"] as? Double,
            let importance = value["importance"] as? String,
            let status = value["status"] as? String
            else {
                print("Task: Failed to create task")
                return nil
            }
        
        //MARK: Load in TimeTracking Log
        self.ref = snapshot.ref
        self.key = snapshot.key
        
        self.name = name
        self.due = due
        if let log = value["log"] as? [Double] {
            self.log = log
        }else{
            self.log = []
        }
        self.importance = Importance(rawValue: importance)!
        self.status = Status(rawValue: status)!
        loadLogs()
    }//init from a DataSnapshot
    
    //MARK: Functions Called Upon Construction
    func loadLogs(){
        let logRef = self.ref?.child("log")
        logRef?.observe(DataEventType.value){ (snapshot) in
            print("Task: Let's get the log for \(self.name) from firebase")
            //dump(snapshot)
            //dump(self.tasks)
            for child in snapshot.children {
                //dump(child)
                if let snap = child as? DataSnapshot {
                    if let logDate = snap.value as? Double{
                        if self.log.firstIndex(of: logDate) == nil{
                            self.log.insert(logDate, at: self.insertionIndexOf(logDate, isOrderedBefore: <))
                        }
                    }
                }else{
                    print("Task: Loaded a log snapshot for \(self.name) incorrectly...")
                }
            }
        }//observe
    }//loadLogs
    
    /*insertionIndexOf
     - Basic binary search to find insertion index for a given date
     - Used in order to properly construct date log for Tasks
     */
    func insertionIndexOf(_ date: Double, isOrderedBefore: (Double, Double) -> Bool) -> Int {
        var lo = 0
        var hi = log.count - 1
        while lo <= hi {
            let mid = (lo + hi)/2
            if isOrderedBefore(log[mid], date) {
                lo = mid + 1
            } else if isOrderedBefore(date, log[mid]) {
                hi = mid - 1
            } else {
                return mid // found at position mid
            }
        }
        return lo // not found, would be inserted at position lo
    }//insertionIndexOf
    

    //MARK: Functions for Reading, Calculating, and Editing State
    
    /*updateTask
     - Updates key state parameters of Task
     - Currently just overwrites everything
     */
    func updateTask(name: String, due: Date, importance: Importance, status: Status){
        print("Task: called updateTask for \(self.name)")
        self.name = name
        self.due = due.timeIntervalSinceReferenceDate
        self.importance = importance
        self.status = status
        self.ref?.updateChildValues(self.toDictionary() as! [AnyHashable : Any])
    }//updateTask    
    
    /* isTracking
    - Determines if the task is being tracked or not
    - Currently determined by looking at the length of the log. This is not very conducive to editing...
    */
    func isTracking() -> Bool{
        return (log.count % 2 != 0)
    }//isTracking
    
    /* CalcTimeElapsed
     - Calculated the total time spent on the task
     - Updates two published properties: elapsedDouble and elapsed (string)
     - TODO: Clean up function so that you only have to add new intervals rather than summing every interval each time
     */
    func calcTimeElapsed(){ //in seconds
        var elapsedTime : Double = 0
        var index : Int = 0
        var startTime : Double = 0
        var endTime : Double = 0
        
        for time in self.log {
            if index % 2 == 0{
                startTime = time
            }else{
                endTime = time
                elapsedTime += Double(endTime - startTime)
            }
            index += 1
        }
        
        if isTracking() {
            elapsedTime += Double(Date().timeIntervalSinceReferenceDate - startTime)
        }

        self.elapsedDouble = elapsedTime
        
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.unitsStyle = .positional

        let formattedString = formatter.string(from: TimeInterval(elapsedTime))!
        self.elapsed = formattedString
    }//getTimeElapsed
    
    //MARK: Functions for Uploading to Firebase
    
    func toDictionary() -> NSDictionary {
        return [
            "task": name,
            "due": due,
            "importance": importance.rawValue,
            "status": status.rawValue,
            "log": log,
        ]
    }//toAnyObject
    
    func logCurrentDate(){
        let date = Date.timeIntervalSinceReferenceDate
        log.append(date)
        if let logRef = ref?.child("log").childByAutoId() {
            logRef.setValue(date)
        }
        
    }//logCurrentDate
    
    
    //MARK: Protocol Functions
    
    //Equatable Protocol required function
    static func == (lhs: Task, rhs: Task) -> Bool {
        return (lhs.key == rhs.key)
    }
}//Task
