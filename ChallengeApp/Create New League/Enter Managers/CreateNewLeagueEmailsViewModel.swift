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

protocol CreateNewLeagueEmailsProtocol {
    func createLeague(name: String, emails: [String], user: User, showName: String)
    func areValid(emailAddresses: [String]) -> Bool
}

final class CreateNewLeagueEmailsViewModel: CreateNewLeagueEmailsProtocol, ObservableObject, Identifiable {
    // MARK: - Instance Variables
    @Published var errorSavingLeague: Error?
    @Published var savingLeagueInProgress = false
    private let firebase = FirebaseManager()
    
    
    // MARK: - POST/GET Functions
    public func createLeague(name: String, emails: [String], user: User, showName: String) {
        self.savingLeagueInProgress = true
        firebase.createLeagueWith(name: name, managerEmails: emails, user: user, show: showName, posted: { (success) in
            self.savingLeagueInProgress = false
        }) { (failed) in
            self.savingLeagueInProgress = false
            self.errorSavingLeague = failed
        }
    }
    
    public func areValid(emailAddresses: [String]) -> Bool {
        for email in emailAddresses {
            if !email.contains("@") {
                return false
            }
        }
        return true
    }
}
