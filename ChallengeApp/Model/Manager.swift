//
//  Manager.swift
//  ChallengeApp
//
//  Created by Michael Sevy on 4/8/20.
//  Copyright © 2020 Michael Sevy. All rights reserved.
//

import Foundation
import SwiftUI

enum Teams {
    case sevy
    case caruso
    case drimalla
    case bj
    case shamir
    case nash
}
 
struct Manager {
    public var id: Int
    public var name: String
    public var image: String
    
//    public var team: [[String]:[Int]] {
//        let teamNames = Constants
//    }
    
//    public var weeksScores: [Int]
    //public var team: [String]
    // @TODO fetch this from firebase db in future, set up with a post now
    func challengersFor(manager: String) -> [Challenger] {
        if manager == "sevy" {
            return [createChallenger(named: "Jordan Wiseley"), createChallenger(named: "Kyle Christie"), createChallenger(named:"Kailah Casillas"), createChallenger(named: "Bayleigh Dayton")]
        } else if manager == "caruso" {
            return [createChallenger(named: "Johnny Bananas"), createChallenger(named: "Cory Wharton"), createChallenger(named: "Melissa Reeves"), createChallenger(named: "Swaggy C Williams")]
        } else if manager == "drimalla" {
            return [createChallenger(named: "Stephen Bear"),createChallenger(named: "Dee Nguyen"), createChallenger(named: "Mattie Breaux"), createChallenger(named: "Aneesa Ferreira")]
        } else if manager == "bj" {
            return  [createChallenger(named: "Jenny West"), createChallenger(named: "Fessy Shafaat"), createChallenger(named: "CT Tamburello"), createChallenger(named: "Jenna Compono")]
        } else if manager == "shamir" {
            return  [createChallenger(named: "Tori Deal"), createChallenger(named: "Wes Bergmann"),  createChallenger(named: "Nelson Thomas"), createChallenger(named: "Kaycee Clark")]
        } else if manager == "nash" {
            return  [createChallenger(named: "Rogan O\'Connor"), createChallenger(named: "Ashley Mitchell"), createChallenger(named: "Josh Martinez"), createChallenger(named: "Nany Gonzalez")]
        }
        return [createChallenger(named: "empty")]
    }
    
    static func fetchChicagoLeagueManagers() -> [Manager] {
        let names = ["sevy", "shamir", "nash", "caruso", "drimalla", "bj"]
        // @TODO pull from Firebase
        var managers = [Manager]()

        var i = 1
        while i < 50 {
            switch i {
            case 1:
                let manager = Manager(id: i, name: "sevy", image: "")
                managers.append(manager)
            case 2:
                let manager = Manager(id: i, name: "caruso", image: "")
                managers.append(manager)
            case 3:
                let manager = Manager(id: i, name: "drimalla", image: "")
                managers.append(manager)
            case 4:
                let manager = Manager(id: i, name: "bj", image: "")
                managers.append(manager)
            case 5:
                let manager = Manager(id: i, name: "shamir", image: "")
                managers.append(manager)
            case 6:
                let manager = Manager(id: i, name: "nash", image: "")
                managers.append(manager)
            default:
                let name = names.randomElement()!
                let manager = Manager(id: i, name: name, image: "")
                managers.append(manager)
            }
            i = i + 1
        }
        return managers
    }
    
    static func chicagoManagers() -> [Manager] {
        return [Manager(id: 0, name: "sevy", image: ""), Manager(id: 1, name: "caruso", image: ""), Manager(id: 2, name: "shamir", image: ""), Manager(id: 3, name: "bj", image: ""), Manager(id: 4, name: "nash", image: ""), Manager(id: 5, name: "drimalla", image: "")]
    }
    
    private func createChallenger(named: String) -> Challenger {
        Challenger(id: indexFor(challenger: named), name: named)
    }
    private func indexFor(challenger: String) -> Int {
         return Constants().contestants.firstIndex(of: challenger)!
    }
    
    static func generateRandomManager() -> Manager {
        return Manager.fetchChicagoLeagueManagers().randomElement()!
    }
}


extension Manager: Identifiable {
    
}
