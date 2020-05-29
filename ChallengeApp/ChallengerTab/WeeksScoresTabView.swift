//
//  WeeksScoresTabView.swift
//  ChallengeApp
//
//  Created by Michael Sevy on 4/8/20.
//  Copyright © 2020 Michael Sevy. All rights reserved.
//

import SwiftUI
import Combine

struct WeeksScoresTabView: View {
    var challengers = Challenger.generateTestChallengers()
    let weeks = ["0","1","2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16"]
    
    @State var weekSelection = 0
    @ObservedObject var challengeObserved = FirebaseManager()
    
    var body: some View {
        NavigationView {
            VStack {
                Section {
                    Picker(selection: $weekSelection.onChange(fetchData), label: Text("Week").padding()) {
                        ForEach(1 ..< self.weeks.count) {
                            Text(self.weeks[$0])
                        }
                    }.id(weekSelection)
                        .pickerStyle(DefaultPickerStyle())
                        .padding(EdgeInsets(top: -20, leading: 0, bottom: -20, trailing: 0))
                        .navigationBarTitle(ChallengeSeasons.totalMadness.rawValue)
                }
                List(challengeObserved.challengers) { ch in
                    ChallengerRow(challenger: ch, isPresented: true)
                }
            }
            .onAppear(perform: initialFetch)
        }
    }
}

extension Binding {
    func onChange(_ handler: @escaping (Value) -> Void) -> Binding<Value> {
        return Binding(
            get: { self.wrappedValue },
            set: { selection in
                self.wrappedValue = selection
                handler(selection)
        })
    }
}

extension WeeksScoresTabView {
    func fetchData(_ tag: Int) {
        challengeObserved.getScoresFor(week: weekSelection + 1, post: false)
    }
    
    func initialFetch() {
        self.weekSelection = challengeObserved.currentWeek
        challengeObserved.getScoresFor(week: weekSelection + 1, post: false)
    }
}

struct WeeksScoresTabView_Previews: PreviewProvider {
    static var previews: some View {
        WeeksScoresTabView(challengers: Challenger.generateTestChallengers(), weekSelection: 1)
    }
}
