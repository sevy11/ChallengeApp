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
    
    var body: some View {
        VStack {
            Spacer()
            Text("Chicago Challenge League").bold()
                .foregroundColor(.red)
                .font(.title)
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
        }
    }
}

//struct FlightBoard: View {
//    var boardName: String
//    var flightData: [FlightInformation]
//
//    var body: some View {
//        VStack {
//            Text(boardName).font(.title)
//            ForEach(flightData, id: \.id) { fl in
//                Text("\(fl.airline) \(fl.number)")
//            }
//        }
//    }
//}

struct ManagerTabView_Previews: PreviewProvider {
    static var previews: some View {
        ManagerTabView(managers: Manager.chicagoManagers())
    }
}
