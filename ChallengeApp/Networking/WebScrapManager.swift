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

let kTotalMadnessWeeklyEndpoint = "https://www.realtvfantasy.com/shows/scores/mtv-the-challenge-total-madness/"
let kWeekEndpoint               = "https://www.realtvfantasy.com/shows/view/mtv-the-challenge-total-madness"

final class WebScraper {
    
    public func getCurrentWeek(success: @escaping (_ description: String) -> Void) {
        AF.request(kWeekEndpoint).responseString { response in
            success(response.description)
        }
    }

    public func getScoresFor(week: Int, success: @escaping (_ response: String) -> Void) {
        AF.request("\(kTotalMadnessWeeklyEndpoint)\(week)").responseString { response in
            success(response.description)
        }
    }
}
