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
    // MARK: - Instance Variables
    @State private var weekSelection = 0
    @ObservedObject var viewModel = WeeklyScoresViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                if viewModel.isLoading {
                    ActivityIndicator(isAnimating: .constant(viewModel.isLoading), style: .large)
                } else if !viewModel.isLoading && viewModel.challengers.count > 0 {
                    Section {
                        Text("Week:").padding(EdgeInsets(top: 0, leading: -10, bottom: 0, trailing: 0))
                        Picker(selection: $weekSelection.onChange(fetchData), label: Text("").padding()) {
                            ForEach(1 ..< League.weeks.count) {
                                Text(League.weeks[$0])
                            }
                        }.id(weekSelection)
                            .labelsHidden()
                            .pickerStyle(DefaultPickerStyle())
                            .padding(EdgeInsets(top: -40, leading: 0, bottom: -40, trailing: 0))
                            .navigationBarTitle(ChallengeSeasons.totalMadness.rawValue)
                    }
                    List(viewModel.challengers) { challenger in
                        ChallengerRow(challenger: challenger, isPresented: true)
                    }
                } else {
                    Section {
                        Text("Week:").padding(EdgeInsets(top: 0, leading: -10, bottom: 0, trailing: 0))
                        Picker(selection: $weekSelection.onChange(fetchData), label: Text("").padding()) {
                            ForEach(1 ..< League.weeks.count) {
                                Text(League.weeks[$0])
                            }
                        }.id(weekSelection)
                            .labelsHidden()
                            .pickerStyle(DefaultPickerStyle())
                            .navigationBarTitle(ChallengeSeasons.totalMadness.rawValue)
                    }
                    Text("No scores available for this week yet 🙄")
                }
            }
            .onAppear(perform: initialFetch)
        }.navigationViewStyle(StackNavigationViewStyle())
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
        viewModel.getScoresFor(week: weekSelection + 1)
    }
    
    func initialFetch() {
        viewModel.getScoresFor(week: weekSelection + 1)
    }
}

struct WeeksScoresTabView_Previews: PreviewProvider {
    static var previews: some View {
        WeeksScoresTabView()
    }
}
