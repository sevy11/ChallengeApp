//
//  ChallengeTabViews.swift
//  ChallengeApp
//
//  Created by Michael Sevy on 4/7/20.
//  Copyright © 2020 Michael Sevy. All rights reserved.
//

import SwiftUI
import Combine


struct ManagerTabView: View {
    var managers = Manager.chicagoManagers()
    @ObservedObject var webScraperObserved = WebScrapManager()
    @ObservedObject var firebaseObserved = FirebaseManager()
    @ObservedObject var challengeObserved = ChallengeScores()
    var subscriptions = Set<AnyCancellable>()
    
    @State var weekDidUpdate = false
    
    var body: some View {
 
        VStack {
            Button(action: {
                self.getScores()
                 }) {
                  Text("Get Week")
                 }
            Spacer()
            Text("Chicago Challenge League").bold()
                .foregroundColor(.orange)
                .font(Font.system(size: 25))
            Text("Totals thru week: \(webScraperObserved.currentAvailableWeek)")
                .foregroundColor(.orange)
                .font(Font.system(size: 18))
            List(managers) { manager in
                ScrollView {
                    VStack {
                        Spacer()
                        Text("\(manager.name.uppercased())")
                            .bold()
                        Section {
                            ManagerRow(manager: manager)
                        }
                    }
                }.id(UUID().uuidString)
            }
        }.onAppear(perform: getCurrentWeek)
        
    }
    
    func openModalNewLeagueEntryForm() {
        print("new league open modal")
    }
    
    func getScores() {
        var subscriptions = Set<AnyCancellable>()
        
        webScraperObserved.getCurrentWeek()
        
        let publisher = webScraperObserved.currentAvailableWeek.publisher
        
        publisher.sink(receiveCompletion: {
            print("received completion on current week", $0)
        }, receiveValue: { week in
            
            print("received value on current week: now fetching scores for week \(week)")
            let weekStr = String(week)
            if let weekInt = Int(weekStr) {
                
                if self.firebaseObserved.scores ==  nil {
                    
                    print("fetching scores from web scraper")
                    self.challengeObserved.getScoresFor(week: weekInt)
                    
                } else {
                    print("firebase scores exist, follow this path")
                }
            }
        }).store(in: &subscriptions)
    }
    
    func getCurrentWeek() {
        webScraperObserved.getCurrentWeek()
    }
}

struct ManagerTabView_Previews: PreviewProvider {
    static var previews: some View {
        ManagerTabView(managers: Manager.chicagoManagers())
    }
}
