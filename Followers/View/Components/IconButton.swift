//
//  IconButton.swift
//  Followers
//
//  Created by JEREMY NGUYEN on 19/07/2021.
//

import SwiftUI

struct IconButton: View {
    var name : String = "N/A"
    var action : () -> Void
    
    var body: some View {
        Button(action: action){
            VStack {
                Image("olive_01")
                    .resizable()
                    .frame(width: 70, height: 70, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    .cornerRadius(10)
                Text(name)
                    .font(.footnote)
                    .frame(height: 20)
            }
        }
    }
}

struct IconButton_Previews: PreviewProvider {
    static var previews: some View {
        IconButton(action: {
            print("Okey")
        })
    }
}
