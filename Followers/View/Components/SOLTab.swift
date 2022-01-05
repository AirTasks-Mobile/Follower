//
//  SOLTab.swift
//  Followers
//
//  Created by JEREMY NGUYEN on 02/01/2022.
//

import SwiftUI
import CodeScanner

struct SOLTab<T : HomeViewModelProtocol>: View {
    @EnvironmentObject var homeVM : T
    
    var goBack : () -> Void
    
    private let startColour : Color  = Color(red : 0.0/255, green: 255.0/255, blue: 163.0/255)
    private let centerColour : Color  = Color(red : 3.0/255, green: 225.0/255, blue: 255.0/255)
    private let endColour : Color = Color(red : 220.0/255, green: 31.0/255, blue: 255.0/255)
    
    @State private var tabSelect = 2
    @State var solAddress : String = ""
    @State var solNickname : String = ""
    @State var selectedSol : CoinInfo = CoinInfo.default
    @State var isWeb : Bool = false
    
    @State private var isShowingScanner = false
    @State private var isScanningAddress = false
    
    var body: some View {
        GeometryReader { geo in
            VStack(alignment: .leading, spacing: 0) {
                ZStack{
                    HeaderView()
                    BackButton(action: SolGoBack)
                }
                .frame(width: geo.size.width * 0.90, height: geo.size.height * 0.05)
                .padding(EdgeInsets(top: 35, leading: 0, bottom: 0, trailing: 0))
                
                TabView(selection: $tabSelect){
                    CoinProfileTab(listCoin: $homeVM.solCoins, selectedCoin: $selectedSol, onDelCoin: onRevomveSol)
                        .tag(0)
                    
                    StatisticView(isActive: $isWeb,type: GTEXT.SOLANA, onGoBack: SolGoBack)
                        .tag(1)
                    
                    ListCoinTab(listCoin: $homeVM.solCoins, selectedCoin: $selectedSol ,onAddCoin: onClick, onDetail: getTransactions)
                        .tag(2)
                    
                    AddCoinTab(titleText: "Solana Address Only", coinAddress: $solAddress, nickName: $solNickname, onAddCoin: onClick, onScanAddress: scanAddress, onScanNick: scanNick)
                        .tag(3)
                    
                    ListTransactionTab(nick: $selectedSol.nick, id: $selectedSol.id, transactions: $homeVM.solTransactions, isStake: true, onStake: onGetSolStake)
                        .tag(4)
                
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .animation(.easeInOut)
                .transition(.slide)
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 15, trailing: 0))
                
                Spacer()
            }
            .onAppear(perform: {
                homeVM.startSol()
            })
            .onChange(of: homeVM.solAddressList, perform: { _ in
                homeVM.startSol()
            })
            .onChange(of: homeVM.solSignatures, perform: { _ in
                if tabSelect == 4 {
                    homeVM.fetchSolTxnDetail()
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
            .background(LinearGradient(gradient: Gradient(colors: [startColour, centerColour, endColour]), startPoint: .topTrailing, endPoint: .bottomLeading))
            .edgesIgnoringSafeArea(.all)
        }
        .sheet(isPresented: $isShowingScanner) {
            CodeScannerView(codeTypes: [.qr], simulatedData: "Your Address", completion: self.handleScan)
        }
        
    }
    func getTransactions() -> Void {
        homeVM.getSolTxn(id: selectedSol.id)
        tabSelect = 4
    }
    func SolGoBack() -> Void {
        if tabSelect == 2 {
            goBack()
        }
        else {
            selectedSol = CoinInfo.default
            homeVM.solTransactions = []
            tabSelect = 2
        }
    }
    
    func onClick() -> Void {
        if tabSelect == 2 {
            tabSelect = 3
        }
        else if tabSelect == 3 {
            homeVM.storeSol(id: solAddress, nick: solNickname)
            solAddress = ""
            solNickname = ""
            tabSelect = 2
        }
    }
    
    func onRevomveSol() -> Void {
        var solList = UserDefaults.standard.stringArray(forKey: GTEXT.SOL_LIST) ?? []
        if solList.count > 0 {
            let id = GTEXT.SOLANA + "_" + selectedSol.id
            solList = solList.filter(){$0 != id}
            UserDefaults.standard.set(solList, forKey: GTEXT.SOL_LIST)
        }
    }
    
    func onGetSolStake() -> Void {
        var solStakes : [StakeAccountInfo] = []
        for txn in homeVM.solTransactions {
            if selectedSol.id == txn.src {
                solStakes.append(txn.stake!)
            }
        }
        
        // fetch stake
        homeVM.fetchSolStake(sol: solStakes)
        homeVM.solTransactions = []
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
                solAddress = code
            }
            else {
                solNickname = code
            }

        case .failure(_):
            print("")
            //print("Scanning failed: \(error.localizedDescription)")
        }
    }
}

struct SOLTab_Previews: PreviewProvider {
    static var previews: some View {
        SOLTab<HomeVMUnitTest>(goBack: { })
            .environmentObject(HomeVMUnitTest(isOnline: true))
    }
}
