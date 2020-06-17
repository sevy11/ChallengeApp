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
import Combine

struct ChooseLeagueView: View {
    var user: User?
    @ObservedObject private var viewModel = ChooseLeagueViewModel()
    @State private var selectedLeague = ""

    var body: some View {
        VStack {
            if viewModel.isLoading {
                ActivityIndicator(isAnimating: .constant(viewModel.isLoading), style: .large)
            } else if viewModel.leagues.count > 0 {
                Text("Select Default League:").opacity(viewModel.leagues.count > 1 ? 1 : 0)
                List(viewModel.leagues, id: \.name) { league in
                    Button(action: {
                        self.selectDefault(league: league)
                    }) {
                        league.name == self.selectedLeague  ? Text(league.name).foregroundColor(.green).bold() : Text(league.name)
                    }
                }.id(UUID().uuidString)
                    .navigationBarTitle(viewModel.leagues.count > 1 ? "Your Leagues" : "Your League")
                Spacer()
                Text("Sign out of user: \(user?.email == nil ? "" : (user?.email)!)").padding()
                signOutButton
                Spacer()
            } else if viewModel.noLeagues {
                NoLeagueView()
                signOutButton
                Spacer()
            }
        }.onAppear(perform: getLeagues)
            .onDisappear(perform: clearLeagues)
    }
    
    func getLeagues() {
        if let user = user,
            let name = DefaultsManager.getDefaultLeagueName() {
            viewModel.getLeaguesFor(user: user)
            self.selectedLeague = name
        }
    }
    
    func selectDefault(league: League) {
        self.selectedLeague = league.name
        DefaultsManager.saveDefaultLeague(name: league.name)
    }
    
    func clearLeagues() {
        viewModel.leagues = [League]()
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
            .background(LinearGradient(gradient: Gradient(colors: [.red, .gray]), startPoint: .leading, endPoint: .trailing))
            .foregroundColor(.white)
            .cornerRadius(40)
    }
}

struct ChooseLeagueView_Previews: PreviewProvider {
    static var previews: some View {
        ChooseLeagueView()
    }
}
