//
//  CreateNewLeagueDetailManagerView.swift
//  ChallengeApp
//
//  Created by Michael Sevy on 5/10/20.
//  Copyright © 2020 Michael Sevy. All rights reserved.
//

import SwiftUI
import Firebase

struct CreateNewLeagueDetailManagerView: View {
    var leagueName: String
    var managerCount: Int
    var user: User?

    @State var manager1: String = ""
    @State var manager2: String = ""
    @State var manager3: String = ""
    @State var manager4: String = ""
    @State var manager5: String = ""
    @State var manager6: String = ""
    @State var manager7: String = ""
    @State var manager8: String = ""
    @State var managerNames = [String]()
    @State var buttonTapped: Int? = nil
    @State var showInvalidEmailAddressAlert = false

    @ObservedObject var viewModel = CreateNewLeagueEmailsViewModel()
    
    
    var body: some View {
        VStack {
         if managerCount == 3 {
                VStack {
                    HStack {
                        Text("1.")
                        TextField("Enter email for manager", text: $manager1).modifier(TextFieldModifer())
                    }
                    HStack {
                        Text("2.")
                        TextField("Enter email for manager", text: $manager2).modifier(TextFieldModifer())
                    }
                    HStack {
                        Text("3.")
                        TextField("Enter email for manager", text: $manager3).modifier(TextFieldModifer())
                    }
                }.padding()
            } else if managerCount == 4 {
                VStack {
                    HStack {
                        Text("1.")
                        TextField("Enter email for manager", text: $manager1).modifier(TextFieldModifer())
                    }
                    HStack {
                        Text("2.")
                        TextField("Enter email for manager", text: $manager2).modifier(TextFieldModifer())
                    }
                    HStack {
                        Text("3.")
                        TextField("Enter email for manager", text: $manager3).modifier(TextFieldModifer())
                    }
                    HStack {
                        Text("4.")
                        TextField("Enter email for manager", text: $manager4).modifier(TextFieldModifer())
                    }
                }.padding()
            } else if managerCount == 5 {
                VStack {
                    HStack {
                        Text("1.")
                        TextField("Enter email for manager", text: $manager1).modifier(TextFieldModifer())
                    }
                    HStack {
                        Text("2.")
                        TextField("Enter email for manager", text: $manager2).modifier(TextFieldModifer())
                    }
                    HStack {
                        Text("3.")
                        TextField("Enter email for manager", text: $manager3).modifier(TextFieldModifer())
                    }
                    HStack {
                        Text("4.")
                        TextField("Enter email for manager", text: $manager4).modifier(TextFieldModifer())
                    }
                    HStack {
                        Text("5.")
                        TextField("Enter email for manager", text: $manager5).modifier(TextFieldModifer())
                    }
                }.padding()
            } else if managerCount == 6 {
                VStack {
                    HStack {
                        Text("1.")
                        TextField("Enter email for manager", text: $manager1).modifier(TextFieldModifer())
                    }
                    HStack {
                        Text("2.")
                        TextField("Enter email for manager", text: $manager2).modifier(TextFieldModifer())
                    }
                    HStack {
                        Text("3.")
                        TextField("Enter email for manager", text: $manager3).modifier(TextFieldModifer())
                    }
                    HStack {
                        Text("4.")
                        TextField("Enter email for manager", text: $manager4).modifier(TextFieldModifer())
                    }
                    HStack {
                        Text("5.")
                        TextField("Enter email for manager", text: $manager5).modifier(TextFieldModifer())
                    }
                    HStack {
                        Text("6.")
                        TextField("Enter email for manager", text: $manager6).modifier(TextFieldModifer())
                    }
                }.padding()
            } else if managerCount == 7 {
                VStack {
                    HStack {
                        Text("1.")
                        TextField("Enter email for manager", text: $manager1).modifier(TextFieldModifer())
                    }
                    HStack {
                        Text("2.")
                        TextField("Enter email for manager", text: $manager2).modifier(TextFieldModifer())
                    }
                    HStack {
                        Text("3.")
                        TextField("Enter email for manager", text: $manager3).modifier(TextFieldModifer())
                    }
                    HStack {
                        Text("4.")
                        TextField("Enter email for manager", text: $manager4).modifier(TextFieldModifer())
                    }
                    HStack {
                        Text("5.")
                        TextField("Enter email for manager", text: $manager5).modifier(TextFieldModifer())
                    }
                    HStack {
                        Text("6.")
                        TextField("Enter email for manager", text: $manager6).modifier(TextFieldModifer())
                    }
                    HStack {
                        Text("7.")
                        TextField("Enter email for manager", text: $manager7).modifier(TextFieldModifer())
                    }
                    Text("8.")
                    TextField("Enter email for manager", text: $manager8).modifier(TextFieldModifer())
                }.padding()
            }
            NavigationLink(destination: EnterChallengersView(leagueName: leagueName, managers: self.managerNames, user: user!), tag: 1, selection: $buttonTapped) {
                Button(action: {
                    self.saveLeague()
                }) {
                    if viewModel.savingLeagueInProgress {
                        ZStack {
                            Text("Save League").hidden()
                            ActivityIndicator(isAnimating: .constant(true), style: .large)
                        }
                    } else {
                        ZStack {
                            Text("Save League")
                            ActivityIndicator(isAnimating: .constant(false), style: .large).hidden()
                        }
                    }
                }
            }
            .alert(isPresented: $showInvalidEmailAddressAlert) {
                Alert(title: Text("Alert"), message: Text("One or more of the email addresses entered is invalid"))
            }
            .padding(20)
            .background(buttonColor)
            .foregroundColor(buttonTitleColor)
            .cornerRadius(40)
            .disabled(!allowedToCreateLeague)
            Spacer()
        }
        .navigationBarTitle("Add Managers")
    }
    
    var buttonColor: LinearGradient {
        return allowedToCreateLeague ? LinearGradient(gradient: Gradient(colors: [.gray, .babyBlue]), startPoint: .leading, endPoint: .trailing) : LinearGradient(gradient: Gradient(colors: [.red, .babyBlue]), startPoint: .leading, endPoint: .trailing)
    }
    
    var buttonTitleColor: Color {
        return allowedToCreateLeague ? .black : .white
    }
    
    var allowedToCreateLeague: Bool {
        switch managerCount {
        case 3:
            return manager1.count > 0 && manager2.count > 0 && manager3.count > 0
        case 4:
            return manager1.count > 0 && manager2.count > 0 && manager3.count > 0 && manager4.count > 0
        case 5:
            return manager1.count > 0 && manager2.count > 0 && manager3.count > 0 && manager4.count > 0 && manager5.count > 0
        case 6:
            return manager1.count > 0 && manager2.count > 0 && manager3.count > 0 && manager4.count > 0 && manager5.count > 0 && manager6.count > 0
        case 7:
            return manager1.count > 0 && manager2.count > 0 && manager3.count > 0 && manager4.count > 0 && manager5.count > 0 && manager6.count > 0 && manager7.count > 0
        case 8:
            return manager1.count > 0 && manager2.count > 0 && manager3.count > 0 && manager4.count > 0 && manager5.count > 0 && manager6.count > 0 && manager7.count > 0 && manager8.count > 0
        default:
            return false
        }
    }
    
    func saveLeague() {
        switch managerCount {
        case 3:
            managerNames = [self.manager1, self.manager2, self.manager3]
        case 4:
            managerNames = [self.manager1, self.manager2, self.manager3, self.manager4]
        case 5:
            managerNames = [self.manager1, self.manager2, self.manager3, self.manager4, self.manager5]
        case 6:
            managerNames = [self.manager1, self.manager2, self.manager3, self.manager4, self.manager5, self.manager6]
        case 7:
            managerNames = [self.manager1, self.manager2, self.manager3, self.manager4, self.manager5, self.manager6, self.manager7]
        case 8:
            managerNames = [self.manager1, self.manager2, self.manager3, self.manager4, self.manager5, self.manager6, self.manager7, self.manager8]
        default:
            print("no manager count or less than 2")
        }
        if viewModel.areValidEmailAddresses(emails: self.managerNames) {
            self.buttonTapped = 1
            viewModel.savingLeagueInProgress = true
            self.showInvalidEmailAddressAlert = false
            viewModel.createLeague(name: self.leagueName, emails: self.managerNames, user: user!)
        } else {
            self.buttonTapped = 0
            self.showInvalidEmailAddressAlert = true
        }
    }
    
    
}

struct CreateNewLeagueDetailManagerView_Previews: PreviewProvider {
    static var previews: some View {
        CreateNewLeagueDetailManagerView(leagueName: "Chicago Old School League", managerCount: 4)
    }
}
