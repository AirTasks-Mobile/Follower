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
    @State var otherAsset : String = ""
    
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
                    
                    Text("           \(oneCoin.type) \(Utils.formatNumber(num: oneCoin.bal))")
                        .font(Font.custom("Avenir-medium", size: 15))
                        .foregroundColor(.white)
                    
                    if oneCoin.assets?.count ?? 0 > 0 {
                        Text("             \(otherAsset)")
                            .font(Font.custom("Avenir-medium", size: 10))
                            .foregroundColor(.gray)
                            .onAppear(perform: {
                                for asset in oneCoin.assets ?? [] {
                                    if otherAsset == "" {
                                        otherAsset += "\(asset.code) \(Utils.formatNumber(num: asset.balance ?? ""))"
                                    }
                                    else {
                                        otherAsset += " / \(asset.code) \(Utils.formatNumber(num: asset.balance ?? ""))"
                                    }
                                }
                            })
                    }
                        
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
}

struct CoinTag_Previews: PreviewProvider {
    static var previews: some View {
        CoinTag(oneCoin: CoinInfo.default)
    }
}
