//
//  BackButton.swift
//  Followers
//
//  Created by JEREMY NGUYEN on 21/07/2021.
//

import SwiftUI

struct BackButton: View {
    var action : () -> Void
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                Button(action: action, label: {
                    HStack{
                        //arrow.turn.down.left
                        // chevron.left
                        Image(systemName: "chevron.left")
                            .resizable()
                            .frame(width: 20, height: 35, alignment: .leading)
 
                        Text("Back")
                            .font(.system(size: 25, weight: .light))
                            .foregroundColor(.blue)
                    }
                    .position(x: geo.size.width * 0.12, y: geo.size.height * 0.35)
                })
            }
        }
    }
}

struct BackButton_Previews: PreviewProvider {
    static var previews: some View {
        BackButton(action: {
            print("Back")
        })
    }
}
