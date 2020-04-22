//
//  PlanView.swift
//  ProducTime
//
//  Created by Andrew Yu on 4/17/20.
//  Copyright © 2020 Andrew Yu. All rights reserved.
//

import SwiftUI

struct PlanView: View {
    
    @State var tasks : [Task] = []
    @State var isAddingNew : Bool = false
    
    var body: some View {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        return NavigationView{
            List(tasks){ task in
                VStack(alignment: .leading){
                    HStack{
                        Text(task.task)
                            .font(.headline)
                        Spacer()
                        Circle()
                            .frame(width: 13, height: 13, alignment: .trailing)
                        Text("00:00")
                        if(task.tracking){
                            Image(systemName: "pause.circle")
                        }else{
                            Image(systemName: "play.circle")
                        }
                    }
                    HStack{
                        Text("Est Hrs: 00.00")
                            .font(.subheadline)
                        Spacer()
                        Text("Due: \(dateFormatter.string(from: task.due))")
                            .font(.subheadline)
                    }
                }//VStack
            }//List
            .navigationBarTitle(Text("Plan it Out"))
            .navigationBarItems(trailing:
                Button(action: {self.isAddingNew = true}){
                    Image(systemName: "plus")
                }
            )
        }
    }//body
    
    var modalNewTask: some View{
        NavigationView{
            Text("Todo: Implement New Task Adding")
            .navigationBarTitle(Text("Add New Task"))
            .navigationBarItems(trailing:
                Button(action: {self.isAddingNew = false}){
                    Text("Done")
                }
            )
        }
    }
}//PlanView

struct PlanView_Previews: PreviewProvider {
    static var previews: some View {
        PlanView(tasks: testData)
    }
}

