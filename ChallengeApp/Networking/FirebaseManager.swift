//
//  FirebaseManager.swift
//  ChallengeApp
//
//  Created by Michael Sevy on 4/12/20.
//  Copyright © 2020 Michael Sevy. All rights reserved.
//

import Foundation
import Firebase

class FirebaseManager {
    static let shared = FirebaseManager()
    var db: Database
    
    public init() {
        db = Database.database()
    }
    
    // POST
    func post(managers: [Manager], success: @escaping (_ up: [Manager]) -> Void, failure: @escaping (_ error: Error) -> Void) {
        
        let upReference = db.reference().child("ups/").childByAutoId()
        let metaData = [1:"Sevy"]
        
        upReference.setValue(metaData) { error, ref in
            if let error = error {
                failure(error)
            }  else {
                //success((upReference.key as NSString?)!)
            }
        }
    }
    
    // GET
    func getManagers(success: @escaping (_ up: [Manager]) -> Void, failure: @escaping (_ error: Error) -> Void) {
        
        db.reference().child("managers/").observeSingleEvent(of: .value, with: { (snapshot) in
            print(snapshot)
//            let up = Up(snapshot: snapshot)
//            success(up!)
        }) { (error: Error) in
            failure(error)
        }
    }
}
