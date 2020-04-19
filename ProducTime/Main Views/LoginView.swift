//
//  LoginView.swift
//  ProducTime
//
//  Created by Andrew Yu on 4/18/20.
//  Copyright © 2020 Andrew Yu. All rights reserved.
//
//Original LoginView struct inspired by LoginView struct in https://medium.com/flawless-app-stories/how-to-build-a-firebase-app-with-swiftui-5919d2d8a396
import SwiftUI
import Firebase
import FirebaseAuth

struct LoginView: View{
    
    //MARK: Properties
    @State var email: String = ""
    @State var password: String = ""
    
    @EnvironmentObject var session: Session
    @State private var showingAlert = false
    
    var body: some View{
        VStack(spacing: 20){
            Spacer()
            Text("Sign In")
                .font(Font.title)
            
            TextField("Email", text: $email)
                .border(Color.gray, width: 1)
                .padding()
                
            SecureField("Password", text: $password)
                .border(Color.gray, width: 1)
                .padding()
            
            Button(action: logIn){
                Text("Sign In")
            }
            .padding()
            .border(Color.gray, width: 1)
            .alert(isPresented: $showingAlert){
                Alert(title: Text("Invalid Email or Password"), message: Text("Did you mean to sign up?"))
            }
            Spacer()
            NavigationLink(destination: SignUpView().environmentObject(self.session)){
                Text("Sign Up")
            }
        }//VStack
    }//body
    
    //MARK: Functions
    func logIn(){
        session.logIn(email: email, password: password){ (result, error) in
            if error != nil{
                if let errorCode = AuthErrorCode(rawValue: error!._code){
                    switch errorCode{
                    case .wrongPassword:
                        print("Wrong email or password")
                    case .missingEmail:
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
}//LoginView

struct LoginView_Previews: PreviewProvider{
    static var previews: some View{
        LoginView()
    }
}//LoginView_Previews
