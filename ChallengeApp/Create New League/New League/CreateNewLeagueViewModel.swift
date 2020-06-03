//
//  CreateNewLeagueViewModel.swift
//  ChallengeApp
//
//  Created by Michael Sevy on 6/1/20.
//  Copyright © 2020 Michael Sevy. All rights reserved.
//

import Foundation
import Combine
import Firebase

final class CreateNewLeagueViewModel: ObservableObject, Identifiable {
    @Published var leagueNames = [String]()
    @Published var newLeague = League.init(name: "")
    @Published var managerChoices = Manager.managerChoices
    private let firebase = FirebaseManager()
    
    func getLeagueNames() {
        firebase.getLeagues(success: { [weak self] (snap) in
            self?.parseForLeagueNames(dataSnapshot: snap)
        }) { (failed) in
            print("failed to get league names in view Model")
        }
    }
    
    public func leagueNameExists(name: String) -> Bool {
        if leagueNames.count > 0 {
            for leagueName in self.leagueNames {
                if leagueName.isEqualToCaseInsensitive(string: name) {
                    return true
                }
            }
        }
        return false
    }
    
    private func parseForLeagueNames(dataSnapshot: DataSnapshot) {
        if let dataValue = dataSnapshot.value as? [NSString : Any] {
            
            // Get only league names for league endpoint and assign
            for (key, _) in dataValue {
                let leagueName = key as String
                self.leagueNames.append(leagueName)
            }
        } else {
            print("could not interprept snapshot value")
        }
    }

}
