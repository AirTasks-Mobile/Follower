//
//  CircleButton.swift
//  Followers
//
//  Created by JEREMY NGUYEN on 02/01/2022.
//

import SwiftUI

struct CircleButton: View {
    var name = "bitcoinsign.circle"
    
    var body: some View {
        GeometryReader { geo in
            VStack(alignment: .leading, spacing: 0){
                if name != "" && (name == "bitcoinsign.circle" || name == "dollarsign.circle" || name == "rectangle.stack.fill.badge.plus" || name == "delete.right" || name == "o.circle"
                                  || name == "s.circle" || name == "m.circle" || name == "x.circle"
                                  || name == "b.circle" || name == "e.circle") {
                    Image(systemName: name)
                        .resizable()
                        .frame(width: geo.size.height , height: geo.size.height, alignment: .center)
                        .background(Color(red: 255.0/255, green: 255.0/255, blue: 255.0/255, opacity: 0.9))
                        .foregroundColor(Color(red: 255.0/255, green: 215.0/255, blue: 0.0/255, opacity: 0.5))
                    }
                else {
                    Image(name)
                        .resizable()
                        .frame(width: geo.size.height , height: geo.size.height, alignment: .center)
                        .background(Color(red: 255.0/255, green: 255.0/255, blue: 255.0/255, opacity: 0.9))
                        .foregroundColor(Color(red: 255.0/255, green: 215.0/255, blue: 0.0/255, opacity: 0.5))
                }
                
                }
                .frame(width: geo.size.height, height: geo.size.height, alignment: .center)
                .clipShape(Circle())
                //.overlay(Circle().stroke(Color.white, lineWidth: 4))
                //.overlay(Circle().stroke(Color.white))
                //.shadow(radius: 7)

        }
    }
}

struct CircleButton_Previews: PreviewProvider {
    static var previews: some View {
        CircleButton()
    }
}
