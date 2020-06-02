//
//  League.swift
//  ChallengeApp
//
//  Created by Michael Sevy on 5/8/20.
//  Copyright © 2020 Michael Sevy. All rights reserved.
//

import Foundation
import Firebase

enum ChallengeSeasons: String {
    case totalMadness = "Total Madness"
}

struct League {
    static let weeks = ["0","1","2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16"]

    public var name: String
    public var creatorEmail: String?
    public var id: Int {
        return 00001
    }
    public var managers: [Manager]?
    public var managersInLeague: Int?
    public var show: Show?
   
    init(name: String) {
        self.name = name
    }
    // MARK: - Testing
    static func testLeagues() -> [League] {
        return [League.init(name: "Chicago Challenge"),
                League.init(name: "Chicago Survivor"),
                League.init(name: "Miami Challenge")]
    }
    
    static func generateRandomLeague() -> League {
        return League.testLeagues().randomElement()!
    }
}


extension League: Identifiable {
    
}
