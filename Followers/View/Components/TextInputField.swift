//
//  TextInputField.swift
//  Followers
//
//  Created by JEREMY NGUYEN on 02/01/2022.
//

import SwiftUI

struct TextInputField: View {
    var titleText : String = "Address"
    @Binding var inputText : String
    
    var paddingTop : EdgeInsets = EdgeInsets(top: 27.42, leading: 0, bottom: 0, trailing: 0)
    var onFocus : () -> Void
    var onLoseFocus : () -> Void
    
    @State private var borderColour : Color = Color(.sRGBLinear, red: 255/255.0, green: 255/255.0, blue: 255/255.0, opacity: 0.5)
    
    var body: some View {
        Text("\(titleText)")
            .frame(height: 23)
            .font(Font.custom("Avenir-medium", size: 17))
            .foregroundColor(.white)
            .padding(paddingTop)
        
        ZStack(alignment: .trailing){
            TextField("", text: $inputText, onEditingChanged: { focused in
                if focused {
                    onFocus()
                }
                else {
                    onLoseFocus()
                }
            })
                .frame(height: 50)
                .background(Color(red: 255/255.0, green: 255/255.0, blue: 255/255.0, opacity: 0.3))
                .cornerRadius(8.0)
                .overlay(
                    RoundedRectangle(cornerRadius: 8.0)
                        .stroke(borderColour, lineWidth: 1)
                        //.animation(Animation.easeOut(duration: 300))
                )
                .font(Font.custom("Avenir-medium", size: 17))
                .foregroundColor(Color.white)
            
            Button(action: { }) {
                Image(systemName: "qrcode.viewfinder")
                    .resizable()
                    .frame(width: 18, height: 18, alignment: .center)
                    .padding(EdgeInsets(top: 15.58, leading: 0, bottom: 16.42, trailing: 15))
                    //.animation(Animation.easeOut(duration: 300))
            }

        }
        .padding(EdgeInsets(top: 6.58, leading: 0, bottom: 0, trailing: 0))
        
    }
}

struct TextInputField_Previews: PreviewProvider {
    static var previews: some View {
        TextInputField(inputText: .constant(""), onFocus: { }, onLoseFocus: { })
    }
}
