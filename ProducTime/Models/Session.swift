//
//  Session.swift
//  ProducTime
//
//  Created by Andrew Yu on 4/18/20.
//  Copyright © 2020 Andrew Yu. All rights reserved.
//
//Original Session class inspired by: https://medium.com/flawless-app-stories/how-to-build-a-firebase-app-with-swiftui-5919d2d8a396

import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseDatabase

class Session: ObservableObject{
    
    //MARK: Properties
    @Published var user: User?
    @Published var isLoggedIn: Bool = false
    @Published var tasks: [Task] = []
    @Published var totalTimeSpent: Double = 0
    
    var ref: DatabaseReference = Database.database().reference(withPath: "users/\(String(describing: Auth.auth().currentUser?.uid ?? "Error"))")
    
    //MARK: Auth Functions
    
    /*Listener that is called anytime the sign-in state changes
     - If logged in, updates state to reflect log-in status
     - If logged out, clears state in order to prep for new log-in
     */
    func listen(){
        _ = Auth.auth().addStateDidChangeListener{ (auth, user) in
            if let user = user{
                self.ref = Database.database().reference(withPath: "\(String(describing: Auth.auth().currentUser?.uid ?? "Error"))")
                self.user = User(uid: user.uid, email: user.email)
                self.isLoggedIn = true
                self.getTasks()
                print("Session: Loaded user \(String(describing: user.email))")
            }else{
                print("Session: Unloading user \(String(describing: user?.email ?? "Error"))")
                self.user = nil
                self.isLoggedIn = false
                self.tasks.removeAll()
                self.ref.removeAllObservers()
            }
        }//StateDidChangeListener
    }//listen
    
    /* signUp Function.
    - Signs up new user using Auth
    - Listener should automatically be called, updating state
    */
    func signUp(email: String, password: String, handler: @escaping AuthDataResultCallback){
        Auth.auth().createUser(withEmail: email, password: password, completion: handler)
        print("Session: signUp")
    }//signUp

    /* LogIn Function.
     - Logs a user in via Auth.
     - Listener should automatically be called, updating state
     */
    func logIn(email: String, password: String, handler: @escaping AuthDataResultCallback){
        Auth.auth().signIn(withEmail: email, password: password, completion: handler)
        print("Session: logIn")
    }//logIn

    /* LogOut Function.
    - Logs current user out using Auth
    - Listener should automatically be called, updating state
    */
    func logOut(){
        try! Auth.auth().signOut()
        print("Session: logOut")
    }//logOut

    
    //MARK: Functions for Tasks Property
    
    /* getTasks Observer
     Watches current ref for tasks and updates whenever changes are made in Firebase
     - Should be re-called
     */
    func getTasks(){
        ref.observe(DataEventType.value){ (snapshot) in
            print("Session: Something changed in our tasks. Let's get User's tasks from firebase")
            //dump(snapshot)
            //dump(self.tasks)
            for child in snapshot.children{
                dump(child)
                if let snapshot = child as? DataSnapshot,
                    let task = Task(snapshot: snapshot){
                    if self.tasks.firstIndex(of: task) == nil{
                        self.tasks.append(task)
                        print("Session: Added \(task.name) from firebase")
                    }else{
                        print("Session: \(task.name) already exists")
                    }
                    
                }else{
                    print("Session: Loaded snapshot incorrectly...")
                }
            }
        }//observe
    }//getTasks
    
    func uploadTask(name: String, due: Date, importance: Importance){
        let number = Int(Date.timeIntervalSinceReferenceDate * 1000)
        let key = String(number)
        
        let task = Task(name: name, due: due, importance: importance, key: key, ref: ref.child(key))
        
        task.ref?.setValue(task.toDictionary())
        dump(task.toDictionary())
        
        print("Sesssion: Added \(name) to Database")
    }//uploadTask
    
    func updateTask(task: Task){
        task.ref?.updateChildValues(task.toDictionary() as! [AnyHashable : Any])
        print("Session: called updateTask")
    }//updateTask
    
    func deleteTask(taskIndex: Int){
        print("Session: deleting \(tasks[taskIndex].name) from database and list")
        ref.child(tasks[taskIndex].key).removeValue()
        tasks.remove(at: taskIndex)
        
    }//delete a Task
    
    func deleteTask(task: Task){
        if let taskIndex = self.tasks.firstIndex(of: task){
            deleteTask(taskIndex: taskIndex)
        }
    }//delete a Task
    
    func calcTotalTime(){
        self.totalTimeSpent = 0
        for task in self.tasks{
            task.calcTimeElapsed()
            self.totalTimeSpent += task.elapsedDouble
        }
    }//calculate total time spent working on tasks
    
}//Session
