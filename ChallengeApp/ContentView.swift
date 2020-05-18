//
//  ContentView.swift
//  ChallengeApp
//
//  Created by Michael Sevy on 4/4/20.
//  Copyright © 2020 Michael Sevy. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State private var week = 0
    @State private var determinedCurrentWeek = false
    @State private var isPresented = false

//    var managersTeams = [[String]]()

    var body: some View {
        TabView {
            NavigationView {
                ManagerTabView(managers: Manager.chicagoManagers())
                    // @TODO pass in the league you're in
                    .navigationBarTitle(League.generateRandomLeague().name)
//                    .navigationBarItems(trailing: Button(action: {
//                        self.isPresented = true
//                    }, label: {
//                         Text("Create New League").bold()
//                    }))
                .navigationBarItems(trailing:
                    NavigationLink(destination: CreateNewLeagueView()) {
                        Text("Create New League").bold()
                    })
//                .sheet(isPresented: $isPresented, onDismiss: {
//                    // 3
//                    print("Modal dismissed. State now: \(self.isPresented)")
//                  }) {
//                    // 4
//                    CreateNewLeagueView()
//                  }

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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
