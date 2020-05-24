//
//  Show.swift
//  ChallengeApp
//
//  Created by Michael Sevy on 5/8/20.
//  Copyright © 2020 Michael Sevy. All rights reserved.
//

import Foundation

struct Show {
    public var id: Int
    public var name: String
    public var host: String {
        return "TJ Lavin"
    }
    
    init(id: Int, name: String) {
        self.id = id
        self.name = name
    }
    
    static func shows() -> [Show] {
        return [Show(id: 0, name: "The Challenge"),
                Show(id: 1, name: "Survivor")]
    }
    
    static func generateLeagueType() -> Show {
        return shows().randomElement()!
    }
    
    static func startingWeeks() -> [Int] {
        return [1,2,3]
    }
}

extension Show: Identifiable {
    
}
