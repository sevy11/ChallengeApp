//
//  NoLeagueView.swift
//  ChallengeApp
//
//  Created by Michael Sevy on 5/31/20.
//  Copyright © 2020 Michael Sevy. All rights reserved.
//

import SwiftUI

struct NoLeagueView: View {
    var body: some View {
        VStack {
            Spacer()
             Text("There are no leagues associated with this email address.")
            .lineLimit(nil)
            .multilineTextAlignment(.center)
            .navigationBarTitle("No Leagues 😥")
            Spacer()
        }
    }
}
