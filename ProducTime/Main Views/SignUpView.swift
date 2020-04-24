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
    
    
    //MARK: Properties
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var showingAlert : Bool = false
    @State private var errorMessage : String = ""
    @EnvironmentObject var session: Session
    
    var body: some View{
        Group{
            VStack{
                Text("Sign Up For ProducTime")
                    .font(.title)
                    .bold()
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
                .alert(isPresented: $showingAlert){
                    Alert(title: Text("Invalid Attempt"), message: Text(self.errorMessage))
                }
            }//VStack
        }
        .padding()
        .navigationBarHidden(true)
    }//body
    
    func signUp(){
        if !email.isEmpty && !password.isEmpty{
            session.signUp(email: email, password: password){ (result, error) in
                if error != nil{
                    if let errorCode = AuthErrorCode(rawValue: error!._code){
                        switch errorCode{
                        case .invalidEmail:
                            self.errorMessage = "Invalid email."
                        case .emailAlreadyInUse:
                            self.errorMessage = "Email already in use."
                        case .weakPassword:
                            self.errorMessage = "Password is too weak. Must be at least 6 characters."
                        default:
                            self.errorMessage = "Create User Error: \(String(describing: error?.localizedDescription))"
                        }
                        print(self.errorMessage)
                        self.showingAlert.toggle()
                    }
                } else{
                    self.email = ""
                    self.password = ""
                }
            }
        }else{
            self.errorMessage = "Missing email or password"
            self.showingAlert.toggle()
        }
    }//signUp
    
}//SignUp

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View{
        SignUpView().environmentObject(Session())
    }
}
