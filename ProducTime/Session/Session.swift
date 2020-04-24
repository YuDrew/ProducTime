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
    
    var ref: DatabaseReference = Database.database().reference(withPath: "\(String(describing: Auth.auth().currentUser?.uid ?? "Error"))")

    func listen(){
        _ = Auth.auth().addStateDidChangeListener{ (auth, user) in
            if let user = user{
                self.user = User(uid: user.uid, email: user.email)
                self.isLoggedIn = true
            }else{
                self.user = nil
                self.isLoggedIn = false
            }
            
        }//StateDidChangeListener
    }//listen

    func logIn(email: String, password: String, handler: @escaping AuthDataResultCallback){
        Auth.auth().signIn(withEmail: email, password: password, completion: handler)
        self.isLoggedIn = true
    }//logIn

    func logOut(){
        try! Auth.auth().signOut()
        self.isLoggedIn = false
        self.user = nil
        print("logged out, destroyed user")
    }//logOut

    func signUp(email: String, password: String, handler: @escaping AuthDataResultCallback){
        Auth.auth().createUser(withEmail: email, password: password, completion: handler)
        self.isLoggedIn = true
    }//signUp

    func getTasks(){
        ref.observe(DataEventType.value){ (snapshot) in
            print("Let's try getting tasks from firebase")
            dump(snapshot)
            dump(self.tasks)
            for child in snapshot.children{
                dump(child)
                if let snapshot = child as? DataSnapshot,
                    let task = Task(snapshot: snapshot){
                    if self.tasks.firstIndex(of: task) == nil{
                        self.tasks.append(task)
                        print("Added a task from firebase")
                    }else{
                        print("the mans already exists")
                    }
                    
                }else{
                    print("Loaded snapshot incorrectly")
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
        
        print("Added \(name) to Database")
    }//uploadTask
    
    func updateTask(task: Task){
        task.ref?.updateChildValues(task.toDictionary() as! [AnyHashable : Any])
        print("Called updateTask")
    }//updateTask
    
    func deleteTask(taskIndex: Int){
        ref.child(tasks[taskIndex].key).removeValue()
        tasks.remove(at: taskIndex)
    }//delete a Task
    
    func deleteTask(task: Task){
        if let taskIndex = self.tasks.firstIndex(of: task){
            deleteTask(taskIndex: taskIndex)
        }
    }//delete a Task
}//Session
