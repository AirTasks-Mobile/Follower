//
//  AmountView.swift
//  Followers
//
//  Created by JEREMY NGUYEN on 05/01/2022.
//

import SwiftUI

struct AmountView: View {
    var text : String = "Amount"
    var amt : String = ""
    var isOut : Bool = false

    var outColor : Color = Color(.sRGBLinear, red: 189.0/255, green: 48.0/255, blue: 32.0/255, opacity: 0.7)
    var inColor : Color = Color(.sRGBLinear, red: 25.0/255, green: 158.0/255, blue: 50.0/255, opacity: 0.7)
    
    var outColor2 : Color = Color(.sRGBLinear, red: 189.0/255, green: 48.0/255, blue: 32.0/255, opacity: 0.9)
    var inColor2 : Color = Color(.sRGBLinear, red: 25.0/255, green: 158.0/255, blue: 50.0/255, opacity: 0.9)
    
    var body: some View {
        HStack(alignment: .center, spacing: 0){
            Text("\(text)  ")
                .font(Font.custom("Avenir-medium", size: 19))
                .foregroundColor( isOut ? outColor: inColor)

            Text("\(Utils.formatNumber(num: amt))")
                .font(Font.custom("Avenir-black", size: 19))
                .foregroundColor( isOut ? outColor2: inColor2)
        }
    }
}

struct AmountView_Previews: PreviewProvider {
    static var previews: some View {
        AmountView()
    }
}
