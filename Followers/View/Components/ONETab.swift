//
//  ONETab.swift
//  Followers
//
//  Created by JEREMY NGUYEN on 02/01/2022.
//

import SwiftUI
import CodeScanner

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
    
    @State private var isShowingScanner = false
    @State private var isScanningAddress = false
    @State var isLoading = true
    @State var oneLoading = false
    @State var isStakeTab : Bool = false
    @State var isLast : Bool = true
    
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
                    
                    ListCoinTab(listCoin: $homeVM.oneCoins, selectedCoin: $selectedOne, isLoading: $isLoading,onAddCoin: onClick, onDetail: getTransactions)
                        .tag(2)
                    
                    AddCoinTab(titleText: "Harmony One Address Only", coinAddress: $oneAddress, nickName: $oneNickname, onAddCoin: onClick, onScanAddress: scanAddress, onScanNick: scanNick)
                        .tag(3)
                    
                    ListTransactionTab(nick: $selectedOne.nick, id: $selectedOne.id, transactions: $homeVM.oneTransactions, isLoading: $oneLoading, stake: $isStakeTab, isLast: $isLast,isStake: true, onStake: onOneStake, loadMore: { })
                        .tag(4)
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .animation(.easeInOut)
                .transition(.slide)
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 15, trailing: 0))
                
                Spacer()
                
            }
            .onAppear(perform: {
                if homeVM.solAddressList.count == 0 {
                    isLoading = false
                }
                else {
                    homeVM.startOne()
                }
            })
            .onChange(of: homeVM.oneAddressList, perform: { _ in
                if homeVM.oneAddressList.count > 0 {
                    if !isLoading {
                        isLoading = true
                    }
                    homeVM.startOne()
                }
                else {
                    isLoading = false
                }
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
        .sheet(isPresented: $isShowingScanner) {
            CodeScannerView(codeTypes: [.qr], simulatedData: "Your Address", completion: self.handleScan)
        }
    }
    
    func OneGoBack() -> Void {
        if tabSelect == 2 {
            goBack()
        }
        else {
            if tabSelect == 4 {
                isStakeTab = false
            }
            selectedOne = CoinInfo.default
            homeVM.oneTransactions = []
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
    
    func onOneStake() -> Void {
        homeVM.getOneStake(id: selectedOne.id)
        homeVM.oneTransactions = []
    }
    
    func scanAddress() -> Void {
        isShowingScanner = true
        isScanningAddress = true
    }
    
    func scanNick() -> Void {
        isShowingScanner = true
        isScanningAddress = false
    }
    
    func handleScan(result: Result<String, CodeScannerView.ScanError>) {
        self.isShowingScanner = false
        //print("QR Code result")
        switch result {
        case .success(let code):
            if isScanningAddress {
                oneAddress = code
            }
            else {
                oneNickname = code
            }

        case .failure(_):
            print("")
            //print("Scanning failed: \(error.localizedDescription)")
        }
    }
}

struct ONETab_Previews: PreviewProvider {
    static var previews: some View {
        ONETab<HomeVMUnitTest>(goBack: { })
            .environmentObject(HomeVMUnitTest(isOnline: true))
    }
}
