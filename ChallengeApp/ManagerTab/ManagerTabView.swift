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
    @ObservedObject var viewModel = ManagerTabViewModel()
    let pub = NotificationCenter.default.publisher(for: NSNotification.Name.UpdatedChallengerScores)
    
    var body: some View {
        VStack {
            if viewModel.isLoading {
                ActivityIndicator(isAnimating: .constant(viewModel.isLoading), style: .large)
            } else if viewModel.leagues.count == 0 {
                Spacer()
                NoLeagueView()
                Spacer()
            } else {
                Spacer()
                Text("Totals thru week: \(viewModel.currentAvailableWeek)")
                    .foregroundColor(.orange)
                    .font(Font.system(size: 18))
                List(viewModel.managers, id: \.firebaseEmail) { manager in
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
            }
        }
        .navigationBarTitle(viewModel.leagueName)
        .navigationBarBackButtonHidden(true)
        .onAppear(perform: getCurrentWeek)
        .onReceive(pub) { (output) in
            self.loadUpdatedChallengers()
        }
    }
    
    func getCurrentWeek() {
        if let user = user {
            viewModel.getCurrentWeek(user: user)
            // This ultimately gets viewModel.managers
            viewModel.getLeaguesFor(user: user)
        }
    }
    
    func loadUpdatedChallengers() {
        if let user = user {
            viewModel.getLeaguesFor(user: user)
        }
    }
    
//    func manuallyUpdateScoresForWeek() {
//        // Comment out FirebaseManager.compareScraperAndFetchScoresIfNecesary when updating manaully
//        self.firebaseObserved.getScoresFor(week: 7, post: true)
//    }
}

struct ManagerTabView_Previews: PreviewProvider {
    static var previews: some View {
        ManagerTabView()
    }
}
