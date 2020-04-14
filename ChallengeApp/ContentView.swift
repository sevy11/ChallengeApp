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
    
    
    var body: some View {
        TabView {
            ManagerTabView(managers: Manager.chicagoManagers())
                .tabItem({
                    Image(systemName: "house")
                    Text("Scores")
                })
            WeeksScoresTabView(challengers: Challenger.generateChallengers())
                .tabItem({
                    Image(systemName: "calendar")
                    Text("Weeks")
                })
        }
//        NavigationView {
//            VStack {
//                Button.init(action: self.fetchWeek) {
//                    HStack {
//                        Image(systemName: "checkmark")
//                            .resizable()
//                            .frame(width: 16, height: 16, alignment: .center)
//                            .foregroundColor(.red)
//                        Text("Fetch Week")
//                            .foregroundColor(.black)
//                            .font(.body)
//                            .bold()
//                    }
//                }
//                Button.init(action: self.fetchData) {
//                    HStack {
//                        Text("Fetch Scores")
//                            .font(.body)
//                            .bold()
//                            .foregroundColor(.black)
//                        Image(systemName: "play")
//                            .resizable()
//                            .frame(width: 16, height: 16, alignment: .center)
//                            .foregroundColor(.red)
//                    }
//                }
//            }
//        }
    }
}

extension ContentView {
    func fetchData() {
        WebScrapManager().scrapChallengeScores(week: 1) { (namesAndScores) in
            print("names: \(namesAndScores.0)")
        }
    }
    
    func fetchWeek() {
        WebScrapManager().currentWeek() { currentWeek in
            print("week: \(currentWeek)")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
