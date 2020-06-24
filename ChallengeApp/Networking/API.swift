//
//  API.swift
//  ChallengeApp
//
//  Created by Michael Sevy on 6/20/20.
//  Copyright © 2020 Michael Sevy. All rights reserved.
//

import Foundation
import Combine
import Alamofire

extension AFError: Identifiable {
    public var id: Int {
        return 1
    }
}

class API {
    enum Endpoint: String {
        case totalMadnessScores     = "https://www.realtvfantasy.com/shows/scores/mtv-the-challenge-total-madness/"
        case totalMadnessHome       = "https://www.realtvfantasy.com/shows/view/mtv-the-challenge-total-madness"
        
        case challengersNames       = "challengers/names/"
        case challengersScore       = "challengers/scores/"
        case challengers            = "challengers/"
        case leagues                = "leagues/"
        case challengersWeeks       = "challengers/weeks/"
    }
}
