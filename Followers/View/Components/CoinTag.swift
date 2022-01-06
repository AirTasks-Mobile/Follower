//
//  CoinTag.swift
//  Followers
//
//  Created by JEREMY NGUYEN on 02/01/2022.
//

import SwiftUI

struct CoinTag: View {
    var oneCoin : CoinInfo
    var name : String = ""
    private let tagColor = Color(red: 184/255.0, green: 239/255.0, blue: 246/255.0, opacity: 0.3)
    //private let tagColor = Color(red: 255/255.0, green: 255/255.0, blue: 255/255.0, opacity: 0.3)
    
    var body: some View {
            ZStack(alignment: .leading){
                GeometryReader { geo in
                VStack(alignment: .leading, spacing: 0) {
                    Text("        \(oneCoin.nick)")
                        .font(Font.custom("Avenir-black", size: 17))
                        .foregroundColor(.white)
                    
                    Text("           \(oneCoin.id)")
                        .font(Font.custom("Avenir-medium", size: 15))
                        .foregroundColor(.white)
                    
                    Text("           \(oneCoin.type) \(formatNumber(num: oneCoin.bal))")
                        .font(Font.custom("Avenir-medium", size: 15))
                        .foregroundColor(.white)
                        
                    Spacer()
                }
                .frame(width: geo.size.width - 70,height: geo.size.height - 10)
                .background(RoundCornerView(color: tagColor, tl: 0, tr: 22, bl: 0, br: 22))
                .padding(EdgeInsets(top: 5, leading: 60, bottom: 5, trailing: 0))
                    
                CircleButton(name: name)
                        .frame(width: geo.size.height, height: geo.size.height, alignment: .center)
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
            }
            } // end Z
            //.frame(height: 90)
            .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
        
    }
    
    func formatNumber(num : String) -> String {
        if num == "" {
            return num 
        }
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
                //formatter.usesSignificantDigits = true
                //formatter.minimumSignificantDigits = 1 // default
                //formatter.maximumSignificantDigits = 6 // default
        let value = NSDecimalNumber(string: num)
    
        let numString = formatter.string(for: value) ?? ""
        
        return numString
    }
}

struct CoinTag_Previews: PreviewProvider {
    static var previews: some View {
        CoinTag(oneCoin: CoinInfo.default)
    }
}
