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
    var body: some View {
        let task = tasks[0]
        return Group {
            HStack{
                Circle()
                    .foregroundColor(color: )
                VStack(alignment: .leading){
                    Text("Name of Task")
                        .font(.headline)
                    Text("Est Hrs: 00.00")
                        .font(.subheadline)
                }
                VStack(alignment: .trailing){
                    Toggle(isOn: task.)
                    Text("Due: 00/00/00")
                }
            }//List(tasks)
            .padding()
        }
    }//body
    
}//PlanView

struct PlanView_Previews: PreviewProvider {
    static var previews: some View {
        PlanView()
    }
}
