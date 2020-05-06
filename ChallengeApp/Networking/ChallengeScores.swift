//
//  ChallengeScores.swift
//  ChallengeApp
//
//  Created by Michael Sevy on 4/17/20.
//  Copyright © 2020 Michael Sevy. All rights reserved.
//

import Foundation
import Alamofire
import Kanna
import Combine

class ChallengeScores: ObservableObject {
    @Published var challengers = [Challenger]()
    let firebaseManager = FirebaseManager()
    
    
    var contestants = ["Aneesa Ferreira", "Asaf Goren", "Ashley Mitchell", "Bayleigh Dayton", "Cory Wharton", "CT Tamburello", "Dee Nguyen", "Fessy Shafaat", "Jay Starrett", "Jenna Compono", "Jennifer Lee", "Jenny West", "Johnny Bananas", "Jordan Wiseley", "Josh Martinez", "Kailah Casillas", "Kaycee Clark", "Kyle Christie", "Mattie Breaux", "Melissa Reeves", "Nany Gonzalez", "Nelson Thomas", "Rogan O\'Connor", "Stephen Bear", "Swaggy C Williams", "Tori Deal", "Tula Fazakerley", "Wes Bergmann"]
    
    public func getScoresFor(week: Int) {
          AF.request("https://www.realtvfantasy.com/shows/scores/mtv-the-challenge-total-madness/\(week)").responseString { [weak self] response in
              guard let self = self else { return }
              
            // clear the array first:
            self.challengers = [Challenger]()
            var challenger = Challenger(forTest: 0, name: "", score: 0)
            var counter = 1
            var previousName = ""
            var namePopulated = false
            var scorePopulated = false
            
            if let doc = try? HTML(html: response.description, encoding: .utf8) {
                for header in doc.css("a, h4") {
                    if let headerValue = header.text {
                        // Add the player
                        if self.contestants.contains(headerValue) { // this is a challenger's name
                            challenger.id = counter
                            challenger.name = headerValue
                            counter += 1
                            namePopulated = true
                            scorePopulated = false
                        } else { // the next one after will be their score
                            if headerValue.contains("Total:") {
                                // get the number out and convert to Int
                                if let scoreInt = Int(headerValue.replacingOccurrences(of: "Total: ", with: "")) {
                                    challenger.score = scoreInt
                                    scorePopulated = true
                                }
                            }
                        }
                    }
                    if scorePopulated && namePopulated && challenger.name != previousName {
                        self.challengers.append(challenger)
                        previousName = challenger.name
                    }
                }
            }
            // send to firebase
            if self.challengers.count > 0 {
                self.firebaseManager.getSumScoresFor(week: week, challengers: self.challengers)
            }
        }
    }
    
    
}
