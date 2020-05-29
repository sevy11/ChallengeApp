//
//  NotificationName+Extension.swift
//  ChallengeApp
//
//  Created by Michael Sevy on 5/28/20.
//  Copyright © 2020 Michael Sevy. All rights reserved.
//

import Foundation

extension Notification.Name {
    
    // MARK: - Internal Notifications
    static let UpdatedChallengerScores  = Notification.Name("UpdatedChallengerScoresNotification")
    static let LeagueCompletedSaving    = Notification.Name("LeagueFinishedSavingNotification")
}
