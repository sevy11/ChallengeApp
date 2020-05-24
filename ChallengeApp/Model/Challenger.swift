//
//  Challenger.swift
//  ChallengeApp
//
//  Created by Michael Sevy on 4/8/20.
//  Copyright © 2020 Michael Sevy. All rights reserved.
//

import Foundation
import Firebase

struct Challenger {
    static var challengers = ["Aneesa Ferreira", "Asaf Goren", "Ashley Mitchell", "Bayleigh Dayton", "Cory Wharton", "CT Tamburello", "Dee Nguyen", "Fessy Shafaat", "Jay Starrett", "Jenna Compono", "Jennifer Lee", "Jenny West", "Johnny Bananas", "Jordan Wiseley", "Josh Martinez", "Kailah Casillas", "Kaycee Clark", "Kyle Christie", "Mattie Breaux", "Melissa Reeves", "Nany Gonzalez", "Nelson Thomas", "Rogan O\'Connor", "Stephen Bear", "Swaggy C Williams", "Tori Deal", "Tula Fazakerley", "Wes Bergmann"]
    static let challengerCount = 28
    public var id: Int
    public var name: String
    public var score: Int
    public var week: Int?
    
    init(forTest: Int, name: String, score: Int) {
        self.id = forTest
        self.name = name
        self.score = score
    }
    
    init(id: Int, name: String, score: Int) {
        self.id = id
        self.name = name
        self.score = score
    }
    
    func scoresFor(challenger: Challenger) -> [Int] {
        return [11,13,15]
    }

    static func genrateRandomChallenger() -> Challenger {
        return generateTestChallengers().randomElement()!
    }
    
    static func generateTestChallengers() -> [Challenger] {
        return [Challenger(forTest: 0, name: "Aneesa Ferreira", score: 11),
                Challenger(forTest: 1, name: "Ashley Mitchell", score: 13),
                Challenger(forTest: 2, name: "Bayleigh Dayton", score: 7),
                Challenger(forTest: 3, name: "Cory Wharton", score: 8),
                Challenger(forTest: 4, name: "CT Tamburello", score: 30),
                Challenger(forTest: 5, name: "Dee Nguyen", score: 20)]
    }
}

extension Challenger: Identifiable {

}
