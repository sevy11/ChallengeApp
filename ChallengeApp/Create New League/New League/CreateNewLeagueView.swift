//
//  CreateNewLeagueView.swift
//  ChallengeApp
//
//  Created by Michael Sevy on 5/8/20.
//  Copyright © 2020 Michael Sevy. All rights reserved.
//

import SwiftUI
import Firebase

struct CreateNewLeagueView: View {
    var user: User?

    @State private var name = ""
    @State private var leagueType = Show.none.rawValue
    @State private var managersInLeague = 0
    @State private var buttonTapped: Int? = nil
    @State var selected = false
    @State var showNameAlert = false
    @ObservedObject var viewModel = CreateNewLeagueViewModel()
    
    
    var body: some View {
            Section {
                VStack {
                    List {
                        Text(selected ? "\(leagueType.uppercased())" : leagueType)
                            .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 0))
                        if selected == false {
                            Button(action: {
                                self.leagueType = Show.challenge.rawValue
                                self.selected = true
                            }) {
                                Text(Show.challenge.rawValue)
                            }
                            Button(action: {
                                self.leagueType = Show.challenge.rawValue
//                                self.leagueType = "Survivor"
                                self.selected = true
                            }) {
                                Text("Survivor(Coming soon!)")
                            }
                        } else {
                            EmptyView()
                        }
                        Text("League Name:")
                            .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 0))
                        TextField("Type your league name...", text: $name)
                            .padding(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(lineWidth: 2)
                                    .foregroundColor(.black)
                            )
                            .shadow(color: Color.gray.opacity(0.4), radius: 3, x: 1, y: 2)
                        Text("Enter Managers in league (3-8):")
                            .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 0))
                      Picker(selection: $managersInLeague, label: Text("")) {
                            ForEach(0 ..< Manager.managersAvailable.count) { index in
                                Text(Manager.managersAvailable[index]).tag(index)
                            }
                        }.id(managersInLeague)
                            .pickerStyle(WheelPickerStyle())
                            .padding(EdgeInsets(top: -20, leading: 0, bottom: -20, trailing: 0))
                        HStack(alignment: .center) {
                            Spacer()
                            Text("Manager Count: \(Manager.managersAvailable[managersInLeague])")
                            Spacer()
                        }
                        HStack(alignment: .center) {
                            Spacer()
                            Text("Leagues will begin scoring with week 2")
                            Spacer()
                        }
                    }
                    NavigationLink(destination: CreateNewLeagueDetailManagerView(leagueName: self.name, managerCount: self.managersInLeague + 3, user: user!), tag: 1, selection: $buttonTapped) {
                        Button(action: {
                            self.allowButtonTap()
                        }) {
                            Text("Enter Manager Names").bold()
                        }
                    }
                    .alert(isPresented: $showNameAlert) {
                        Alert(title: Text("Alert"), message: Text("Team name already in use, please try another"))
                    }
                    .padding(20)
                    .background(buttonColor)
                    .foregroundColor(buttonTitleColor)
                    .cornerRadius(40)
                    .disabled(!allowedToEnterTeams)
                    .disableAutocorrection(true)
                    Spacer()
                }.onAppear(perform: getAllLeagueNames)
            }
        .navigationBarTitle("Create New League")
    }

    func getAllLeagueNames() {
        viewModel.getLeagueNames()
    }
    
    func allowButtonTap() {
        if viewModel.leagueNameExists(name: self.name) {
            self.showNameAlert = true
            self.buttonTapped = 0
        } else {
            self.buttonTapped = 1
        }
    }
    
    var leagueTypeEntered: String {
        return leagueType == Show.none.rawValue ? leagueType : Show.none.rawValue
    }
    
    var leagueShow: Bool {
        return leagueType == Show.none.rawValue ? true : false
    }
    
    var allowedToEnterTeams: Bool {
        return !name.isEmpty && selected
    }
    
    var buttonColor: LinearGradient {
           return allowedToEnterTeams ? LinearGradient(gradient: Gradient(colors: [.gray, .babyBlue]), startPoint: .leading, endPoint: .trailing) : LinearGradient(gradient: Gradient(colors: [.red, .babyBlue]), startPoint: .leading, endPoint: .trailing)
    }
    
    var buttonTitleColor: Color {
        return allowedToEnterTeams ? .black : .white
    }
}

struct CreateNewLeagueView_Previews: PreviewProvider {
    static var previews: some View {
        CreateNewLeagueView()
    }
}
