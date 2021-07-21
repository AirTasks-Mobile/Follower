//
//  HeaderView.swift
//  Followers
//
//  Created by JEREMY NGUYEN on 19/07/2021.
//

import SwiftUI

struct HeaderView: View {

    var body: some View {
        GeometryReader { geometry in
            ZStack{
                HeaderSymbol()
                    .frame(width: geometry.size.height / 3, height: geometry.size.height / 3)
                    .position(x: geometry.size.width * 0.10, y: geometry.size.height * 0.10)
                
                HeaderSymbol()
                    .frame(width: geometry.size.height / 3, height: geometry.size.height / 3)
                    .position(x: geometry.size.width * 0.25, y: geometry.size.height * 0.60)
                
                HeaderSymbol()
                    .frame(width: geometry.size.height / 5, height: geometry.size.height / 5)
                    .position(x: geometry.size.width * 0.55, y: geometry.size.height * 0.30)
                
                HeaderSymbol()
                    .frame(width: geometry.size.height / 5, height: geometry.size.height / 5)
                    .position(x: geometry.size.width * 0.35, y: geometry.size.height * 0.70)
                
                HeaderSymbol()
                    .frame(width: geometry.size.height / 5, height: geometry.size.height / 5)
                    .position(x: geometry.size.width * 0.45, y: geometry.size.height * 0.80)
                
                HeaderSymbol()
                    .frame(width: geometry.size.height / 6, height: geometry.size.height / 6)
                    .position(x: geometry.size.width * 0.75, y: geometry.size.height * 0.60)
                
                HeaderSymbol()
                    .frame(width: geometry.size.height / 7, height: geometry.size.height / 7)
                    .position(x: geometry.size.width * 0.90, y: geometry.size.height * 0.90)
                
                HeaderSymbol()
                    .frame(width: geometry.size.height / 8, height: geometry.size.height / 8)
                    .position(x: geometry.size.width * 0.98, y: geometry.size.height * 0.98)
            }
        }
    }
}

struct HeaderView_Previews: PreviewProvider {
    static var previews: some View {
        HeaderView()
    }
}
