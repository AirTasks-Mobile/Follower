//
//  ListCoinTab.swift
//  Followers
//
//  Created by JEREMY NGUYEN on 03/01/2022.
//

import SwiftUI

struct ListCoinTab: View {
    @Binding var listCoin : [CoinInfo]
    @Binding var selectedCoin : CoinInfo
    @Binding var isLoading : Bool
    var onAddCoin : () -> Void
    var onDetail : () -> Void
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            if isLoading {
                ActivityIndicator()
                    .frame(width: 50, height: 50)
                    .foregroundColor(Color(red: 239.0 / 255, green: 172.0 / 255, blue: 120.0 / 255, opacity: 0.9))
            }
            ForEach(listCoin, id: \.id) { sol in
                Button(action: {
                    onClickDetail(sol: sol)
                }){
                    CoinTag(oneCoin: sol, name: "dollarsign.circle")
                        .frame(height: 90)
                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 5, trailing: 0))
                }
                //Spacer()
            }
            
            Button(action: onAddCoin ){
            CoinTag(oneCoin: CoinInfo(type: "", id: "Click To Add New Coin !", nick: "", pic: "", bal: "", date: ""), name: "rectangle.stack.fill.badge.plus")
                .frame(height: 95)
            }
        }
        .padding(EdgeInsets(top: 25, leading: 0, bottom: 0, trailing: 0))
    }
    
    func onClickDetail(sol : CoinInfo) -> Void {
        //print("click = \(sol.nick)")
        selectedCoin = sol
        onDetail()
    }
}

struct ListCoinTab_Previews: PreviewProvider {
    static var previews: some View {
        ListCoinTab(listCoin: .constant([CoinInfo.default]), selectedCoin: .constant(CoinInfo.default), isLoading: .constant(true),onAddCoin: { }, onDetail: { })
    }
}
