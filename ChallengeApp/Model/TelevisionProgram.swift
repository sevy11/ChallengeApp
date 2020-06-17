//
//  TelevisionProgram.swift
//  ChallengeApp
//
//  Created by Michael Sevy on 6/17/20.
//  Copyright © 2020 Michael Sevy. All rights reserved.
//

import Foundation

struct TelevisionProgram {
    var title: Title = .none

    enum Title: String {
        case none = "Choose League:"
        case challenge = "The Challenge"
        case survivor = "Survivor"
        case bachelor = "The Bachelor"
        case bachelorette = "The Bachelorette"
    }

    static let scoresCategories = ["Winning a regular challenge", "Survive Each Episode", "Confessional", "Verbal Fighting", "Kissing On The Lips", "Confessional", "Winning Final Challenge", "Coming in 2nd on final challenge", "Coming in 3rd on final challenge", "Winning an elimination", "Winning a regular challenge", "Making TJ say 'You Killed It'", "Being the first team to do a challenge", "Being the contestant to read the clue from TJ", "DQ/Quit a challenge" ]

}
