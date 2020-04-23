//
//  User.swift
//  ProducTime
//
//  Created by Andrew Yu on 4/17/20.
//  Copyright © 2020 Andrew Yu. All rights reserved.
//

//Original User class inspired by: https://medium.com/flawless-app-stories/how-to-build-a-firebase-app-with-swiftui-5919d2d8a396

import SwiftUI
class User {
    
    var uid: String
    var email: String?
    var displayName: String?
    
    init(uid: String, email: String?){
        self.uid = uid
        self.email = email
    }//init
    
}//User
