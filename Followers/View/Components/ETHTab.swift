//
//  ETHTab.swift
//  Followers
//
//  Created by JEREMY NGUYEN on 07/01/2022.
//

import SwiftUI
import CodeScanner

struct ETHTab<T: HomeViewModelProtocol>: View {
    @EnvironmentObject var homeVM : T
    
    var goBack : () -> Void
    
    private let startColour : Color  = Color(red : 236.0/255, green: 240.0/255, blue: 241.0/255)
    //private let centerColour : Color  = Color(red : 3.0/255, green: 225.0/255, blue: 255.0/255)
    private let endColour : Color = Color(red : 60.0/255, green: 60.0/255, blue: 61.0/255)
    
    @State private var tabSelect = 2
    @State var ethAddress : String = ""
    @State var ethNickname : String = ""
    @State var selectedEth : CoinInfo = CoinInfo.default
    @State var isWeb : Bool = false
    
    @State private var isShowingScanner = false
    @State private var isScanningAddress = false
    @State var isLoading = true
    @State var isStakeTab : Bool = false // for iOS 14 issue
    
    var body: some View {
        GeometryReader { geo in
            VStack(alignment: .leading, spacing: 0) {
                ZStack{
                    HeaderView()
                    BackButton(action: EthGoBack)
                }
                .frame(width: geo.size.width * 0.90, height: geo.size.height * 0.05)
                .padding(EdgeInsets(top: 35, leading: 0, bottom: 0, trailing: 0))
                
                TabView(selection: $tabSelect){
                    CoinProfileTab(listCoin: $homeVM.ethCoins, selectedCoin: $selectedEth, onDelCoin: onRemoveEth)
                        .tag(0)
                    
                    StatisticView(isActive: $isWeb,type: GTEXT.ETHEREUM, onGoBack: EthGoBack)
                        .tag(1)
                    
                    ListCoinTab(listCoin: $homeVM.ethCoins, selectedCoin: $selectedEth, isLoading: $isLoading,onAddCoin: onClick, onDetail: getTransactions)
                        .tag(2)
                    
                    AddCoinTab(titleText: "ETH Address Only", coinAddress: $ethAddress, nickName: $ethNickname, onAddCoin: onClick, onScanAddress: scanAddress, onScanNick: scanNick)
                        .tag(3)
                    
                
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .animation(.easeInOut)
                .transition(.slide)
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 15, trailing: 0))
                
                Spacer()
            }
            .onAppear(perform: {
                if homeVM.ethAddressList.count == 0 {
                    isLoading = false
                }
                else {
                    homeVM.startEth()
                }
            })
            .onChange(of: homeVM.ethAddressList, perform: { _ in
                if homeVM.ethAddressList.count > 0 {
                    homeVM.startEth()
                    if !isLoading {
                        isLoading = true
                    }
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
    
    func getTransactions() -> Void {

    }
    
    func EthGoBack() -> Void {
        if tabSelect == 2 {
            isLoading = false
            homeVM.ethTransactions = []
            goBack()
        }
        else {
            if tabSelect == 4 {
                isStakeTab = false
            }
            
            selectedEth = CoinInfo.default
            homeVM.ethTransactions = []
            tabSelect = 2
        }
    }
    
    func onClick() -> Void {
        if tabSelect == 2 {
            tabSelect = 3
        }
        else if tabSelect == 3 {
            homeVM.storeEth(id: ethAddress, nick: ethNickname)
            ethAddress = ""
            ethNickname = ""
            tabSelect = 2
        }
    }
    
    func onRemoveEth() -> Void {
        var ethList = UserDefaults.standard.stringArray(forKey: GTEXT.ETH_LIST) ?? []
        if ethList.count > 0 {
            let id = GTEXT.ETHEREUM + "_" + selectedEth.id
            ethList = ethList.filter(){$0 != id}
            UserDefaults.standard.set(ethList, forKey: GTEXT.ETH_LIST)
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
        //print("QR Code result")
        switch result {
        case .success(let code):
            if isScanningAddress {
                ethAddress = code
            }
            else {
                ethNickname = code
            }

        case .failure(_):
            print("")
            //print("Scanning failed: \(error.localizedDescription)")
        }
    }
}

struct ETHTab_Previews: PreviewProvider {
    static var previews: some View {
        ETHTab<HomeVMUnitTest>(goBack: { })
            .environmentObject(HomeVMUnitTest(isOnline: true))
    }
}
