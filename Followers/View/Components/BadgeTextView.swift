//
//  BadgeTextView.swift
//  Followers
//
//  Created by JEREMY NGUYEN on 19/07/2021.
//

import SwiftUI

struct BadgeTextView: View {
    @Binding var text : String
    var name : String = "N/A"
    var primary : Bool = true
    
    var body: some View {
        //GeometryReader { geometry in
        VStack(alignment: .center, spacing: 0) {
                //Badge()
                if primary {
                    ZStack(alignment: .center){
                        BadgeBackground()
                        Text("\(text)")
                            .font(Font.custom("Avenir-black", size: 9))
                            .foregroundColor(.white)
                    }
                    .frame(width: 70, height: 70)
                }
                else {
                    HeaderBackground()
                        .frame(width: 70, height: 70)
                }
                Text(name)
                    .font(Font.custom("Avenir-medium", size: 15))
                    .foregroundColor(.white)
            }
        //}
    }
}

struct BadgeTextView_Previews: PreviewProvider {
    static var previews: some View {
        BadgeTextView(text: .constant(""))
    }
}
