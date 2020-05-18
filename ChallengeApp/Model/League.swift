//
//  League.swift
//  ChallengeApp
//
//  Created by Michael Sevy on 5/8/20.
//  Copyright © 2020 Michael Sevy. All rights reserved.
//

import Foundation
import Firebase


struct League {
    public var name: String
    // Freeze starting league at second week for now
    public var startingWeek: Int = 2
    public var id: Int {
        // create id
        // pull from firebase to see last number created and concatonate
        return 00001
    }
    // @TODO feed in real managers
    public var managers: [Manager] {
        return [Manager.init(name: "Sevy", challengers: [Challenger.init(id: 0, name: "Aneesa", score: 87)])]
    }
    
    var type: Show {
        return Show(id: 0, name: "Survivor")
    }
    // @TODO
    init?(datasnapShot: DataSnapshot) {
        self.name = ""
        self.startingWeek = 1
    }
    
    init(name: String) {
        self.name = name
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
