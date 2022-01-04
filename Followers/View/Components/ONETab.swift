//
//  ONETab.swift
//  Followers
//
//  Created by JEREMY NGUYEN on 02/01/2022.
//

import SwiftUI

struct ONETab<T : HomeViewModelProtocol>: View {
    @EnvironmentObject var homeVM : T
    var goBack : () -> Void
    
    private let startColour : Color  = Color(red : 105.0/255, green: 250.0/255, blue: 189.0/255)
    //private let centerColour : Color  = Color(red : 3.0/255, green: 225.0/255, blue: 255.0/255)
    private let endColour : Color = Color(red : 0.0/255, green: 174.0/255, blue: 233.0/255)
    
    @State private var tabSelect = 2
    @State var oneAddress : String = ""
    @State var oneNickname : String = ""
    @State var selectedOne : CoinInfo = CoinInfo.default
    @State var isWeb : Bool = false
    
    var body: some View {
        GeometryReader { geo in
            VStack(alignment: .leading, spacing: 0) {
                ZStack{
                    HeaderView()
                    BackButton(action: OneGoBack)
                }
                .frame(width: geo.size.width * 0.90, height: geo.size.height * 0.05)
                .padding(EdgeInsets(top: 35, leading: 0, bottom: 0, trailing: 0))
                
                TabView(selection: $tabSelect) {
                    CoinProfileTab(listCoin: $homeVM.oneCoins, selectedCoin: $selectedOne, onDelCoin: onRevomveOne)
                        .tag(0)
                    
                    StatisticView(isActive: $isWeb,type: GTEXT.HARMONY, onGoBack: OneGoBack)
                        .tag(1)
                    
                    ListCoinTab(listCoin: $homeVM.oneCoins, selectedCoin: $selectedOne ,onAddCoin: onClick, onDetail: getTransactions)
                        .tag(2)
                    
                    AddCoinTab(titleText: "Harmony One Address Only", coinAddress: $oneAddress, nickName: $oneNickname, onAddCoin: onClick)
                        .tag(3)
                    
                    ListTransactionTab(nick: $selectedOne.nick, id: $selectedOne.id, transactions: $homeVM.oneTransactions, isStake: true, onStake: {
                        homeVM.oneTransactions = []
                        homeVM.getOneStake(id: selectedOne.id)
                    })
                        .tag(4)
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .animation(.easeInOut)
                .transition(.slide)
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 15, trailing: 0))
                
                Spacer()
                
            }
            .onAppear(perform: {
                homeVM.startOne()
            })
            .onChange(of: homeVM.oneAddressList, perform: { _ in
                homeVM.startOne()
            })
            .onChange(of: tabSelect, perform: { _ in
                if tabSelect == 1 {
                    isWeb = true
                }
                else if isWeb == true
                {
                    isWeb = false
                }
            })
            .padding(EdgeInsets(top: 0, leading: 28, bottom: 15, trailing: 26))
            .background(LinearGradient(gradient: Gradient(colors: [startColour, endColour]), startPoint: .topTrailing, endPoint: .bottomLeading))
            .edgesIgnoringSafeArea(.all)
        }
    }
    
    func OneGoBack() -> Void {
        if tabSelect == 2 {
            goBack()
        }
        else {
            tabSelect = 2
        }
    }
    
    func onClick() -> Void {
        if tabSelect == 2 {
            tabSelect = 3
        }
        else if tabSelect == 3 {
            homeVM.storeOne(id: oneAddress, nick: oneNickname)
            oneAddress = ""
            oneNickname = ""
            tabSelect = 2
        }
    }
    
    func getTransactions() -> Void {
        homeVM.getOneTxn(id: selectedOne.id)
        tabSelect = 4
    }
    
    func onRevomveOne() -> Void {
        var oneList = UserDefaults.standard.stringArray(forKey: GTEXT.ONE_LIST) ?? []
        if oneList.count > 0 {
            let id = GTEXT.HARMONY + "_" + selectedOne.id
            oneList = oneList.filter(){$0 != id}
            UserDefaults.standard.set(oneList, forKey: GTEXT.ONE_LIST)
        }
    }
}

struct ONETab_Previews: PreviewProvider {
    static var previews: some View {
        ONETab<HomeVMUnitTest>(goBack: { })
            .environmentObject(HomeVMUnitTest(isOnline: true))
    }
}
