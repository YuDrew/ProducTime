//
//  UserView.swift
//  ProducTime
//
//  Created by Andrew Yu on 4/24/20.
//  Copyright © 2020 Andrew Yu. All rights reserved.
//

import SwiftUI

struct UserEditorView: View {
    
    //MARK: Properties
    @EnvironmentObject var session : Session
    @Environment(\.editMode) var mode
    @State var displayName : String = ""
    @Binding var isViewingUser : Bool
    
    var body: some View{
        NavigationView{
            VStack{
                Form{
                    Section{
                        HStack{
                            Text("Display Name")
                            Divider()
                            TextField("Display Name", text: $displayName)
                        }.onAppear(
                            perform: {self.displayName = self.session.user?.displayName ?? ""}
                        )
        
                    }//Form Section
                }//Form
                Spacer()
            }//VStack
            .navigationBarTitle(Text("Edit Profile"))
            .navigationBarItems(
                leading: EditButton(),
                trailing:
                Button(action: {
                    self.isViewingUser.toggle()
                    if self.displayName != "" {
                        self.session.user?.displayName = self.displayName
                    }
                    print("Pressed Done")
                }){
                    Text("Done")
                }//Add Button
            )//NavigationBarItems
        }//NavigationView
    }//body
}//PlanView

struct UserEditorView_Previews: PreviewProvider {
    
    static var previews: some View {
        UserEditorView(isViewingUser: .constant(true)).environmentObject(Session())
    }

}
