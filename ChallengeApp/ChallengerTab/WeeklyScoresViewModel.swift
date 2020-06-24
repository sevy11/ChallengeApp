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
import Alamofire

protocol WeeklyScoresProtocol {
    func getScoresFor(week: Int)
}

final class WeeklyScoresViewModel: WeeklyScoresProtocol, ObservableObject, Identifiable {
    @Published var challengers = [Challenger]()
    @Published var weekError: AFError? = nil
    @Published var isLoading = true
    
    private var subscriptions = Set<AnyCancellable>()
    private let webScraper = WebScraper()

    // MARK: - Functions
    public func getScoresFor(week: Int) {
        self.webScraper
        .getScoresFor(week: week)
        .receive(on: DispatchQueue.main)
        .sink(receiveCompletion: { completion in
        }, receiveValue: { [weak self] weekResponse in
            guard let self = self else { return }
            
            if let htmlRaw = weekResponse.value {
                self.parseRaw(html: htmlRaw)
                self.weekError = nil
            } else if let error = weekResponse.error {
                self.isLoading = false
                self.weekError = error
            }
        }).store(in: &subscriptions)
    }
    
    private func parseRaw(html: String) {
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

        if let doc = try? HTML(html: html, encoding: .utf8) {
            for header in doc.css("a, h4, span") {
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
    }
}
