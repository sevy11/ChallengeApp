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
import Firebase

class WebScrapManager: ObservableObject {
    @Published var currentAvailableWeek: String = ""
    var managersTeams = [[String]]()
    var weeksAvailable = [String]()
    let firebaseManager = FirebaseManager()

    func getCurrentWeek(user: User) {
        AF.request("https://www.realtvfantasy.com/shows/view/mtv-the-challenge-total-madness").responseString { response in
            self.parseForCurrentWeek(html: response.description, user: user)
        }
    }
    
    private func parseForCurrentWeek(html: String, user: User) {
        if let doc = try? HTML(html: html, encoding: .utf8) {
            for header in doc.css("a, h4") {
                if let headerValue = header.text {
                    if headerValue.contains("Episode ") && headerValue.contains("Scores") {
                        // get the number out and convert to Int
                        let result = headerValue.trimmingCharacters(in: CharacterSet(charactersIn: "0123456789.").inverted)
                        self.weeksAvailable.append(result)
                    }
                }
            }
        }
        let sorted = self.weeksAvailable.sorted { $0 > $1 }
        if let currentWeek = sorted.first {
            self.currentAvailableWeek = currentWeek
            self.firebaseManager.compareScraperAndFetchScoresIfNecesary(week: currentWeek)
        } else {
            self.currentAvailableWeek = "Loading..."
        }
    }
}
