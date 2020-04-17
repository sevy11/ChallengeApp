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

class ChallengeScores: ObservableObject {
    @Published var challengers = [Challenger]()

    var contestants = ["Aneesa Ferreira", "Asaf Goren", "Ashley Mitchell", "Bayleigh Dayton", "Cory Wharton", "CT Tamburello", "Dee Nguyen", "Fessy Shafaat", "Jay Starrett", "Jenna Compono", "Jennifer Lee", "Jenny West", "Johnny Bananas", "Jordan Wiseley", "Josh Martinez", "Kailah Casillas", "Kaycee Clark", "Kyle Christie", "Mattie Breaux", "Melissa Reeves", "Nany Gonzalez", "Nelson Thomas", "Rogan O\'Connor", "Stephen Bear", "Swaggy C Williams", "Tori Deal", "Tula Fazakerley", "Wes Bergmann"]
    
    public func getScoresFor(week: Int) {
          AF.request("https://www.realtvfantasy.com/shows/scores/mtv-the-challenge-total-madness/\(week)").responseString { [weak self] response in
              guard let self = self else { return }
              
            // clear the array first:
            self.challengers = [Challenger]()
            
              var challenger = Challenger(id: 0, name: "", scoresForWeek: [Int]())
              var counter = 1
              var previousName = ""
            
              if let doc = try? HTML(html: response.description, encoding: .utf8) {
                  for header in doc.css("a, h4") {
                      if let headerValue = header.text {
                          // Add the player
                          if self.contestants.contains(headerValue) {
                            challenger.id = counter
                            challenger.name = headerValue
                            counter += 1
                          } else {
                            // the next one after will be their score
                            if headerValue.contains("Total:") {
                                // get the number out and convert to Int
                                if let scoreInt = Int(headerValue.replacingOccurrences(of: "Total: ", with: "")) {
                                    challenger.scoresForWeek.append(scoreInt)
                                }
                            }
                        }
                    }
                    if challenger.name.count > 0 && challenger.scoresForWeek.count > 0 && challenger.name != previousName  {
                        self.challengers.append(challenger)
                        previousName = challenger.name
                        challenger.scoresForWeek = [Int]()
                    }
                }
                print("array: \(self.challengers)")
            }
          }
      }
    
}
