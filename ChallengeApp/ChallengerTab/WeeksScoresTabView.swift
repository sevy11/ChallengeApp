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
    @State var weekSelection = 0
    let weeks = ["0","1","2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16"]
    @ObservedObject var challengeObserved = ChallengeScores()
    
    var body: some View {
        VStack {
            Section {
                Picker(selection: $weekSelection.onChange(fetchData), label: Text("Week").padding()) {
                    ForEach(1 ..< self.weeks.count) {
                        Text(self.weeks[$0])
                    }
                }.id(weekSelection)
                    .pickerStyle(DefaultPickerStyle())
            }
            List(challengeObserved.challengers) { ch in
                ChallengerRow(challenger: ch, isPresented: true)
            }
        }
        .onAppear(perform: initialFetch)
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
        challengeObserved.getScoresFor(week: weekSelection + 1)
    }
    
    func initialFetch() {
        challengeObserved.getScoresFor(week: weekSelection + 1)
    }
}

struct WeeksScoresTabView_Previews: PreviewProvider {
    static var previews: some View {
        WeeksScoresTabView(challengers: Challenger.generateTestChallengers(), weekSelection: 1)
    }
}
