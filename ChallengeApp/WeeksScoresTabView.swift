//
//  WeeksScoresTabView.swift
//  ChallengeApp
//
//  Created by Michael Sevy on 4/8/20.
//  Copyright © 2020 Michael Sevy. All rights reserved.
//

import SwiftUI
//struct ContentView : View {
//    // 1.
//    @State private var selection = 0
//    let colors = ["Red","Yellow","Green","Blue"]
//
//    var body: some View {
//        // 2.
//        Picker(selection: $selection, label:
//        Text("Picker Name")) {
//            ForEach(0 ..< colors.count) { index in
//                Text(self.colors[index]).tag(index)
//            }
//        }
//    }
//}
struct WeeksScoresTabView: View {
    var challengers = Challenger.generateChallengers()
    @State var selection = 2
    let weeks = ["2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16"]
    
    var body: some View {
        VStack {
            Picker(selection: $selection, label: Text("Week:")) {
                ForEach(0 ..< self.weeks.count) {
                    Text(self.weeks[$0])
                }
            }.padding()
                .pickerStyle(WheelPickerStyle())
                .frame(height: 100)
            Spacer()
//            Picker(selection: $selection, label:
//            Text("Week")) {
//                List(0 ..< weeks.count) { n in
//                    Text(self.weeks[n]).tag(n)
//                }
//            }
          //  Text("Week 1 ")
//            HStack {
//                List(1..<17) { n in
//                    Text("Week \(n)")
//                }
//            }
            List(challengers) { ch in
                ChallengerRow(challenger: ch, isPresented: true)
            }
        }
//            List(challengers) { ch in
//                ScrollView {
//                    VStack {
//                        Spacer()
//                        Text("\(ch.name.uppercased())")
//                            .bold()
//                            .foregroundColor(.red)
//                        Section {
//                            ChallengerRow(challengers: ch)
//                        }
//                    }
//                }.id(UUID().uuidString)
//            }
//        }
    }
}

struct WeeksScoresTabView_Previews: PreviewProvider {
    static var previews: some View {
        WeeksScoresTabView(challengers: Challenger.generateChallengers())
    }
}
