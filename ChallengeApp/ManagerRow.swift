//
//  ManagerRow.swift
//  ChallengeApp
//
//  Created by Michael Sevy on 4/12/20.
//  Copyright © 2020 Michael Sevy. All rights reserved.
//

import SwiftUI

struct ManagerRow: View {
    var manager: Manager
    @State private var isPresented = false
    
    var body: some View {
        Button(action: {
            self.isPresented.toggle()
        }) {
            ScrollView() {
                List(manager.challengersFor(manager: manager.name)) { challenger in
                    HStack {
                        Image(challenger.name)
                        .renderingMode(Image.TemplateRenderingMode.original)
                            .resizable()
                            .frame(width: 35, height: 35, alignment: .leading)
                            .cornerRadius(35/2)
                Text(challenger.name)
                    .foregroundColor(.black)
                    .bold()
                    .font(.subheadline)
                Spacer()
                Text("Total: 161").font(.footnote)
                    .foregroundColor(.black)
                    .frame(width: 100, alignment: .topTrailing)
                    }
                }.frame(height: 190)
            .disabled(true)
                Text("Total: \(manager.score)")
                    .font(.system(size: 20))
                    .bold()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
            }
        }
    }
}

struct ManagerRow_Previews: PreviewProvider {
    static var previews: some View {
        ManagerRow(manager: Manager.generateRandomManager())
    }
}
