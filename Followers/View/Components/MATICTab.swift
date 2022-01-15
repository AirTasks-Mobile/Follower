//
//  MATICTab.swift
//  Followers
//
//  Created by JEREMY NGUYEN on 02/01/2022.
//

import SwiftUI
import CodeScanner

struct MATICTab<T : HomeViewModelProtocol>: View {
    @EnvironmentObject var homeVM : T
    var goBack : () -> Void
    
    //private let startColour : Color  = Color(red : 130.0/255, green: 71.0/255, blue: 229.0/255)
    private let startColour : Color  = Color(red : 198.0/255, green: 157.0/255, blue: 242.0/255)
    private let centerColour : Color  = Color(red : 255.0/255, green: 225.0/255, blue: 255.0/255)
    //private let endColour : Color = Color(red : 130.0/255, green: 71.0/255, blue: 229.0/255)
    private let endColour : Color = Color(red : 69.0/255, green: 9.0/255, blue: 133.0/255)
    
    @State private var tabSelect = 2
    @State var maticAddress : String = ""
    @State var maticNickname : String = ""
    @State var selectedMatic : CoinInfo = CoinInfo.default
    @State var isWeb : Bool = false
    
    @State private var isShowingScanner = false
    @State private var isScanningAddress = false
    @State var isLoading = true
    
    var body: some View {
        GeometryReader { geo in
            VStack(alignment: .leading, spacing: 0) {
                ZStack{
                    HeaderView()
                    BackButton(action: MaticGoBack)
                }
                .frame(width: geo.size.width * 0.90, height: geo.size.height * 0.05)
                .padding(EdgeInsets(top: 35, leading: 0, bottom: 0, trailing: 0))
                
                TabView(selection: $tabSelect) {
                    CoinProfileTab(listCoin: $homeVM.maticCoins, selectedCoin: $selectedMatic, onDelCoin: onRevomveMatic)
                        .tag(0)
                    
                    StatisticView(isActive: $isWeb,type: GTEXT.POLYGON, onGoBack: MaticGoBack)
                        .tag(1)
                    
                    ListCoinTab(listCoin: $homeVM.maticCoins, selectedCoin: $selectedMatic, isLoading: $isLoading,onAddCoin: onClick, onDetail: getTransactions)
                        .tag(2)
                    
                    AddCoinTab(titleText: "Polygon Address Only", coinAddress: $maticAddress, nickName: $maticNickname, onAddCoin: onClick, onScanAddress: scanAddress, onScanNick: scanNick)
                        .tag(3)
                    
//                    ListTransactionTab(nick: $selectedMatic.nick, id: $selectedMatic.id, transactions: $homeVM.maticTransactions, isStake: false, onStake: { })
//                        .tag(4)
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .animation(.easeInOut)
                .transition(.slide)
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 15, trailing: 0))
                
                Spacer()

            }
            .onAppear(perform: {
                if homeVM.maticAddressList.count == 0 {
                    isLoading = false
                }
                else {
                    homeVM.startMatic()
                }
            })
            .onChange(of: homeVM.maticAddressList, perform: { _ in
                if homeVM.maticAddressList.count > 0 {
                    if !isLoading {
                        isLoading = true
                    }
                    homeVM.startMatic()
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
            .background(LinearGradient(gradient: Gradient(colors: [startColour, centerColour, endColour]), startPoint: .topLeading, endPoint: .bottomTrailing))
            .edgesIgnoringSafeArea(.all)
        }
        .sheet(isPresented: $isShowingScanner) {
            CodeScannerView(codeTypes: [.qr], simulatedData: "Your Address", completion: self.handleScan)
        }
    }
    
    func MaticGoBack() -> Void {
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
            homeVM.storeMatic(id: maticAddress, nick: maticNickname)
            maticAddress = ""
            maticNickname = ""
            tabSelect = 2
        }
    }
    
    func getTransactions() -> Void {
//        homeVM.getMaticTxn(id: selectedMatic.id)
//        tabSelect = 4
    }
    
    func onRevomveMatic() -> Void {
        var maticList = UserDefaults.standard.stringArray(forKey: GTEXT.MATIC_LIST) ?? []
        if maticList.count > 0 {
            let id = GTEXT.POLYGON + "_" + selectedMatic.id
            maticList = maticList.filter(){$0 != id}
            UserDefaults.standard.set(maticList, forKey: GTEXT.MATIC_LIST)
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
        print("QR Code result")
        switch result {
        case .success(let code):
            if isScanningAddress {
                maticAddress = code
            }
            else {
                maticNickname = code
            }

        case .failure(_):
            print("")
            //print("Scanning failed: \(error.localizedDescription)")
        }
    }
}

struct MATICTab_Previews: PreviewProvider {
    static var previews: some View {
        MATICTab<HomeVMUnitTest>(goBack: { })
            .environmentObject(HomeVMUnitTest(isOnline: true))
    }
}
