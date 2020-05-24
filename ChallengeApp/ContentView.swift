//
//  ContentView.swift
//  ChallengeApp
//
//  Created by Michael Sevy on 4/4/20.
//  Copyright © 2020 Michael Sevy. All rights reserved.
//

import SwiftUI
import Firebase

struct ContentView: View {
    var user: User?
    
    @State private var week = 0
    @State private var determinedCurrentWeek = false
    @State private var isPresented = false
    @State var isUser = false
    
    var body: some View {
        TabView {
            if DefaultsManager.defaultLeagueExists {
                NavigationView {
                    ManagerTabView(user: user!)
                        .navigationBarItems(trailing:
                            NavigationLink(destination: CreateNewLeagueView(user: user)) {
                                Text("Create New League").bold()
                        })
                }
                .tabItem({
                    Image(systemName: "house")
                    Text("Scores")
                })
                WeeksScoresTabView(challengers: Challenger.generateTestChallengers())
                    .tabItem({
                        Image(systemName: "calendar")
                        Text("Weeks")
                    })
            } else {
                NavigationView {
                    ChooseLeagueView(user: user!)
                    .navigationBarItems(trailing:
                        NavigationLink(destination: CreateNewLeagueView(user: user)) {
                            Text("Create New League").bold()
                    })
                }
                .tabItem({
                    Image(systemName: "house")
                    Text("Scores")
                })
                WeeksScoresTabView(challengers: Challenger.generateTestChallengers())
                    .tabItem({
                        Image(systemName: "calendar")
                        Text("Weeks")
                    })
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
