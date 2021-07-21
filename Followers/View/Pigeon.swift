//
//  Pigeon.swift
//  Followers
//
//  Created by JEREMY NGUYEN on 29/04/2021.
//

import SwiftUI

struct Pigeon: View {
    var goBack : () -> Void
    var body: some View {
        BackButton(action: goBack)
        Text("Pigeon")
    }
}

struct Pigeon_Previews: PreviewProvider {
    static var previews: some View {
        Pigeon(goBack: {
            print("back")
        })
    }
}
