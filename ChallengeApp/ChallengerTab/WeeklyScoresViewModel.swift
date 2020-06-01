//
//  WeeklyScoresViewModel.swift
//  ChallengeApp
//
//  Created by Michael Sevy on 5/31/20.
//  Copyright © 2020 Michael Sevy. All rights reserved.
//

import Foundation
import Combine
import Kanna

final class WeeklyScoresViewModel: ObservableObject, Identifiable {
    private let webScraper = WebScraper()
    @Published var challengers = [Challenger]()
    @Published var isLoading = true

    public func getScoresFor(week: Int) {
        self.webScraper.getScoresFor(week: week, success: { [weak self] (responseDescription) in
            guard let self = self else { return }

            self.challengers = [Challenger]()
            var challenger = Challenger(forTest: 0, name: "", score: 0, active: true)
            var names = [NSString]()
            var scores = [NSNumber]()
            var actives = [Bool]()
            var currentName = ""
            var counter = 1
            var previousName = ""
            var namePopulated = false
            var scorePopulated = false
            
            if let doc = try? HTML(html: responseDescription, encoding: .utf8) {
                for header in doc.css("a, h4") {
                    if let headerValue = header.text {
                        // Add the player
                        if Challenger.challengers.contains(headerValue) { // this is a challenger's name
                            challenger.id = counter
                            challenger.name = headerValue
                            actives.append(true)
                            names.append(headerValue as NSString)
                            counter += 1
                            namePopulated = true
                            scorePopulated = false
                            currentName = headerValue
                        } else { // the next one after will be their score
                            if headerValue.contains("Total:") {
                                // Get the number out and convert to Int
                                if let scoreInt = Int(headerValue.replacingOccurrences(of: "Total: ", with: "")) {
                                    challenger.score = scoreInt
                                    scores.append(scoreInt as NSNumber)
                                    scorePopulated = true
                                }
                            }
                        }
                    }
                    if scorePopulated && namePopulated && currentName != previousName {
                        self.challengers.append(challenger)
                        previousName = currentName
                    }
                }
                self.isLoading = false
            }
        }) { (failed) in
            print("failed to fetch from web scraper")
        }
    }
}
