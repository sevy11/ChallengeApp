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
    //var image: String
//    var totalScore: [Int] {
//        return [12,4,5]
    // } compute this total scores from all weeks
//    let sum = multiples.reduce(0, +)
    
    static func genrateRandomChallenger() -> String {
        return Constants().contestants.randomElement()!
    }
    
    static func genrateRandomChallenger() -> Challenger {
        return generateChallengers().randomElement()!
    }
    
    static func generateChallengers() -> [Challenger] {
        return [Challenger(id: 0, name: "Aneesa Ferreira"), Challenger(id: 1, name: "Ashley Mitchell"), Challenger(id: 2, name: "Bayleigh Dayton"), Challenger(id: 3, name: "Cory Wharton"), Challenger(id: 4, name: "CT Tamburello"), Challenger(id: 5, name: "Dee Nguyen"), Challenger(id: 6, name: "Fessy Shafaat"), Challenger(id: 7, name: "Jenna Compono"), Challenger(id: 8, name: "Jenny West")]
    }
}

extension Challenger: Identifiable {

}
//["Aneesa Ferreira", "Asaf Goren", "Ashley Mitchell", "Bayleigh Dayton", "Cory Wharton", "CT Tamburello", "Dee Nguyen", "Fessy Shafaat", "Jay Starrett", "Jenna Compono", "Jennifer Lee", "Jenny West", "Johnny Bananas", "Jordan Wiseley", "Josh Martinez", "Kailah Casillas", "Kaycee Clark", "Kyle Christie", "Mattie Breaux", "Melissa Reeves", "Nany Gonzalez", "Nelson Thomas", "Rogan O\'Connor", "Stephen Bear", "Swaggy C Williams", "Tori Deal", "Tula Fazakerley", "Wes Bergmann"]
