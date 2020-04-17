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
    var weeks = [2...16]
    let managers = ["Sevy", "Caruso", "Drimalla", "BJ", "Shamir", "Nash"]
    var managersTeams = [[String]]()
    @State private var determinedCurrentWeek = false
    

    
    var body: some View {
        TabView {
            ManagerTabView(managers: Manager.chicagoManagers())
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
