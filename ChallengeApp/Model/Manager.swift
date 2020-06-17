//
//  Manager.swift
//  ChallengeApp
//
//  Created by Michael Sevy on 4/8/20.
//  Copyright © 2020 Michael Sevy. All rights reserved.
//

import Foundation
import SwiftUI
import Firebase

struct Manager: Identifiable {
    static let managerChoices = ["3", "4", "5", "6", "7", "8"]

    public var firebaseEmail: String
    public var contestantNames: [String]?
    public var challengers: [Challenger]?
    public var id = 1
    public var leagues: [League] {
        return [League.init(name: "Chicago Challenge")]
    }
    
    public var score: Int {
      var scores = [Int]()
      
        if let challengers = self.challengers {
            for ch in challengers {
                scores.append(ch.score)
            }
        }
        let sum = scores.reduce(0, +)
        return sum
    }
    
    init(email: String, contestantNames: [String]) {
        self.firebaseEmail = email
        self.contestantNames = contestantNames
    }
    
    
    // MARK: - Test Functions
    func challengersFor(manager: String) -> [Challenger] {
        if manager == "sevy" {
            return [createChallenger(named: "Jordan Wiseley"),
                    createChallenger(named: "Kyle Christie"),
                    createChallenger(named:"Kailah Casillas"),
                    createChallenger(named: "Bayleigh Dayton")]
        } else if manager == "caruso" {
            return [createChallenger(named: "Johnny Bananas"),
                    createChallenger(named: "Cory Wharton"),
                    createChallenger(named: "Melissa Reeves"),
                    createChallenger(named: "Swaggy C Williams")]
        } else if manager == "drimalla" {
            return [createChallenger(named: "Stephen Bear"),
                    createChallenger(named: "Dee Nguyen"),
                    createChallenger(named: "Mattie Breaux"),
                    createChallenger(named: "Aneesa Ferreira")]
        } else if manager == "bj" {
            return  [createChallenger(named: "Jenny West"),
                     createChallenger(named: "Fessy Shafaat"),
                     createChallenger(named: "CT Tamburello"),
                     createChallenger(named: "Jenna Compono")]
        } else if manager == "shamir" {
            return  [createChallenger(named: "Tori Deal"),
                     createChallenger(named: "Wes Bergmann"),
                     createChallenger(named: "Nelson Thomas"),
                     createChallenger(named: "Kaycee Clark")]
        } else if manager == "nash" {
            return  [createChallenger(named: "Rogan O\'Connor"),
                     createChallenger(named: "Ashley Mitchell"),
                     createChallenger(named: "Josh Martinez"),
                     createChallenger(named: "Nany Gonzalez")]
        }
        return [createChallenger(named: "empty")]
    }
    
    static func chicagoManagers() -> [Manager] {
        return [Manager(email: "michaelsevy@gmail.com", contestantNames: [Challenger.genrateRandomChallenger().name,
                                                                          Challenger.genrateRandomChallenger().name,
                                                                          Challenger.genrateRandomChallenger().name,
                                                                          Challenger.genrateRandomChallenger().name]),
                Manager(email: "bryancauso@gmail.com", contestantNames: [Challenger.genrateRandomChallenger().name,
                                                                         Challenger.genrateRandomChallenger().name,
                                                                         Challenger.genrateRandomChallenger().name,
                                                                         Challenger.genrateRandomChallenger().name]),
                Manager(email: "shamirtrangle@gmail.com", contestantNames: [Challenger.genrateRandomChallenger().name,
                                                                            Challenger.genrateRandomChallenger().name,
                                                                            Challenger.genrateRandomChallenger().name,
                                                                            Challenger.genrateRandomChallenger().name]),
                Manager(email: "bryanjustus@gmail.com", contestantNames: [Challenger.genrateRandomChallenger().name,
                                                                          Challenger.genrateRandomChallenger().name,
                                                                          Challenger.genrateRandomChallenger().name,
                                                                          Challenger.genrateRandomChallenger().name]),
                Manager(email: "jmnash@gmail.com", contestantNames: [Challenger.genrateRandomChallenger().name,
                                                                     Challenger.genrateRandomChallenger().name,
                                                                     Challenger.genrateRandomChallenger().name,
                                                                     Challenger.genrateRandomChallenger().name]),
                Manager(email: "ryandrimalla@gmail.com", contestantNames: [Challenger.genrateRandomChallenger().name,
                                                                           Challenger.genrateRandomChallenger().name,
                                                                           Challenger.genrateRandomChallenger().name,
                                                                           Challenger.genrateRandomChallenger().name])]
    }
    
    private func createChallenger(named: String) -> Challenger {
        Challenger(forTest: indexFor(challenger: named), name: named, score: 11, active: true)
    }
    
    private func indexFor(challenger: String) -> Int {
        return Challenger.challengers.firstIndex(of: challenger)!
    }
    
    static func generateRandomManager() -> Manager {
        return Manager.chicagoManagers().randomElement()!
    }
}
