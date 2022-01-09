//
//  XLMTab.swift
//  Followers
//
//  Created by JEREMY NGUYEN on 07/01/2022.
//

import SwiftUI
import CodeScanner

struct XLMTab<T: HomeViewModelProtocol>: View {
    @EnvironmentObject var homeVM : T
    
    var goBack : () -> Void
    
    private let startColour : Color  = Color(red : 225.0/255, green: 225.0/255, blue: 225.0/255)
    //private let centerColour : Color  = Color(red : 3.0/255, green: 225.0/255, blue: 255.0/255)
    private let endColour : Color = Color(red : 0.0/255, green: 0.0/255, blue: 0.0/255)
    
    @State private var tabSelect = 2
    @State var xlmAddress : String = ""
    @State var xlmNickname : String = ""
    @State var selectedXlm : CoinInfo = CoinInfo.default
    @State var isWeb : Bool = false
    
    @State private var isShowingScanner = false
    @State private var isScanningAddress = false
    @State var isLoading = true
    @State var isStakeTab : Bool = false // for iOS 14 issue
    @State var isLast : Bool = false
    
    var body: some View {
        GeometryReader { geo in
            VStack(alignment: .leading, spacing: 0) {
                ZStack{
                    HeaderView()
                    BackButton(action: XlmGoBack)
                }
                .frame(width: geo.size.width * 0.90, height: geo.size.height * 0.05)
                .padding(EdgeInsets(top: 35, leading: 0, bottom: 0, trailing: 0))
                
                TabView(selection: $tabSelect){
                    CoinProfileTab(listCoin: $homeVM.xlmCoins, selectedCoin: $selectedXlm, onDelCoin: onRemoveXlm)
                        .tag(0)
                    
                    StatisticView(isActive: $isWeb,type: GTEXT.STELLAR, onGoBack: XlmGoBack)
                        .tag(1)
                    
                    ListCoinTab(listCoin: $homeVM.xlmCoins, selectedCoin: $selectedXlm, isLoading: $isLoading,onAddCoin: onClick, onDetail: getTransactions)
                        .tag(2)
                    
                    AddCoinTab(titleText: "Stellar Address Only", coinAddress: $xlmAddress, nickName: $xlmNickname, onAddCoin: onClick, onScanAddress: scanAddress, onScanNick: scanNick)
                        .tag(3)
                    
                    ListTransactionTab(nick: $selectedXlm.nick, id: $selectedXlm.id, transactions: $homeVM.xlmTransactions, isLoading: $isLoading, stake: $isStakeTab, isLast: $isLast,isStake: false, onStake: { }, loadMore: loadMoreTransactions)
                        .tag(4)
                
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .animation(.easeInOut)
                .transition(.slide)
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 15, trailing: 0))
                
                Spacer()
            }
            .onAppear(perform: {
                if homeVM.xlmAddressList.count == 0 {
                    isLoading = false
                }
                else {
                    homeVM.startXlm()
                }
            })
            .onChange(of: homeVM.xlmAddressList, perform: { _ in
                if homeVM.xlmAddressList.count > 0 {
                    homeVM.startXlm()
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
            .onChange(of: homeVM.xlmCursor, perform: { _ in
                if tabSelect == 4 && homeVM.xlmCursor !=  "" && homeVM.xlmCursor !=  " " && homeVM.xlmTransactions.count < GTEXT.MAX_TRANSACTION {
                    if !isLoading {
                        isLoading = true
                    }
                    //print("Here ???? = \(homeVM.xlmCursor) txn = \(homeVM.xlmTransactions.count)")
                    homeVM.getXlmTxn(id: selectedXlm.id)
                }
                else {
                    isLoading = false
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
    
    func XlmGoBack() -> Void {
        if tabSelect == 2 {
            isLoading = false
            homeVM.xlmTransactions = []
            goBack()
        }
        else {
            if tabSelect == 4 {
                isLoading = false
            }
  
            selectedXlm = CoinInfo.default
            homeVM.xlmTransactions = []
            tabSelect = 2
        }
    }
    
    func getTransactions() -> Void {
        tabSelect = 4
        isLoading = true
        homeVM.xlmCursor = ""
        homeVM.xlmTransactions = []
        homeVM.getXlmTxn(id: selectedXlm.id)
    }
    
    func loadMoreTransactions() -> Void {
        if homeVM.xlmCursor == "" || homeVM.xlmCursor == " " {
            isLast = true
            return
        }
        
        isLoading = true
        if homeVM.xlmTransactions.count < GTEXT.MAX_LIST {
            homeVM.getXlmTxn(id: selectedXlm.id)
        }
        else {
            homeVM.getXlmTxn(id: selectedXlm.id)
            //homeVM.xlmTransactions.removeFirst(GTEXT.BLOCK_TRANSACTION) // reomve some transactions to get spaces
            homeVM.xlmTransactions.removeLast(GTEXT.BLOCK_TRANSACTION)
        }
    }
    
    func onClick() -> Void {
        if tabSelect == 2 {
            tabSelect = 3
        }
        else if tabSelect == 3 {
            homeVM.storeXlm(id: xlmAddress, nick: xlmNickname)
            xlmAddress = ""
            xlmNickname = ""
            isLoading = true
            tabSelect = 2
        }
    }
    
    func onRemoveXlm() -> Void {
        var xlmList = UserDefaults.standard.stringArray(forKey: GTEXT.XLM_LIST) ?? []
        if xlmList.count > 0 {
            let id = GTEXT.STELLAR + "_" + selectedXlm.id
            xlmList = xlmList.filter(){$0 != id}
            UserDefaults.standard.set(xlmList, forKey: GTEXT.XLM_LIST)
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
                xlmAddress = code
            }
            else {
                xlmNickname = code
            }

        case .failure(_):
            print("")
            //print("Scanning failed: \(error.localizedDescription)")
        }
    }
}

struct XLMTab_Previews: PreviewProvider {
    static var previews: some View {
        XLMTab<HomeVMUnitTest>(goBack: { })
            .environmentObject(HomeVMUnitTest(isOnline: true))
    }
}
