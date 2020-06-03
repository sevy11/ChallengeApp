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

let kChallengersNamesEndpoint   = "challengers/names/"
let kChallengersScoresEndpoint  = "challengers/scores/"
let kChallengersEndpoint        = "challengers/"
let kLeagueEndpoint             = "leagues/"
let kChallengersWeeksEndpoint   = "challengers/weeks/"

/*
    Firebase Manager handles all call to the firebase realtime database
 */
class FirebaseManager: ObservableObject {
    @Published var challengers = [Challenger]()
    @Published var leaguePostedSuccessfully = false
    @Published var leagues = [League]()
    @Published var league: League?
    @Published var leagueName = ""
    @Published var managers = [Manager]()

    // MARK: - POST League
    func createLeagueWith(name: String, managerEmails: [String], user: User, show: String, posted: @escaping (_ posted: Bool) -> Void, failure: @escaping (_ failed: Error) -> Void) {
         let db = Database.database()
         let reference = db.reference().child("\(kLeagueEndpoint)\(name)").childByAutoId()
         
         guard let email = user.email else { return }
         
        let payload: [NSString : Any] = ["emails" : managerEmails, "creator_email" : email, "show" : show]
         reference.setValue(payload) { error, ref in
             if let error = error {
                failure(error)
             } else {
                posted(true)
             }
         }
     }
    
    public func updateLeagueWith(contestantNames: [String], managerEmail: String, leagueName: String, success: @escaping (_ posted: Bool) -> Void, failure: @escaping (_ failed: Error) -> Void) {
        let db = Database.database()
        let reference = db.reference().child("\(kLeagueEndpoint)\(leagueName)/").childByAutoId()
        
        let contestantMeta: [String : Any] = ["contestants" : contestantNames, "email" : managerEmail]
        reference.setValue(contestantMeta) { (error, reference) in
            if let error = error {
                failure(error)
            } else {
                success(true)
            }
        }
    }

    public func getLeagues(success: @escaping (_ snapshot: DataSnapshot) -> Void, failure: @escaping (_ failure: Bool) -> Void) {
        let db = Database.database()
        let reference = db.reference().child("\(kLeagueEndpoint)")
        
        reference.observeSingleEvent(of: .value) { (snapshot) in
            if snapshot.children.allObjects.count == 0 {
                print("no league objects yet :(, handle condition")
                failure(true)
            } else {
                success(snapshot)
            }
        }
    }
    
    public func getChallengersWith(week: Int, success: @escaping (_ snapshot: DataSnapshot) -> Void, failure: @escaping (_ failure: Bool) -> Void) {
        let db = Database.database()
        let reference = db.reference().child(kChallengersEndpoint)
        
        reference.observeSingleEvent(of: .value) { (snapshot) in
            if snapshot.children.allObjects.count == 0 {
                print("no challengers from firebase")
                failure(true)
            } else {
                success(snapshot)
            }
        }
    }
    
    public func getChallengersFor(league: League, success: @escaping (_ snapshot: DataSnapshot) -> Void, failure: @escaping (_ failed: Bool) -> Void) {
        let db = Database.database()
        let reference = db.reference().child(kChallengersEndpoint)
        
        reference.observeSingleEvent(of: .value) { (snapshot) in
            if snapshot.children.allObjects.count == 0 {
                print("no challengers from firebase")
                failure(true)
            } else {
                success(snapshot)
            }
        }
    }

    func postForWeek2(names: [NSString], scores: [NSNumber], actives: [Bool], completion: ((_ posted: Bool) -> Void)?) {
        let db = Database.database()
        let reference = db.reference().child(kChallengersEndpoint)
        
        let payload: [String : Any] = ["names" : names, "scores" : scores, "actives" : actives, "week" : 2]
        
        reference.setValue(payload) { error, ref in
            
            if let error = error {
                print("error for scores post: \(error)")
                completion!(false)
            } else {
                print("post challengers for week 2 successful")
                completion!(true)
                // @TODO
                //self.defaults.saveChallengersFor(week: week, names: names, scores: scores)
                //DefaultsManager.saveScoresFor(week: week, scores: scores)
                //self.postedScores = true
            }
        }
    }
    
    // MARK: - All other weeks will add the new scores on
    public func postPostWeek2(challengers: [Challenger], names: [NSString], week: Int, completion: ((_ snapshot: DataSnapshot?) -> Void)?) {
        let db = Database.database()
        let reference = db.reference().child(kChallengersEndpoint)
        
        reference.observeSingleEvent(of: .value) { (snapshot) in
            
            if snapshot.children.allObjects.count == 0 {
                completion!(nil)
            } else {
                completion!(snapshot)
            }
        }
    }
      
    public func postSummed(scores: [Int], names: [String], actives: [Bool], week: Int, posted: @escaping (_ posted: Bool) -> Void) {
        let db = Database.database()
        let reference = db.reference().child(kChallengersEndpoint)
        
        let payload: [String : Any] = ["names" : names, "scores" : scores, "actives" : actives, "week" : week]
        
        reference.setValue(payload) { error, ref in
            
            if let error = error {
                print("error for scores post: \(error)")
                posted(false)
            } else {
                print("post updated challengers scores for week \(week) successfully")
                posted(true)
                // And now return the managers to the UI, with:
//                NotificationCenter.default.post(name: Notification.Name.UpdatedChallengerScores, object: nil)
                // @TODO
                //self.defaults.saveChallengersFor(week: week, names: names, scores: scores)
                //DefaultsManager.saveScoresFor(week: week, scores: scores)
            }
        }
    }
        
}
