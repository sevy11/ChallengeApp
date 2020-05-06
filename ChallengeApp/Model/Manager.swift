//
//  Manager.swift
//  ChallengeApp
//
//  Created by Michael Sevy on 4/8/20.
//  Copyright © 2020 Michael Sevy. All rights reserved.
//

import Foundation
import SwiftUI
import Combine
 
struct Manager {
    public var id: Int
    public var name: String
    public var image: String
//    public var challengers: [Challenger]
    public var score: Int {
        for ch in self.challengers {
            
        }
    }
    
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
    
    static func chicagoManagers() -> [Manager] {
        let managers = [Manager(id: 0, name: "sevy", image: "", score: 3), Manager(id: 1, name: "caruso", image: "", score: 15), Manager(id: 2, name: "shamir", image: "", score: 8), Manager(id: 3, name: "bj", image: "", score: 2), Manager(id: 4, name: "nash", image: "", score: 10), Manager(id: 5, name: "drimalla", image: "", score: 7)]

        let sortedArray = managers.sorted { $0.score > $1.score }
        return sortedArray
    }
    
    private func createChallenger(named: String) -> Challenger {
        Challenger(forTest: indexFor(challenger: named), name: named, score: 11)
    }
    private func indexFor(challenger: String) -> Int {
         return Constants().contestants.firstIndex(of: challenger)!
    }
    
    static func generateRandomManager() -> Manager {
        return Manager.chicagoManagers().randomElement()!
    }
}


extension Manager: Identifiable {
    
}
