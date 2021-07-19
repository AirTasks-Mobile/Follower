//
//  IconTextView.swift
//  Followers
//
//  Created by JEREMY NGUYEN on 19/07/2021.
//

import SwiftUI

struct IconTextView: View {
    var name : String = "N/A"
    var body: some View {
        VStack {
            Image("olive_01")
                .renderingMode(.original)
                .resizable()
                .frame(width: 70, height: 70, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                .cornerRadius(10)
            Text(name)
                .font(.footnote)
                .frame(height: 20)
        }
    }
}

struct IconTextView_Previews: PreviewProvider {
    static var previews: some View {
        IconTextView()
    }
}
