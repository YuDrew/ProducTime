//
//  UserEditor.swift
//  ProducTime
//
//  Created by Andrew Yu on 4/24/20.
//  Copyright © 2020 Andrew Yu. All rights reserved.
//

import SwiftUI
struct UserView: View {
    
    //MARK: Properties
    @EnvironmentObject var session : Session
    @Environment(\.editMode) var mode
    @State var displayName : String = "No Display Name"
    @Binding var isViewingUser : Bool
    var body: some View{
        List{
            HStack{
                Text("Display Name")
                Divider()
            }
        }
    }//body
}//PlanView

struct UserView_Previews: PreviewProvider {
    
    static var previews: some View {
        UserView(isViewingUser: .constant(true)).environmentObject(Session())
    }

}

