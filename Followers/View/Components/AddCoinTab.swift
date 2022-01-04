//
//  AddCoinTab.swift
//  Followers
//
//  Created by JEREMY NGUYEN on 03/01/2022.
//

import SwiftUI

struct AddCoinTab: View {
    var titleText : String = ""
    @Binding var coinAddress : String
    @Binding var nickName : String
    var onAddCoin : () -> Void
    
    var body: some View {
        GeometryReader { geo in
            VStack(alignment: .leading, spacing: 0 ) {
                if titleText != "" {
                    Text("\(titleText)")
                        .font(Font.custom("Avenir-black", size: 19))
                        .foregroundColor(.white)
                        .padding(EdgeInsets(top: 0, leading: 27, bottom: 0, trailing: 27))
                }
                
                TextInputField(titleText: "Address " ,inputText: $coinAddress, onFocus: { }, onLoseFocus: { })
                
                TextInputField(titleText: "Nickname " ,inputText: $nickName, onFocus: { }, onLoseFocus: { })
                
                Button(action: onAddCoin){
                    Text("Add")
                        .font(Font.custom("Avenir-heavy", size: 17))
                        .foregroundColor(Color(red: 1/255.0, green: 187/255.0, blue: 205/255.0))
                }
                .frame(width: geo.size.width - 20, height: 50, alignment: .center)
                .background(Color(red: 255/0/255, green: 255.0/255, blue: 255.0/255, opacity: 0.5))
                .cornerRadius(8.0)
                .padding(EdgeInsets(top: 50, leading: 10, bottom: 0, trailing: 10))
            }
            .padding(EdgeInsets(top: 20, leading: 0, bottom: 0, trailing: 0))
        }
    }
}

struct AddCoinTab_Previews: PreviewProvider {
    static var previews: some View {
        AddCoinTab(coinAddress: .constant(""), nickName: .constant(""), onAddCoin: { })
    }
}
