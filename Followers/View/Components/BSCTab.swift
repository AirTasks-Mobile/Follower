//
//  BSCTab.swift
//  Followers
//
//  Created by JEREMY NGUYEN on 05/01/2022.
//

import SwiftUI
import CodeScanner

struct BSCTab<T : HomeViewModelProtocol>: View {
    @EnvironmentObject var homeVM : T
    var goBack : () -> Void
    

    private let startColour : Color  = Color(red : 255.0/255, green: 215.0/255, blue: 0.0/255)
    //private let startColour : Color  = Color(red : 82.0/255, green: 76.0/255, blue: 46.0/255)
    //private let centerColour : Color  = Color(red : 255.0/255, green: 215.0/255, blue: 0.0/255)
    private let endColour : Color = Color(red : 120.0/255, green: 116.0/255, blue: 93.0/255)
    
    @State private var tabSelect = 2
    @State var bscAddress : String = ""
    @State var bscNickname : String = ""
    @State var selectedBsc : CoinInfo = CoinInfo.default
    @State var isWeb : Bool = false
    
    @State private var isShowingScanner = false
    @State private var isScanningAddress = false
    @State var isLoading = true
    
    var body: some View {
        GeometryReader { geo in
            VStack(alignment: .leading, spacing: 0) {
                ZStack{
                    HeaderView()
                    BackButton(action: BscGoBack)
                }
                .frame(width: geo.size.width * 0.90, height: geo.size.height * 0.05)
                .padding(EdgeInsets(top: 35, leading: 0, bottom: 0, trailing: 0))
                
                TabView(selection: $tabSelect) {
                    CoinProfileTab(listCoin: $homeVM.bscCoins, selectedCoin: $selectedBsc, onDelCoin: onRevomveBsc)
                        .tag(0)
                    
                    StatisticView(isActive: $isWeb,type: GTEXT.BINANCE, onGoBack: BscGoBack)
                        .tag(1)
                    
                    ListCoinTab(listCoin: $homeVM.bscCoins, selectedCoin: $selectedBsc, isLoading: $isLoading,onAddCoin: onClick, onDetail: getTransactions)
                        .tag(2)
                    
                    AddCoinTab(titleText: "Binace Smart Chain Address", coinAddress: $bscAddress, nickName: $bscNickname, onAddCoin: onClick, onScanAddress: scanAddress, onScanNick: scanNick)
                        .tag(3)
                    
//                    ListTransactionTab(nick: $selectedBsc.nick, id: $selectedBsc.id, transactions: $homeVM.bscTransactions, isStake: false, onStake: { })
//                        .tag(4)
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .animation(.easeInOut)
                .transition(.slide)
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 15, trailing: 0))
                
                Spacer()

            }
            .onAppear(perform: {
                if homeVM.bscAddressList.count == 0 {
                    isLoading = false
                }
                else {
                    homeVM.startBsc()
                }
            })
            .onChange(of: homeVM.bscAddressList, perform: { _ in
                if homeVM.bscAddressList.count > 0 {
                    if !isLoading {
                        isLoading = true
                    }
                    homeVM.startBsc()
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
            .background(LinearGradient(gradient: Gradient(colors: [startColour, endColour]), startPoint: .topLeading, endPoint: .bottomTrailing))
            .edgesIgnoringSafeArea(.all)
        }
        .sheet(isPresented: $isShowingScanner) {
            CodeScannerView(codeTypes: [.qr], simulatedData: "Your Address", completion: self.handleScan)
        }
    }
    
    func BscGoBack() -> Void {
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
            homeVM.storeBsc(id: bscAddress, nick: bscNickname)
            bscAddress = ""
            bscNickname = ""
            tabSelect = 2
        }
    }
    
    func getTransactions() -> Void {

        //homeVM.getBscTxn(id: selectedBsc.id)
        //tabSelect = 4
    }
    
    func onRevomveBsc() -> Void {
        var bscList = UserDefaults.standard.stringArray(forKey: GTEXT.BSC_LIST) ?? []
        if bscList.count > 0 {
            let id = GTEXT.BINANCE + "_" + selectedBsc.id
            bscList = bscList.filter(){$0 != id}
            UserDefaults.standard.set(bscList, forKey: GTEXT.BSC_LIST)
        }
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
      
        switch result {
        case .success(let code):
            if isScanningAddress {
                bscAddress = code
            }
            else {
                bscNickname = code
            }

        case .failure(_):
            print("")
            //print("Scanning failed: \(error.localizedDescription)")
        }
    }
}

struct BSCTab_Previews: PreviewProvider {
    static var previews: some View {
        BSCTab<HomeVMUnitTest>(goBack: { })
            .environmentObject(HomeVMUnitTest(isOnline: true))
    }
}
