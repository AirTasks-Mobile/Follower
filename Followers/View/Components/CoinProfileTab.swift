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
    var dialogColor = Color(.sRGBLinear, red: 255.0/255, green: 255.0/255, blue: 255.0/255, opacity: 0.3)
    
    var body: some View {
        //List {
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
            //.onDelete(perform: swipeRemove)
            } // end isRemove
            
            if isRemove {
                Spacer()

                ZStack{
                    dialogColor
                    VStack{
                        Text("Remove \(selectedCoin.nick) ?")
                            .font(Font.custom("Avenir-black", size: 25))
                            .foregroundColor(.gray)
                            .padding(EdgeInsets(top: 15, leading: 10, bottom: 10, trailing: 10))

                        Spacer()

                        Image(systemName: "questionmark")
                            .resizable()
                            .foregroundColor(.red)
                            .frame(width: 50, height: 50, alignment: .center)

                        Spacer()

                        HStack{
                            Spacer()
                            Button(action: {
                                self.isRemove = false
                                self.selectedCoin = CoinInfo.default
                            }, label: {

                                Text("Oh No")
                                    .font(Font.custom("Avenir-medium", size: 20))
                                    .frame(height: 50)
                                    .padding(EdgeInsets(top: 5, leading: 15, bottom: 5, trailing: 15))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 8.0)
                                            .stroke(Color.gray, lineWidth: 1)
                                    )
                                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 5, trailing: 0))
                                    
                            })
                            Spacer()
                            Button(action: onRemoveCoin, label: {

                                Text("Sure!")
                                    .font(Font.custom("Avenir-medium", size: 20))
                                    .frame(height: 50)
                                    .padding(EdgeInsets(top: 5, leading: 15, bottom: 5, trailing: 15))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 8.0)
                                            .stroke(Color.gray, lineWidth: 1)
                                    )
                                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 5, trailing: 0))
                                    
                            })
                            Spacer()
                        }
                    }
                }
                .frame(width: 280, height: 280)
                .cornerRadius(20)
                //.shadow(radius: 20)
                .padding(EdgeInsets(top: 100, leading: 0, bottom: 0, trailing: 0))
            } // end isRemove

            Spacer()
        } // end scroll
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
    
    func swipeRemove(at offsets: IndexSet){
        print("offset = \(offsets)")
    }
}

struct CoinProfileTab_Previews: PreviewProvider {
    static var previews: some View {
        CoinProfileTab(listCoin: .constant([CoinInfo.default]), selectedCoin: .constant(CoinInfo.default),onDelCoin: { })
    }
}
