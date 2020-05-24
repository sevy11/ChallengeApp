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
    public var name: String
    public var creatorEmail: String?
    public var id: Int {
        return 00001
    }

    public var managers: [Manager]?
    
    var type: Show {
        return Show(id: 0, name: "Survivor")
    }

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
