//
//  HeaderSymbol.swift
//  Followers
//
//  Created by JEREMY NGUYEN on 19/07/2021.
//

import SwiftUI

struct HeaderSymbol: View {
    static let rotationCount = 8
    
    var headerSymbols: some View {
        ForEach(0..<HeaderSymbol.rotationCount){
            i in
                RotatedBadgeSymbol(
                    angle: .degrees(Double(i) / Double(HeaderSymbol.rotationCount)) * 360)
        }
        .opacity(0.5)
    }
    
    var body: some View {
        ZStack{
            HeaderBackground()
//            GeometryReader { geometry in
//                headerSymbols
//                    .scaleEffect(1.0 / 4.0, anchor: .top)
//                    .position(x: geometry.size.width / 2.0, y: (3.0 / 4.0) * geometry.size.height)
//            }
        }
        .scaledToFit()
    }
}

struct HeaderSymbol_Previews: PreviewProvider {
    static var previews: some View {
        HeaderSymbol()
    }
}
