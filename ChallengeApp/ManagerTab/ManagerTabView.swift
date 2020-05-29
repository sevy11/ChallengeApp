//
//  ChallengeTabViews.swift
//  ChallengeApp
//
//  Created by Michael Sevy on 4/7/20.
//  Copyright © 2020 Michael Sevy. All rights reserved.
//

import SwiftUI
import Combine
import Firebase
import FirebaseUI

struct ManagerTabView: View {
    var user: User?
    // @TODO push off to VM
    @ObservedObject var webScraperObserved = WebScrapManager()
    @ObservedObject var firebaseObserved = FirebaseManager()
    @ObservedObject var defaultsObservable = DefaultsManager()
    
    let pub = NotificationCenter.default.publisher(for: NSNotification.Name.UpdatedChallengerScores)
    
    var body: some View {
        VStack {
            if firebaseObserved.leagues.count == 0 {
                NoLeagueView()
            } else {
            Spacer()
                Text("Totals thru week: \(webScraperObserved.currentAvailableWeek)")
                    .foregroundColor(.orange)
                    .font(Font.system(size: 18))
            List(firebaseObserved.managers, id: \.firebaseEmail) { manager in
                    ScrollView {
                        VStack {
                            Spacer()
                            Text("\(manager.firebaseEmail.uppercased())")
                                .bold()
                            Section {
                                ManagerRow(manager: manager)
                            }
                        }
                    }.id(UUID().uuidString)
            }
            .navigationBarTitle(firebaseObserved.leagueName)
            }
        }.onAppear(perform: getCurrentWeek)
            .onReceive(pub) { (output) in
                self.loadUpdatedChallengers()
        }
    }
    
    func getCurrentWeek() {
        if let user = user {
            webScraperObserved.getCurrentWeek(user: user)
            // This ultimately gets firebaseObserved.managers
            firebaseObserved.getLeaguesFor(user: user)
        }
    }
    
    func loadUpdatedChallengers() {
        if let user = user {
            firebaseObserved.getLeaguesFor(user: user)
        }
    }
    
    func manuallyUpdateScoresForWeek() {
        // Comment out FirebaseManager.compareScraperAndFetchScoresIfNecesary when updating manaully
        self.firebaseObserved.getScoresFor(week: 7, post: true)
    }
}

struct ManagerTabView_Previews: PreviewProvider {
    static var previews: some View {
        ManagerTabView()
    }
}

struct NoLeagueView: View {
    var body: some View {
        VStack {
            Spacer()
             Text("There are no leagues associated with this email address.")
            .lineLimit(nil)
            .multilineTextAlignment(.center)
            .navigationBarTitle("No Leagues 😥")
            Spacer()
        }
    }
}
