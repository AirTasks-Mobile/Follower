//
//  CoinProfileTab.swift
//  Followers
//
//  Created by JEREMY NGUYEN on 04/01/2022.
//

import SwiftUI

struct CoinProfileTab: View {
    @Binding var listCoin : [CoinInfo]
    @Binding var selectedCoin : CoinInfo
    var onDelCoin : () -> Void
    
    @State var isRemove : Bool = false
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            if !isRemove {
            ForEach(listCoin, id: \.id) { coin in
                Button(action: {
                    onDeleteACoin(coin: coin)
                }){
                    CoinTag(oneCoin: coin, name: "delete.right")
                        .frame(height: 95)
                }
                //Spacer()
        
            }
            }
            
            if isRemove {
                Spacer()

                ZStack{
                    Color.white
                    VStack{
                        Text("Remove ?")
                            .font(.title)
                            .foregroundColor(.red)
                            .padding(EdgeInsets(top: 0, leading: 10, bottom: 10, trailing: 10))

                        Spacer()

                        Image(systemName: "questionmark")
                            .resizable()
                            .foregroundColor(.red)
                            .frame(width: 50, height: 50, alignment: .center)

                        Spacer()

                        HStack{
                            Button(action: {
                                self.isRemove = false
                                self.selectedCoin = CoinInfo.default
                            }, label: {

                                Text("Oh No")
                                    .font(.title)
                                    .padding()
                            })

                            Button(action: onRemoveCoin, label: {

                                Text("Sure")
                                    .font(.title)
                                    .padding()
                            })
                        }
                    }
                }
                .frame(width: 280, height: 280)
                .cornerRadius(20)
                .shadow(radius: 20)
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
            } // end isRemove

            Spacer()
        }
        .padding(EdgeInsets(top: 25, leading: 0, bottom: 0, trailing: 0))
    }
    func onRemoveCoin() -> Void {
        if isRemove {
            if let index = listCoin.firstIndex(where: {$0.id == selectedCoin.id}){
                listCoin.remove(at: index)
            }
            
            onDelCoin()
            isRemove = false
        }
    }
    
    func onDeleteACoin(coin : CoinInfo) -> Void {
        selectedCoin = coin
        isRemove = true
    }
}

struct CoinProfileTab_Previews: PreviewProvider {
    static var previews: some View {
        CoinProfileTab(listCoin: .constant([CoinInfo.default]), selectedCoin: .constant(CoinInfo.default),onDelCoin: { })
    }
}
