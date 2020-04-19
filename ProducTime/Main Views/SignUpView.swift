//
//  SignUpView.swift
//  ProducTime
//
//  Created by Andrew Yu on 4/18/20.
//  Copyright © 2020 Andrew Yu. All rights reserved.
//
//Original SignUpView struct inspired by SignUp struct: https://medium.com/flawless-app-stories/how-to-build-a-firebase-app-with-swiftui-5919d2d8a396

import SwiftUI
import Firebase
import FirebaseAuth

struct SignUpView: View{
    
    @State private var email: String = ""
    @State private var password: String = ""
    
    @EnvironmentObject var session: Session
    
    var body: some View{
        Group{
            VStack{
                HStack{
                    Text("Email")
                    TextField("Enter Email Address", text: $email)
                }
                .padding()
                
                HStack{
                    Text("Password")
                    TextField("Enter Password", text: $password)
                }
                .padding()
                
                Button(action: signUp){
                    Text("Sign Up")
                }//SignUpButton
            }//VStack
            
        }
        .padding()
    }//body
    
    func signUp(){
        if !email.isEmpty && !password.isEmpty{
            session.signUp(email: email, password: password){ (result, error) in
                if error != nil{
                    if let errorCode = AuthErrorCode(rawValue: error!._code){
                        switch errorCode{
                        case .invalidEmail:
                            print("Invalid email.")
                        case .emailAlreadyInUse:
                            print("Email already in use.")
                        case .weakPassword:
                            print("Password is too weak. Must be at least 6 characters.")
                        default:
                            print("Create User Error: \(String(describing: error?.localizedDescription))")
                        }
                    }
                } else{
                    self.email = ""
                    self.password = ""
                }
            }
        }
    }//signUp
    
}//SignUp

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View{
        SignUpView()
    }
}
