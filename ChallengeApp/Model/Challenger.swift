//
//  Challenger.swift
//  ChallengeApp
//
//  Created by Michael Sevy on 4/8/20.
//  Copyright © 2020 Michael Sevy. All rights reserved.
//

import Foundation
import Firebase

struct Challenger: Identifiable {
    static let challengers = ["Aneesa Ferreira", "Asaf Goren", "Ashley Mitchell", "Bayleigh Dayton", "Cory Wharton", "CT Tamburello", "Dee Nguyen", "Fessy Shafaat", "Jay Starrett", "Jenna Compono", "Jennifer Lee", "Jenny West", "Johnny Bananas", "Jordan Wiseley", "Josh Martinez", "Kailah Casillas", "Kaycee Clark", "Kyle Christie", "Mattie Breaux", "Melissa Reeves", "Nany Gonzalez", "Nelson Thomas", "Rogan O\'Connor", "Stephen Bear", "Swaggy C Williams", "Tori Deal", "Tula Fazakerley", "Wes Bergmann"]
    
    static let survivors = ["Aneesa Ferreira", "Asaf Goren", "Ashley Mitchell", "Bayleigh Dayton", "Cory Wharton", "CT Tamburello", "Dee Nguyen", "Fessy Shafaat", "Jay Starrett", "Jenna Compono", "Jennifer Lee", "Jenny West", "Johnny Bananas", "Jordan Wiseley", "Josh Martinez", "Kailah Casillas", "Kaycee Clark", "Kyle Christie", "Mattie Breaux", "Melissa Reeves", "Nany Gonzalez", "Nelson Thomas", "Rogan O\'Connor", "Stephen Bear", "Swaggy C Williams", "Tori Deal", "Tula Fazakerley", "Wes Bergmann"]
    public var id: Int
    public var name: String
    public var score: Int
    public var active: Bool
    public var week: Int?
    
    init(forTest: Int, name: String, score: Int, active: Bool) {
        self.id = forTest
        self.name = name
        self.score = score
        self.active = true
    }
    
    init(id: Int, name: String, score: Int, active: Bool) {
        self.id = id
        self.name = name
        self.score = score
        self.active = active
    }
    
    func scoresFor(challenger: Challenger) -> [Int] {
        return [11,13,15]
    }

    static func genrateRandomChallenger() -> Challenger {
        return generateTestChallengers().randomElement()!
    }
    
    static func generateTestChallengers() -> [Challenger] {
        return [Challenger(forTest: 0, name: "Aneesa Ferreira", score: 11, active: true),
                Challenger(forTest: 1, name: "Ashley Mitchell", score: 13, active: false),
                Challenger(forTest: 2, name: "Bayleigh Dayton", score: 7, active: true),
                Challenger(forTest: 3, name: "Cory Wharton", score: 8, active: true),
                Challenger(forTest: 4, name: "CT Tamburello", score: 30, active: false),
                Challenger(forTest: 5, name: "Dee Nguyen", score: 20, active: true)]
    }
    
    static func parseWith(snapshot: DataSnapshot) -> [Challenger]? {
          var challengers = [Challenger]()
          
          if let values = snapshot.value as? [NSString : Any],
              let names   = values["names"] as? [String],
              let scores  = values["scores"] as? [Int],
              let week    = values["week"] as? Int,
              let actives = values["actives"] as? [Bool] {
              
              var counter = 0
              var ch = Challenger.init(id: 0, name: "", score: 0, active: true)
              ch.week = week
              
              for n in names {
                  ch.id = counter
                  ch.name = n
                  ch.score = scores[counter]
                  ch.active = actives[counter]
                  counter += 1
                  
                  challengers.append(ch)
              }
          }
          return challengers
      }
}

struct WeeklyDetail: Identifiable {
    var id: Int
    var challengerName: String
    var descriptions: [ScoreDescription]
}

struct ScoreDescription: Identifiable {
    var id: Int
    var title: String
    var score: String
}


