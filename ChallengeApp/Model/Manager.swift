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
//import FBSDKCoreKit, when we start the sign in SDk

struct Manager {
    static let managersAvailable = ["3", "4", "5", "6", "7", "8"]

    public var name: String
    public var challengers: [Challenger]
   
    public var id: Int {// Firebase Id
 
//        if let user = Auth.auth().currentUser
//        return user.uid
        return 1
    }
    public var email: String { // Firebase email
        return ""
    }
    public var leagues: [League] {
        return [League.init(name: "Chicago Challenge")]
    }
    public var score: Int {
      var scores = [Int]()
      
      for ch in self.challengers {
          scores.append(ch.score)
      }
        let sum = scores.reduce(0, +)
        return sum
    }
    
    init(name: String, challengers: [Challenger]) {
        self.name = name
        self.challengers = challengers
    }
    
    // @TODO fetch this from firebase db in future, set up with a post now
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
    
    // @TODO replace this with
    static func managersForLeague(id: Int) -> [Manager] {
    
        return [Manager]()
    }
    
    static func chicagoManagers() -> [Manager] {
        let challengers = [Challenger.init(forTest: 0, name: "Aneesa", score: 5), Challenger.init(forTest: 1, name: "Bayleigh", score: 10), Challenger.init(forTest: 2, name: "Cory", score: 15), Challenger.init(forTest: 3, name: "CT", score: 20)]
        // @TODO replace with firebase manager for leagueId(to be randomly assigned when created)
        let managers = [Manager(name: "sevy", challengers: challengers),
                        Manager(name: "caruso", challengers: challengers),
                        Manager(name: "shamir", challengers: challengers),
                        Manager(name: "bj", challengers: challengers),
                        Manager(name: "nash", challengers: challengers),
                        Manager(name: "drimalla", challengers: challengers)]

        return managers as! [Manager]
    }
    
    private func createChallenger(named: String) -> Challenger {
        Challenger(forTest: indexFor(challenger: named), name: named, score: 11)
    }
    private func indexFor(challenger: String) -> Int {
        return Challenger.challengers.firstIndex(of: challenger)!
    }
    
    static func generateRandomManager() -> Manager {
        return Manager.chicagoManagers().randomElement()!
    }
}


extension Manager: Identifiable {
    
}
