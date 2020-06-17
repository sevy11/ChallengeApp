//
//  CreateNewLeagueEnterChallengersView.swift
//  ChallengeApp
//
//  Created by Michael Sevy on 5/14/20.
//  Copyright © 2020 Michael Sevy. All rights reserved.
//

import SwiftUI
import Combine
import Firebase

struct EnterChallengersView: View {
    // MARK: - Instance Variables
    var league: League
    var managers: [String]
    var user: User?
    var slotsToDisplay: Int {
        league.show.title == .challenge ? (Challenger.challengers.count / managers.count) : (Challenger.survivors.count / managers.count)
    }
    
    @State private var managerCounter = 0
    @State private var challengerCount = 0
    @State private var buttonTapped: Int? = nil
    @State private var challenger1 = ""
    @State private var challenger2 = ""
    @State private var challenger3 = ""
    @State private var challenger4 = ""
    @State private var challenger5 = ""
    @State private var challenger6 = ""
    @State private var challenger7 = ""
    @State private var challenger8 = ""
    @State private var challenger9 = ""
    @State private var buttonTitle = "Next Manager"
    
    @Binding var showModal: Bool
    @ObservedObject var viewModel = EnterChallengersViewModel()
    private let pub = NotificationCenter.default.publisher(for: Notification.Name.LeagueCompletedSaving)

    var body: some View {
        VStack {
            List {
                if slotsToDisplay == 2 {
                    if challenger1 == "" {
                        Text("Choose a Challenger for \(managers[managerCounter]):")
                            .bold()
                    } else {
                        Text("1. \(challenger1)")
                        Text("2. \(challenger2)")
                    }
                } else if slotsToDisplay == 3 {
                    if challenger1 == "" {
                        Text("Choose a Challenger for \(managers[managerCounter])")
                    } else {
                        Text("1. \(challenger1)")
                        Text("2. \(challenger2)")
                        Text("3. \(challenger3)")
                    }
                } else if slotsToDisplay == 4 {
                    if challenger1 == "" {
                        Text("Choose a Challenger for \(managers[managerCounter])")
                    } else {
                        Text("1. \(challenger1)")
                        Text("2. \(challenger2)")
                        Text("3. \(challenger3)")
                        Text("4. \(challenger4)")
                    }
                } else if slotsToDisplay == 5 {
                    if challenger1 == "" {
                        Text("Choose a Challenger for \(managers[managerCounter])")
                    } else {
                        Text("1. \(challenger1)")
                        Text("2. \(challenger2)")
                        Text("3. \(challenger3)")
                        Text("4. \(challenger4)")
                        Text("5. \(challenger5)")
                    }
                } else if slotsToDisplay == 6 {
                    if challenger1 == "" {
                        Text("Choose a Challenger for \(managers[managerCounter])")
                    } else {
                        Text("1. \(challenger1)")
                        Text("2. \(challenger2)")
                        Text("3. \(challenger3)")
                        Text("4. \(challenger4)")
                        Text("5. \(challenger5)")
                        Text("6. \(challenger6)")
                    }
                } else if slotsToDisplay == 7 {
                    if challenger1 == "" {
                        Text("Choose a Challenger for \(managers[managerCounter])")
                    } else {
                        Text("1. \(challenger1)")
                        Text("2. \(challenger2)")
                        Text("3. \(challenger3)")
                        Text("4. \(challenger4)")
                        Text("5. \(challenger5)")
                        Text("6. \(challenger6)")
                        Text("7. \(challenger7)")
                    }
                } else if slotsToDisplay == 8 {
                    if challenger1 == "" {
                        Text("Choose a Challenger for \(managers[managerCounter])")
                    } else {
                        Text("1. \(challenger1)")
                        Text("2. \(challenger2)")
                        Text("3. \(challenger3)")
                        Text("4. \(challenger4)")
                        Text("5. \(challenger5)")
                        Text("6. \(challenger6)")
                        Text("7. \(challenger7)")
                        Text("8. \(challenger8)")
                    }
                } else if slotsToDisplay == 9 {
                    if challenger1 == "" {
                        Text("Choose a Challenger for \(managers[managerCounter])")
                    } else {
                        Text("1. \(challenger1)")
                        Text("2. \(challenger2)")
                        Text("3. \(challenger3)")
                        Text("4. \(challenger4)")
                        Text("5. \(challenger5)")
                        Text("6. \(challenger6)")
                        Text("7. \(challenger7)")
                        Text("8. \(challenger8)")
                        Text("9. \(challenger9)")
                    }
                }
                Spacer()
                ForEach(viewModel.challengers, id: \.self) { challenger in
                    Button(action: {
                        self.assign(challenger: challenger)
                    }) {
                        Text(challenger)
                    }
                }
            }
            NavigationLink(destination: ManagerTabView(user: user!), tag: 1, selection: $buttonTapped) {
                // Move on to next manger or finish up
                Button(action: {
                    self.save(manager: self.managers[self.managerCounter])
                }) {
                    Text(self.buttonTitle)
                }
            }
            .padding(20)
            .background(LinearGradient(gradient: Gradient(colors: [.gray, .babyBlue]), startPoint: .leading, endPoint: .trailing))
            .foregroundColor(.black)
            .cornerRadius(40)
            Spacer()
        }
        .navigationBarTitle(managers[managerCounter])
        .navigationBarItems(trailing: Button(action: {
            self.showModal = false
        }) {
            Image(systemName: "xmark")
        })
    }
    
    func save(manager: String) {
        viewModel.update(league: league, managerEmail: manager)
        
        if managerCounter == managers.count - 1 {
            print("League Entry Complete, Pop back to root view.")
            DefaultsManager.saveDefaultLeague(name: league.name)
            self.buttonTapped = 1
            self.showModal = false
        } else if managerCounter == managers.count - 2 {
            print("Last entry before league complete.")
            self.buttonTitle = "Complete League"
            self.buttonTapped = 0
            self.clearChallengersForNextManagerEntry()
        } else {
            self.buttonTapped = 0
            self.clearChallengersForNextManagerEntry()
        }
    }
    
    func clearChallengersForNextManagerEntry() {
        viewModel.challengersForManager.removeAll()
        challengerCount = 0
        managerCounter += 1

        challenger1 = ""
        challenger2 = ""
        challenger3 = ""
        challenger4 = ""
        challenger5 = ""
        challenger6 = ""
        challenger7 = ""
        challenger8 = ""
        challenger9 = ""
    }
    
    func assign(challenger: String) {
        if challengerCount == 0 {
            challenger1 = challenger
            viewModel.challengers = viewModel.challengers.filter { $0 != challenger }
            viewModel.challengersForManager.append(challenger)
        } else if challengerCount == 1 {
            challenger2 = challenger
            viewModel.challengers = viewModel.challengers.filter { $0 != challenger }
            viewModel.challengersForManager.append(challenger)
        } else if challengerCount == 2 {
            challenger3 = challenger
            viewModel.challengers = viewModel.challengers.filter { $0 != challenger }
            viewModel.challengersForManager.append(challenger)
        } else if challengerCount == 3 {
            challenger4 = challenger
            viewModel.challengers = viewModel.challengers.filter { $0 != challenger }
            viewModel.challengersForManager.append(challenger)
        } else if challengerCount == 4 {
            challenger5 = challenger
            viewModel.challengers = viewModel.challengers.filter { $0 != challenger }
            viewModel.challengersForManager.append(challenger)
        } else if challengerCount == 5 {
            challenger6 = challenger
            viewModel.challengers = viewModel.challengers.filter { $0 != challenger }
            viewModel.challengersForManager.append(challenger)
        } else if challengerCount == 6 {
            challenger7 = challenger
            viewModel.challengers = viewModel.challengers.filter { $0 != challenger }
            viewModel.challengersForManager.append(challenger)
        } else if challengerCount == 7 {
            challenger8 = challenger
            viewModel.challengers = viewModel.challengers.filter { $0 != challenger }
            viewModel.challengersForManager.append(challenger)
        } else if challengerCount == 8 {
            challenger9 = challenger
            viewModel.challengers = viewModel.challengers.filter { $0 != challenger }
            viewModel.challengersForManager.append(challenger)
        } else if challengerCount == 9 {
            challenger9 = challenger
        }
        self.challengerCount += 1

    }
}

struct EnterChallengersView_Previews: PreviewProvider {
    static var previews: some View {
        EnterChallengersView(league: League.init(name: "Test League"), managers: ["Sevy@gmial.com", "Shamir@gmail.ocm", "BJ@gmail.com"], showModal: .constant(true))
    }
}

