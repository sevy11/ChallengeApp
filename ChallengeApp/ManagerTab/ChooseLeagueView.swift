//
//  ChooseLeagueView.swift
//  ChallengeApp
//
//  Created by Michael Sevy on 5/22/20.
//  Copyright © 2020 Michael Sevy. All rights reserved.
//

import SwiftUI
import Firebase
import FirebaseUI

struct ChooseLeagueView: View {
    var user: User?

    @ObservedObject var firebaseObserved = FirebaseManager()
    @State var selectedLeague = ""
    @State var title = ""

    var body: some View {
        VStack {
            if firebaseObserved.leagues.count == 0 {
                NoLeagueView()
                signOutButton
                Spacer()
            } else {
                Text("Select Default League:").opacity(firebaseObserved.leagues.count > 1 ? 1 : 0)
                List(firebaseObserved.leagues, id: \.name) { league in
                    Button(action: {
                        self.selectDefault(league: league)
                    }) {
                        league.name == self.selectedLeague  ? Text(league.name).foregroundColor(.green).bold() : Text(league.name)
                    }
                }.id(UUID().uuidString)
                    .navigationBarTitle(self.title)
                Spacer()
                signOutButton
                Spacer()
            }
        }.onAppear(perform: getLeagues)
            .onDisappear(perform: clearLeagues)
    }
    
    func getLeagues() {
        self.title = firebaseObserved.leagues.count > 1 ? "Your Leagues" : "Your League"
        if let user = user,
           let name = DefaultsManager.getDefaultLeagueName() {
            firebaseObserved.getLeaguesFor(user: user)
            self.selectedLeague = name
        }
    }
    
    func selectDefault(league: League) {
        self.selectedLeague = league.name
        DefaultsManager.saveDefaultLeague(name: league.name)
    }
    
    func clearLeagues() {
        firebaseObserved.leagues = [League]()
    }
    
    func signOut() {
        if let authUI = FUIAuth.defaultAuthUI() {
            try? authUI.signOut()
        }
    }
    
    var signOutButton: some View {
        return Button(action: {
            self.signOut()
        }) {
            Text("Sign Out")
        }.padding(15)
            .background(LinearGradient(gradient: Gradient(colors: [.red, .black]), startPoint: .leading, endPoint: .trailing))
            .foregroundColor(.white)
            .cornerRadius(40)
    }
}

struct ChooseLeagueView_Previews: PreviewProvider {
    static var previews: some View {
        ChooseLeagueView()
    }
}
