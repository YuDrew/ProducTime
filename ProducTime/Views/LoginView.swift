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
    @EnvironmentObject var session: Session
    
    @State var email: String = ""
    @State var password: String = ""
    
    @State private var errorMessage : String = ""
    @State private var showingAlert = false
    @State private var hidePass : Bool = true
    
    var body: some View{
        VStack(spacing: 20){
            Spacer()
            HStack{
                Text("Sign In To")
                    .font(.title)
                    .bold()
                Text("ProducTime")
                    .font(.title)
                    .bold()
                    .modifier(backgroundRectModifier(color: .green))
            }
            HStack{
                TextField("Enter email address", text: $email)
                .padding()
            }
            HStack{
                if self.hidePass{
                    SecureField("Enter Password", text: $password)
                        .padding()
                }else{
                    TextField("Enter Password", text: $password)
                    .padding()
                }
                Button(action: {
                    self.hidePass.toggle()
                }){
                    Image(systemName: self.hidePass ? "eye.slash.fill" : "eye.fill")
                        .foregroundColor(self.hidePass ? Color.secondary :  Color.green)
                }
            }
            
            Button(action: logIn){
                Text("Sign In")
            }
            .padding()
            .alert(isPresented: $showingAlert){
                Alert(title: Text("Login Failed"), message: Text(errorMessage))
            }
            Spacer()
            NavigationLink(destination: SignUpView().environmentObject(self.session)){
                Text("Sign Up")
            }
            
        }//VStack
        .padding()
        .navigationBarHidden(true)
        
    }//body
    
    //MARK: Functions
    func logIn(){
        session.logIn(email: email, password: password){ (result, error) in
            if error != nil{
                if let errorCode = AuthErrorCode(rawValue: error!._code){
                    switch errorCode{
                    case .invalidEmail, .wrongPassword, .userNotFound:
                        self.errorMessage = "Incorrect email or password"
                    default:
                        self.errorMessage = String(describing: error?.localizedDescription)
                        print("LoginView: Create User Error: \(String(describing: error?.localizedDescription))")
                    }
                    self.showingAlert.toggle()
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
        LoginView().environmentObject(Session())
    }
}//LoginView_Previews
