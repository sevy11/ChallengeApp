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

class WebScrapManager {
    var contestants = ["Aneesa Ferreira", "Asaf Goren", "Ashley Mitchell", "Bayleigh Dayton", "Cory Wharton", "CT Tamburello", "Dee Nguyen", "Fessy Shafaat", "Jay Starrett", "Jenna Compono", "Jennifer Lee", "Jenny West", "Johnny Bananas", "Jordan Wiseley", "Josh Martinez", "Kailah Casillas", "Kaycee Clark", "Kyle Christie", "Mattie Breaux", "Melissa Reeves", "Nany Gonzalez", "Nelson Thomas", "Rogan O\'Connor", "Stephen Bear", "Swaggy C Williams", "Tori Deal", "Tula Fazakerley", "Wes Bergmann"]
    var managersTeams = [[String]]()

    var playerScores = [[String : Int]]()
    
    func currentWeek(completion: @escaping (Int) -> ()) {
        AF.request("https://www.realtvfantasy.com/shows/view/mtv-the-challenge-total-madness").responseString { response in
            let weeks = self.parseForCurrentWeek(html: response.description)
            completion(weeks)
        }
    }
    
    func scrapChallengeScores(week: Int, completion: @escaping (NamesAndScores) -> ()) {
        AF.request("https://www.realtvfantasy.com/shows/scores/mtv-the-challenge-total-madness/\(week)").responseString { response in
            let namesAndScores = self.parseForScores(html: response.description)
            completion(namesAndScores)
        }
    }

    private func parseForCurrentWeek(html: String) -> Int {
        var weeks = [Int]()
        
        if let doc = try? HTML(html: html, encoding: .utf8) {
            for header in doc.css("a, h4") {
                if let headerValue = header.text {
                    if headerValue.contains("Episode ") && headerValue.contains("Scores") {
                        // get the number out and convert to Int
                        let result = headerValue.trimmingCharacters(in: CharacterSet(charactersIn: "0123456789.").inverted)
                        if let intValue = Int(result) {
                            // @TODO see how this array gets populated when it's week 2.
                            weeks.append(intValue)
                        }
                    }
                }
            }
        }
        return weeks.last!
    }
    
    private func parseForScores(html: String) -> NamesAndScores {
        var players = [String]()
        var scores = [Int]()
        
        if let doc = try? HTML(html: html, encoding: .utf8) {
            for header in doc.css("a, h4") {
                if let headerValue = header.text {
                    // Add the player
                    if contestants.contains(headerValue) {
                        players.append(headerValue)
                    } else {
                        // the next one after will be their score
                        if headerValue.contains("Total:") {
                            // get the number out and convert to Int
                            if let scoreValue = Int(headerValue.replacingOccurrences(of: "Total: ", with: "")) {
                                scores.append(scoreValue)
                            }
                        }
                    }
                }
            }
        }
        return (players, scores)
    }
}
