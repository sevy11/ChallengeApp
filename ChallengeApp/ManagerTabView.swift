//
//  ChallengeTabViews.swift
//  ChallengeApp
//
//  Created by Michael Sevy on 4/7/20.
//  Copyright © 2020 Michael Sevy. All rights reserved.
//

import SwiftUI

struct ManagerTabView: View {
    var managers = Manager.chicagoManagers()
    @ObservedObject var observed = WebScrapManager()
    
    var body: some View {
        VStack {
            Spacer()
            Text("Chicago Challenge League").bold()
                .foregroundColor(.orange)
                .font(Font.system(size: 25))
            Text("Totals thru week: \(observed.currentAvailableWeek)")
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
    
    func getCurrentWeek() {
        observed.getCurrentWeek()
    }
}

struct ManagerTabView_Previews: PreviewProvider {
    static var previews: some View {
        ManagerTabView(managers: Manager.chicagoManagers())
    }
}
