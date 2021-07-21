//
//  BagdeIcon.swift
//  Followers
//
//  Created by JEREMY NGUYEN on 21/07/2021.
//

import SwiftUI

struct BagdeIcon: View {
    var name : String = "tortoise"
    //tortoise
    // zzz
    var body: some View {
        ZStack{
            BadgeBackground()
            GeometryReader { geo in
                Image(systemName: name)
                    .resizable()
                    .foregroundColor(Color(red: 214.0/255, green: 171.0/255, blue: 141.0/255))
                    //.blur(radius: 4.0)
                    .frame(width: geo.size.width * 0.30, height: geo.size.height * 0.30, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    .position(x: geo.size.width * 0.50, y: geo.size.height * 0.50)
            }
        }
        .scaledToFit()
    }
}

struct BagdeIcon_Previews: PreviewProvider {
    static var previews: some View {
        BagdeIcon()
    }
}
