//
//  Challenger.swift
//  ChallengeApp
//
//  Created by Michael Sevy on 4/8/20.
//  Copyright © 2020 Michael Sevy. All rights reserved.
//

import Foundation

struct Challenger {
    public var id: Int
    public var name: String
    public var scoresForWeek: [Int] //scores for latest week or [[Int]]
    //let total = numbers.reduce(0, +)
    
    func scoresFor(challenger: Challenger) -> [Int] {
        return [11,13,15]
    }
    
    static func genrateRandomChallenger() -> String {
        return Constants().contestants.randomElement()!
    }
    
    static func genrateRandomChallenger() -> Challenger {
        return generateTestChallengers().randomElement()!
    }
    
    static func generateTestChallengers() -> [Challenger] {
        return [Challenger(id: 0, name: "Aneesa Ferreira", scoresForWeek: [12]), Challenger(id: 1, name: "Ashley Mitchell", scoresForWeek: [11]), Challenger(id: 2, name: "Bayleigh Dayton", scoresForWeek: [13]), Challenger(id: 3, name: "Cory Wharton", scoresForWeek: [55]), Challenger(id: 4, name: "CT Tamburello", scoresForWeek: [40]), Challenger(id: 5, name: "Dee Nguyen", scoresForWeek: [20]), Challenger(id: 6, name: "Fessy Shafaat", scoresForWeek: [14]), Challenger(id: 7, name: "Jenna Compono", scoresForWeek: [5]), Challenger(id: 8, name: "Jenny West", scoresForWeek: [20])]
    }
}

extension Challenger: Identifiable {

}
