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
    var user: User?
    var defaultsManager = DefaultsManager()
    
    var body: some View {
        TabView {
            NavigationView {
                VStack {
                    ManagerTabView(user: user!)
                        .navigationBarItems(leading:
                            NavigationLink(destination: ChooseLeagueView(user: user)) {
                                Text("Leagues").bold()
                            },trailing:
                            NavigationLink(destination: CreateNewLeagueView(user: user)) {
                                Text("Create New League").bold()
                            }
                            .isDetailLink(false)
                    )
                }
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
