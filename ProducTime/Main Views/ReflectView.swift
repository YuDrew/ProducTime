//
//  ReflectView.swift
//  ProducTime
//
//  Created by Andrew Yu on 4/17/20.
//  Copyright © 2020 Andrew Yu. All rights reserved.
//

import SwiftUI

struct ReflectView: View {
    
    @EnvironmentObject var session : Session
    
    var body: some View {
        return NavigationView{
            
            Form{
                HStack{
                    Text("Total Tasks")
                        .frame(width: 50)
                    Divider()
                    Text("\(self.session.tasks.count)")
                    Spacer()
                }
                HStack{
                    Text("Total Time")
                        .frame(width: 50)
                    Divider()
                    Text("Todo: be able to sum total time spent")
                    Spacer()
                }
            }
            .navigationBarTitle(Text("Reflect."), displayMode: .large)
        }//NavView
    }//body
}//ReflectView
