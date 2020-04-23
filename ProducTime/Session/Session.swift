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
                self.user = User(uid: user.uid, displayName: user.displayName, email: user.email)
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
        print("logged out, destroyed user")
        self.user = nil
    }//logOut

    func signUp(email: String, password: String, handler: @escaping AuthDataResultCallback){
        Auth.auth().createUser(withEmail: email, password: password, completion: handler)
        self.isLoggedIn = true
    }//signUp

    func getTasks(){
        ref.observe(DataEventType.value){ (snapshot) in
            self.tasks = []
            print("Let's try getting tasks from firebase")
            dump(snapshot)
            
            for child in snapshot.children{
                dump(child)
                if let snapshot = child as? DataSnapshot,
                    let task = Task(snapshot: snapshot){
                    self.tasks.append(task)
                    print("Added a task from firebase")
                }else{
                    print("whoops, I guess it's not a datasnapshot")
                }
            }
        }//observe
    }//getTasks
    
    func uploadTask(task: String, due: Date, importance: Importance){
        let number = Int(Date.timeIntervalSinceReferenceDate * 1000)
        let postRef = ref.child(String(number))
        let post = Task(task: task, due: due, importance: importance)
        postRef.setValue(post.toAnyObject())
        dump(post.toAnyObject())
        print("uploaded a task to firebase")
    }//uploadTask
    
    func updateTask(key: String, task: String, status: Status){
        let update = ["task": task, "status": status.rawValue]
        let childUpdate = ["\(key)": update]
        ref.updateChildValues(childUpdate)
    }//updateTask
    
}//Session
