//
//  BadgeTextView.swift
//  Followers
//
//  Created by JEREMY NGUYEN on 19/07/2021.
//

import SwiftUI

struct BadgeTextView: View {
    var name : String = "N/A"
    var body: some View {
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

struct BadgeTextView_Previews: PreviewProvider {
    static var previews: some View {
        BadgeTextView()
    }
}
