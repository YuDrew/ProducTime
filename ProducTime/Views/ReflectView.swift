//
//  ReflectView.swift
//  ProducTime
//
//  Created by Andrew Yu on 4/17/20.
//  Copyright © 2020 Andrew Yu. All rights reserved.
//

import SwiftUI

struct ReflectView: View {
    
    //MARK: Properties
    @EnvironmentObject var session : Session
    @State var timer = Timer.publish(every: 60, on: .main, in: .common).autoconnect()
    
    var body: some View {
        return NavigationView{
            
            Form{
                HStack{
                    Text("Total Tasks")
                        .frame(width: 100)
                    Divider()
                    Text("\(self.session.tasks.count)")
                    Spacer()
                }//Total Tasks HStack
                HStack{
                    Text("Total Time")
                        .frame(width: 100)
                    Divider()
                    Text("\(self.session.totalTimeSpent / 60) mins")
                        .onReceive(timer){ input in
                            self.session.calcTotalTime()
                    }.onAppear(perform: {self.session.calcTotalTime()})
                    Spacer()
                    Button(action: self.session.calcTotalTime){
                        Text("Refresh")
                            .modifier(backgroundRectModifier(color: .orange))
                    }
                }//Total Time HStack
            }
            .navigationBarTitle(Text("Reflect."), displayMode: .large)
        }//NavView
    }//body
}//ReflectView
