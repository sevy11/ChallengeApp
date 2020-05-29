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
    var defaultsManager = DefaultsManager()

    var body: some View {
        TabView {
            NavigationView {
                ManagerTabView(user: user!)
                    .navigationBarItems(leading:
                        NavigationLink(destination: ChooseLeagueView(user: user)) {
                            Text("Leagues")
                                .bold()
                        },trailing:
                        NavigationLink(destination: CreateNewLeagueView(user: user)) {
                            Text("Create New League")
                                .bold()
                    })
            }
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
