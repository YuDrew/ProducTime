//
//  TrackView.swift
//  ProducTime
//
//  Created by Andrew Yu on 4/17/20.
//  Copyright © 2020 Andrew Yu. All rights reserved.
//

import SwiftUI

struct TrackView: View {
    
    @EnvironmentObject var session : Session
    @State var isAddingNew : Bool = false
    @State var isShowingDetail : Bool = false
    @State private var editMode = EditMode.inactive
    @State var cardStyle: Bool = false
    
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }
    
    var body: some View {
        return NavigationView{
            Group{
                if(cardStyle){
                    TrackViewAsCards().environmentObject(self.session)
                }else{
                    List(self.session.tasks){ task in
                        TrackRowView(task: task).environmentObject(self.session)
                    }//List of Tasks
                }//Else
            }
            .navigationBarTitle(Text("Tracking \(session.tasks.count) Tasks"), displayMode: .inline)
            .navigationBarItems(trailing: Button(action: {self.cardStyle.toggle()}){Text(cardStyle ? "List" : "Card")})
        }//NavView
    }//body
    
    struct TrackViewAsCards: View{
        @EnvironmentObject var session: Session
        @State var expanded: Bool = false
        
        var body: some View{
            ZStack{
                CardView(title: "Limit", color: .red)
                    .environmentObject(session)
                    .offset(x:0, y: expanded ? -420 : -60)
                    .scaleEffect(expanded ? 1 : 0.85)
                CardView(title: "Delegate", color: .blue)
                    .environmentObject(session)
                    .offset(x: 0, y: expanded ? -280 : -40)
                    .scaleEffect(expanded ? 1 : 0.90)
                CardView(title: "Schedule", color: .orange)
                    .environmentObject(session)
                    .offset(x:0, y: expanded ? -140 : -20)
                    .scaleEffect(expanded ? 1 : 0.95)
                CardView(title: "Must Do", color: .green)
                    .environmentObject(session)
                    .onTapGesture{
                        self.expanded.toggle()
                }
            }
            .offset(x: 0, y: expanded ? 200 : 0)
            .animation(.spring(response: 1, dampingFraction: 0.8, blendDuration: 20))
        }
    }//TrackCardView
    
    
    struct CardView: View{
        
        @EnvironmentObject var session: Session
        @State var title: String
        @State var color: Color
        
        var body: some View{
            ZStack{
                Rectangle()
                    .fill(color)
                    .cornerRadius(10)
                    .frame(width: 380, height: 220)
                VStack{
                    HStack{
                        Text(title)
                            .font(.largeTitle)
                            .bold()
                            .foregroundColor(.white)
                        Spacer()
                        Text("\(self.session.tasks.count) Tasks")
                            .font(.title)
                            .bold()
                            .foregroundColor(.white)
                    }
                    List(session.tasks){ task in
                        TrackRowView(task: task).environmentObject(self.session).animation(nil)
                    }.animation(nil)
                    .frame(width: 350, height: 125)
                }.frame(width: 350, height: 210)
            }.shadow(radius: 6)
        }//body
    }//CardView
    
}//PlanView

struct TrackView_Previews: PreviewProvider {
    
    
    static var previews: some View {
        let session : Session = Session();
        session.logIn(email: "Debug@project.com", password: "DebugIt!"){ (result, error) in
            if error != nil{
                print(error.debugDescription)
            }else{
                print("not logged in")
            }
        }
        return TrackView().environmentObject(session)
    }
}//TrackView_Previews


