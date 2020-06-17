//
//  ContentView.swift
//  ChallengeApp
//
//  Created by Michael Sevy on 4/4/20.
//  Copyright © 2020 Michael Sevy. All rights reserved.
//

import SwiftUI
import Firebase
import Combine

struct ContentView: View {
    // MARK: - Instance Variables
    var user: User?
    @State private var isPresented: Bool = false
    
    var body: some View {
        TabView {
            NavigationView {
                VStack {
                    ManagerTabView(user: user!)
                        .navigationBarItems(leading:
                            NavigationLink(destination: ChooseLeagueView(user: user)) {
                                Text("Leagues").bold()
                            },trailing:
                            Button(action: {
                                self.isPresented.toggle()
                            }, label: {
                                Text("Create New League").bold()
                            }).sheet(isPresented: $isPresented, onDismiss: {
                                print("Model dismissed. State now: \(self.isPresented)")
                                NotificationCenter.default.post(name: Notification.Name.UpdatedChallengerScores, object: nil)
                            }) {
                                CreateNewLeagueView(user: self.user!, showModal: self.$isPresented)
                            }
                    )
                }
            }.navigationViewStyle(StackNavigationViewStyle()) // added so iPad does not show empty initial screen, this
                // takes away the master/detail sidebar and show full screen
            .tabItem({
                Image(systemName: "house")
                Text("Scores")
            })
            WeeksScoresTabView()
                .tabItem({
                    Image(systemName: "calendar")
                    Text("Weeks")
                })
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
