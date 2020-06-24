//
//  Networking.swift
//  ChallengeApp
//
//  Created by Michael Sevy on 4/4/20.
//  Copyright © 2020 Michael Sevy. All rights reserved.
//

import Foundation
import Alamofire
import Combine

final class WebScraper {
    private let apiQueue = DispatchQueue(label: "API", qos: .default, attributes: .concurrent)

    func getCurrentWeek() -> DataResponsePublisher<String> {
        AF.request(API.Endpoint.totalMadnessHome.rawValue).responseString { response in
        }.publishString()
    }

    func getScoresFor(week: Int) -> DataResponsePublisher<String> {
        AF.request("\(API.Endpoint.totalMadnessScores.rawValue)\(week)").responseString { response in
        }.publishString()
    }
}
