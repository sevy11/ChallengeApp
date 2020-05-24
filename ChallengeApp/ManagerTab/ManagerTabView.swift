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

struct ManagerTabView: View {
    var user: User?
    
    @ObservedObject var webScraperObserved = WebScrapManager()
    @ObservedObject var firebaseObserved = FirebaseManager()
        
    @State var weekDidUpdate = false
    @State private var newLeagueIsPresented = false
    
    let pub = NotificationCenter.default.publisher(for: NSNotification.Name("UpdatedChallengerScores"))
    
    var body: some View {
        VStack {
//            Button(action: {
//                self.manuallyUpdateScoresForWeek()
//            }) {
//                Text("Update Scores")
//            }
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
        if let user = user {
            self.firebaseObserved.getScoresFor(week: 2, post: true, user: user)
        }
    }
}

struct ManagerTabView_Previews: PreviewProvider {
    static var previews: some View {
        ManagerTabView()
    }
}
