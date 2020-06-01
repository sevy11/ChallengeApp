//
//  EnterChallengersViewModel.swift
//  ChallengeApp
//
//  Created by Michael Sevy on 6/1/20.
//  Copyright © 2020 Michael Sevy. All rights reserved.
//

import Foundation
import Combine

final class EnterChallengersViewModel: ObservableObject, Identifiable {
    let firebase = FirebaseManager()

    func updateLeagueWith(contestantNames: [String], managerEmail: String, leagueName: String) {
        firebase.updateLeagueWith(contestantNames: contestantNames, managerEmail: managerEmail, leagueName: leagueName, success: { (success) in
            print("Successfully updated the manager's contestant names.")
        }) { (error) in
            print("failed to update contestant names with error: \(error)")
        }
    }
}

