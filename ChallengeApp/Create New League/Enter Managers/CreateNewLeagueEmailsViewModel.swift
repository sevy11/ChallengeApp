//
//  CreateNewLeagueEmailsViewModel.swift
//  ChallengeApp
//
//  Created by Michael Sevy on 6/1/20.
//  Copyright © 2020 Michael Sevy. All rights reserved.
//

import Foundation
import Combine
import Firebase


final class CreateNewLeagueEmailsViewModel: ObservableObject, Identifiable {
    @Published var errorSavingLeague: Error?
    @Published var savingLeagueInProgress = false
    let firebase = FirebaseManager()
    
    
    // MARK: - POST/GET Functions
    public func createLeague(name: String, emails: [String], user: User, show: String) {
        self.savingLeagueInProgress = true
        firebase.createLeagueWith(name: name, managerEmails: emails, user: user, show: show, posted: { (success) in
            self.savingLeagueInProgress = false
        }) { (failed) in
            self.savingLeagueInProgress = false
            self.errorSavingLeague = failed
        }
    }
    
    public func areValidEmailAddresses(emails: [String]) -> Bool {
        for email in emails {
            if !email.contains("@") {
                return false
            }
        }
        return true
    }
}