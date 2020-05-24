//
//  ChooseLeagueView.swift
//  ChallengeApp
//
//  Created by Michael Sevy on 5/22/20.
//  Copyright © 2020 Michael Sevy. All rights reserved.
//

import SwiftUI
import Firebase

struct ChooseLeagueView: View {
    @ObservedObject var firebaseObserved = FirebaseManager()
    var user: User?
    
    
    var body: some View {
        VStack {
            if firebaseObserved.leagues.count > 1 {
                Text("Choose a default league")
                List {
                    ForEach(firebaseObserved.leagues, id: \.name) { league in
                          Button(action: {
                            self.selectDefault(league: league)
                          }) {
                            Text(league.name)
                        }
                    }
                }
                .navigationBarTitle("Your leagues")
            } else {
              // @TODO segue to the one league the player is in and set the default
            }
        }.onAppear(perform: getLeagues)
    }
    
    func getLeagues() {
        if let user = user {
            firebaseObserved.getLeaguesFor(user: user)
        }
    }
    
    func selectDefault(league: League) {
        print("todo select default league: \(league.name)")
        DefaultsManager.saveDefaultLeague(name: league.name)
        // @This doesn't work?
//        _ = NavigationView {
//            ManagerTabView(managers: Manager.chicagoManagers(), user: self.user!)
//        }
    }
}

struct ChooseLeagueView_Previews: PreviewProvider {
    static var previews: some View {
        ChooseLeagueView()
    }
}
