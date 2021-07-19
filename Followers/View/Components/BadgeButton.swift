//
//  BadgeButton.swift
//  Followers
//
//  Created by JEREMY NGUYEN on 19/07/2021.
//

import SwiftUI

struct BadgeButton: View {
    var name : String = "N/A"
    var action : () -> Void
    
    var body: some View {
        Button(action: action) {
            //GeometryReader { geometry in
                VStack {
                    //Badge()
                    BadgeBackground()
                        .frame(width: 70, height: 70)
                    Text(name)
                        .font(.footnote)
                        .frame(width: 70, height: 20)
                }
            //}
        }
    }
}

struct BadgeButton_Previews: PreviewProvider {
    static var previews: some View {
        BadgeButton(action: {
            print("Okey")
        })
    }
}
