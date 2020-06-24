//
//  FirebaseManager.swift
//  ChallengeApp
//
//  Created by Michael Sevy on 4/12/20.
//  Copyright © 2020 Michael Sevy. All rights reserved.
//

import Foundation
import Combine
import Firebase
import Kanna
import Alamofire

/*
 Firebase Manager handles all call to the firebase realtime database
 */
class FirebaseManager: API {
    
    // MARK: - POST League
    func create(league: League, managerEmails: [String], user: User, posted: @escaping (_ posted: Bool) -> Void, failure: @escaping (_ failed: Error) -> Void) {
        let db = Database.database()
        let reference = db.reference().child("\(API.Endpoint.leagues.rawValue)\(league.name)").childByAutoId()
        
        guard let email = user.email else { return }
        
        let payload: [NSString : Any] = ["emails" : managerEmails, "creator_email" : email, "show" : league.show.title.rawValue]
        reference.setValue(payload) { error, ref in
            if let error = error {
                failure(error)
            } else {
                posted(true)
            }
        }
    }
    
    func updateLeagueWith(contestantNames: [String], managerEmail: String, leagueName: String, success: @escaping (_ posted: Bool) -> Void, failure: @escaping (_ failed: Error) -> Void) {
        let db = Database.database()
        let reference = db.reference().child("\(API.Endpoint.leagues.rawValue)\(leagueName)/").childByAutoId()
        
        let contestantMeta: [String : Any] = ["contestants" : contestantNames, "email" : managerEmail]
        reference.setValue(contestantMeta) { (error, reference) in
            if let error = error {
                failure(error)
            } else {
                success(true)
            }
        }
    }
    
    func postForWeek2(names: [NSString], scores: [NSNumber], actives: [Bool], completion: @escaping ((_ posted: Bool) -> Void)) {
        let db = Database.database()
        let reference = db.reference().child(API.Endpoint.challengers.rawValue)
        
        let payload: [String : Any] = ["names" : names, "scores" : scores, "actives" : actives, "week" : 2]
        
        reference.setValue(payload) { error, ref in
            if let error = error {
                print("error for scores post: \(error)")
                completion(false)
            } else {
                print("post challengers for week 2 successful")
                completion(true)
                // @TODO
                //self.defaults.saveChallengersFor(week: week, names: names, scores: scores)
                //DefaultsManager.saveScoresFor(week: week, scores: scores)
                //self.postedScores = true
            }
        }
    }
    
    func postPostWeek2(challengers: [Challenger], names: [NSString], week: Int, completion: ((_ snapshot: DataSnapshot?) -> Void)?) {
        let db = Database.database()
        let reference = db.reference().child(API.Endpoint.challengers.rawValue)
        
        reference.observeSingleEvent(of: .value) { (snapshot) in
            
            if snapshot.children.allObjects.count == 0 {
                completion!(nil)
            } else {
                completion!(snapshot)
            }
        }
    }
    
    func postSummed(scores: [Int], names: [String], actives: [Bool], week: Int, posted: @escaping (_ posted: Bool) -> Void) {
        let db = Database.database()
        let reference = db.reference().child(API.Endpoint.challengers.rawValue)
        
        let payload: [String : Any] = ["names" : names, "scores" : scores, "actives" : actives, "week" : week]
        
        reference.setValue(payload) { error, ref in
            
            if let error = error {
                print("error for scores post: \(error)")
                posted(false)
            } else {
                print("post updated challengers scores for week \(week) successfully")
                posted(true)
                // @TODO
                //self.defaults.saveChallengersFor(week: week, names: names, scores: scores)
                //DefaultsManager.saveScoresFor(week: week, scores: scores)
            }
        }
    }
    
    // MARK: - GET
    func getLeagues(success: @escaping (_ snapshot: DataSnapshot) -> Void, failure: @escaping (_ failure: Bool) -> Void) {
        let db = Database.database()
        let reference = db.reference().child("\(API.Endpoint.leagues.rawValue)")
        
        reference.observeSingleEvent(of: .value) { (snapshot) in
            if snapshot.children.allObjects.count == 0 {
                print("no league objects yet :(, handle condition")
                failure(true)
            } else {
                success(snapshot)
            }
        }
    }
    
    func getChallengersWith(week: Int, success: @escaping (_ snapshot: DataSnapshot) -> Void, failure: @escaping (_ failure: Bool) -> Void) {
        let db = Database.database()
        let reference = db.reference().child(API.Endpoint.challengers.rawValue)
        
        reference.observeSingleEvent(of: .value) { (snapshot) in
            if snapshot.children.allObjects.count == 0 {
                print("no challengers from firebase")
                failure(true)
            } else {
                success(snapshot)
            }
        }
    }
    
    func getChallengersFor(league: League, success: @escaping (_ snapshot: DataSnapshot) -> Void, failure: @escaping (_ failed: Bool) -> Void) {
        let db = Database.database()
        let reference = db.reference().child(API.Endpoint.challengers.rawValue)
        
        reference.observeSingleEvent(of: .value) { (snapshot) in
            if snapshot.children.allObjects.count == 0 {
                print("no challengers from firebase")
                failure(true)
            } else {
                success(snapshot)
            }
        }
    }
}
