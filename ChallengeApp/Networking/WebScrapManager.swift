//
//  Networking.swift
//  ChallengeApp
//
//  Created by Michael Sevy on 4/4/20.
//  Copyright © 2020 Michael Sevy. All rights reserved.
//

import Foundation
import Kanna
import Alamofire

typealias NamesAndScores = ([String], [Int])
// @TOD insert a firebase class to talk with a db that I'll put in the Game: Chicago League, managers and their teams

class WebScrapManager: ObservableObject {
    @Published var currentAvailableWeek: String = ""
    
//    var contestants = ["Aneesa Ferreira", "Asaf Goren", "Ashley Mitchell", "Bayleigh Dayton", "Cory Wharton", "CT Tamburello", "Dee Nguyen", "Fessy Shafaat", "Jay Starrett", "Jenna Compono", "Jennifer Lee", "Jenny West", "Johnny Bananas", "Jordan Wiseley", "Josh Martinez", "Kailah Casillas", "Kaycee Clark", "Kyle Christie", "Mattie Breaux", "Melissa Reeves", "Nany Gonzalez", "Nelson Thomas", "Rogan O\'Connor", "Stephen Bear", "Swaggy C Williams", "Tori Deal", "Tula Fazakerley", "Wes Bergmann"]
    var managersTeams = [[String]]()
    var weeksAvailable = [String]()
    
    func getCurrentWeek() {
        AF.request("https://www.realtvfantasy.com/shows/view/mtv-the-challenge-total-madness").responseString { response in
            self.parseForCurrentWeek(html: response.description)
        }
    }
    
    private func parseForCurrentWeek(html: String) {
        if let doc = try? HTML(html: html, encoding: .utf8) {
            for header in doc.css("a, h4") {
                if let headerValue = header.text {
                    if headerValue.contains("Episode ") && headerValue.contains("Scores") {
                        // get the number out and convert to Int
                        let result = headerValue.trimmingCharacters(in: CharacterSet(charactersIn: "0123456789.").inverted)
                      //  print("result: \(result)")
                        self.weeksAvailable.append(result)
                    }
                }
            }
        }
        let sorted = self.weeksAvailable.sorted { $0 > $1 }
       // print("weeks array: \(sorted)")
        if let first = sorted.first {
            self.currentAvailableWeek = first
        } else {
            self.currentAvailableWeek = ""
        }
    }
    
    func scrapChallengeScores(week: Int) {
        AF.request("https://www.realtvfantasy.com/shows/scores/mtv-the-challenge-total-madness/\(week)").responseString { response in
            
            var challenger = Challenger(forTest: 0, name: "", score: 0)
            var counter = 1
            
            if let doc = try? HTML(html: response.description, encoding: .utf8) {
                for header in doc.css("a, h4") {
                    if let headerValue = header.text {
                        // Add the player
                        if Challenger.challengers.contains(headerValue) {
                            challenger.id = counter
                            challenger.name = headerValue
                            counter += 1
                        } else {
                            // the next one after will be their score
                            if headerValue.contains("Total:") {
                                // get the number out and convert to Int
                                if let scoreInt = Int(headerValue.replacingOccurrences(of: "Total: ", with: "")) {
                                    challenger.score = scoreInt
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
