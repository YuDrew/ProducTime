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
    @Published var session: User?
    @Published var isLoggedIn: Bool?
    @Published var items: [Task] = []
    
    var ref: DatabaseReference = Database.database().reference(withPath: "\(String(describing: Auth.auth().currentUser?.uid ?? "Error"))")

    func listen(){
        _ = Auth.auth().addStateDidChangeListener{ (auth, user) in
            if let user = user{
                self.session = User(uid: user.uid, displayName: user.displayName, email: user.email)
            }
            
        }//StateDidChangeListener
    }//listen

    func logIn(email: String, password: String, handler: @escaping AuthDataResultCallback){
        Auth.auth().signIn(withEmail: email, password: password, completion: handler)
    }//logIn

    func logOut(){
        try! Auth.auth().signOut()
    }//logOut

    func signUp(email: String, password: String, handler: @escaping AuthDataResultCallback){
        Auth.auth().createUser(withEmail: email, password: password, completion: handler)
    }//signUp

    func getTasks(){
        ref.observe(DataEventType.value){ (snapshot) in
            self.items = []
            for child in snapshot.children{
                if let snapshot = child as? DataSnapshot,
                    let task = Task(snapshot: snapshot){
                    self.items.append(task)
                }
            }
        }//observe
    }//getTasks
    
    func uploadTask(task: String, due: Date, importance: Importance){
        let number = Int(Date.timeIntervalSinceReferenceDate * 1000)
        let postRef = ref.child(String(number))
        let post = Task(task: task, due: due, importance: importance)
        postRef.setValue(post.toAnyObject())
    }//uploadTask
    
    func updateTask(key: String, task: String, isComplete: String){
        let update = ["task": task, "isComplete": isComplete]
        let childUpdate = ["\(key)": update]
        ref.updateChildValues(childUpdate)
    }//updateTask
    
}//Session
