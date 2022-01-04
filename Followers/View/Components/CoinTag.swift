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
        GeometryReader { geo in
            ZStack(alignment: .leading){
                VStack(alignment: .leading) {
                    Text("         \(oneCoin.nick)")
                        .font(Font.custom("Avenir-black", size: 17))
                        .foregroundColor(.white)
                    
                    Text("           \(oneCoin.id)")
                        .font(Font.custom("Avenir-medium", size: 15))
                        .foregroundColor(.white)
                    
                    Text("           \(oneCoin.type) \(oneCoin.bal)")
                        .font(Font.custom("Avenir-medium", size: 15))
                        .foregroundColor(.white)
                        
                    Spacer()
                }
                //.frame(height: 60, alignment: .leading)
                .frame(width: geo.size.width - 70,height: 80, alignment: .leading)
                .background(RoundCornerView(color: tagColor, tl: 0, tr: 22, bl: 0, br: 22))
                .padding(EdgeInsets(top: 10, leading: 60, bottom: 10, trailing: 0))
                //.position(x: geo.size.width * 0.50, y: geo.size.height * 0.50)
                    
                CircleButton(name: name)
                    .frame(width: 90, height: 90, alignment: .center)
                    //.position(x: geo.size.width * 0.17, y: geo.size.height * 0.50)
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))

            }
            //.frame(height: 90)
            .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
        }
    }
}

struct CoinTag_Previews: PreviewProvider {
    static var previews: some View {
        CoinTag(oneCoin: CoinInfo.default)
    }
}
