//
//  HomeVM.swift
//  Followers
//
//  Created by JEREMY NGUYEN on 19/07/2021.
//

import Foundation
import Combine
import SwiftUI

protocol HomeViewModelProtocol : ObservableObject {
    var isOnline : Bool { get set }
    var solCoins : [CoinInfo] { get set }
    var oneCoins : [CoinInfo] { get set }
    var maticCoins : [CoinInfo] { get set }
    var bscCoins : [CoinInfo] { get set }
    var ethCoins : [CoinInfo] { get set }
    var xlmCoins : [CoinInfo] { get set }
    var solAddressList : [String] { get set }
    var oneAddressList : [String] { get set }
    var maticAddressList : [String] { get set }
    var bscAddressList : [String] { get set }
    var ethAddressList : [String] { get set }
    var xlmAddressList : [String] { get set }
    
    var solTransactions : [TransactionInfo] { get set }
    var oneTransactions : [TransactionInfo] { get set }
    var maticTransactions : [TransactionInfo] { get set }
    var bscTransactions : [TransactionInfo] { get set }
    var ethTransactions : [TransactionInfo] { get set }
    var xlmTransactions : [TransactionInfo] { get set }
    
    var solSignatures : [String] { get set }
    //var oneSignatures : [String] { get set }
    //var maticSignatures : [String] { get set }
    var xlmCursor : Double { get set }
    
    var totalSol : String { get set }
    var totalOne : String { get set }
    var totalMatic : String { get set }
    var totalBsc : String { get set }
    var totalEth : String { get set }
    var totalXlm : String { get set }
    
    var mainQueue : [String] { get set }
    
    func startHome()
    
    //
    func startSol()
    func storeSol(id: String, nick: String)
    func getSolTxn(id : String)
    func fetchSolTxnDetail()
    func fetchSolStake(sol : [StakeAccountInfo])
    //
    func startOne()
    func storeOne(id: String, nick: String)
    func getOneTxn(id : String)
    //func fetchOneTxnDetail()
    func getOneStake(id : String)
    //
    func startMatic()
    func storeMatic(id: String, nick: String)
    func getMaticTxn(id : String)
    func fetchMaticTxnDetail()
    //
    func startBsc()
    func storeBsc(id: String, nick: String)
    //
    func startEth()
    func storeEth(id: String, nick: String)
    //
    func startXlm()
    func storeXlm(id: String, nick: String)
    func getXlmTxn(id : String)
}

class HomeVM : HomeViewModelProtocol {

    @Published var isOnline: Bool = true
    @Published var solCoins: [CoinInfo] = []
    @Published var oneCoins: [CoinInfo] = []
    @Published var maticCoins: [CoinInfo] = []
    @Published var bscCoins: [CoinInfo] = []
    @Published var ethCoins: [CoinInfo] = []
    @Published var xlmCoins: [CoinInfo] = []
    @Published var solAddressList: [String] = []
    @Published var oneAddressList: [String] = []
    @Published var maticAddressList: [String] = []
    @Published var bscAddressList: [String] = []
    @Published var ethAddressList: [String] = []
    @Published var xlmAddressList: [String] = []
    @Published var tempCoins: [CoinInfo] = []
    @Published var solTransactions: [TransactionInfo] = []
    @Published var oneTransactions: [TransactionInfo] = []
    @Published var maticTransactions: [TransactionInfo] = []
    @Published var bscTransactions: [TransactionInfo] = []
    @Published var ethTransactions: [TransactionInfo] = []
    @Published var xlmTransactions: [TransactionInfo] = []
    @Published var solSignatures: [String] = []
    //@Published var oneSignatures: [String] = []
    //@Published var maticSignatures: [String] = []
    @Published var xlmCursor: Double = 0
    @Published var totalSol: String = ""
    @Published var totalOne: String = ""
    @Published var totalMatic: String = ""
    @Published var totalBsc: String = ""
    @Published var totalEth: String = ""
    @Published var totalXlm: String = ""
    @Published var mainQueue: [String] = []
    
    private var task : AnyCancellable?
    private var tempList : [String] = []
    
    func startHome() {

        // sol
        solCoins = []
        solAddressList = UserDefaults.standard.stringArray(forKey: GTEXT.SOL_LIST) ?? []
        
        //
        oneCoins = []
        oneAddressList = UserDefaults.standard.stringArray(forKey: GTEXT.ONE_LIST) ?? []
        
        //
        maticCoins = []
        maticAddressList = UserDefaults.standard.stringArray(forKey: GTEXT.MATIC_LIST) ?? []
        
        //
        bscCoins = []
        bscAddressList = UserDefaults.standard.stringArray(forKey: GTEXT.BSC_LIST) ?? []
        
        //
        ethCoins = []
        ethAddressList = UserDefaults.standard.stringArray(forKey: GTEXT.ETH_LIST) ?? []
        
        //
        xlmCoins = []
        xlmAddressList = UserDefaults.standard.stringArray(forKey: GTEXT.XLM_LIST) ?? []
        
        var queue: [String] = []
        if solAddressList.count > 0 {
            queue.append(GTEXT.SOLANA)
        }
        if oneAddressList.count > 0 {
            queue.append(GTEXT.HARMONY)
        }
        if xlmAddressList.count > 0 {
            queue.append(GTEXT.STELLAR)
        }
        if maticAddressList.count > 0 {
            queue.append(GTEXT.POLYGON)
        }
        if bscAddressList.count > 0 {
            queue.append(GTEXT.BINANCE)
        }
        if ethAddressList.count > 0 {
            queue.append(GTEXT.ETHEREUM)
        }
        
        
        mainQueue = queue
        //mainQueue = [GTEXT.SOLANA, GTEXT.HARMONY, GTEXT.POLYGON, GTEXT.BINANCE, GTEXT.ETHEREUM]
        //mainQueue = [GTEXT.HARMONY, GTEXT.POLYGON, GTEXT.BINANCE, GTEXT.SOLANA]
    }
    
    func startSol() {
        if solAddressList.count <= 0 {
            return
        }
        
        // refresh
        let address : String = solAddressList[0]
        if address != "" {
            //print("\(solAddressList.count) Address = \(address)")
            loadThenRefreshSol(id: address)
        }
    }

    
    func storeSol(id: String, nick: String) {
        tempList = UserDefaults.standard.stringArray(forKey: GTEXT.SOL_LIST) ?? []
        let flow = GetSolBalance()
        flow.setViewInfo(info: ["id": id])
        task = flow.processFlow()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { result in
                
            }, receiveValue: { data in
                //print("back here !!!! \(self.tempList)")
                let sol = CoinInfo(type: GTEXT.SOLANA, id: id, nick: nick, pic: "", bal: data.balance ?? "", date: "")
                let key = GTEXT.SOLANA + "_" + id
                if let encodedSol = try? JSONEncoder().encode(sol) {
                    UserDefaults.standard.set(encodedSol, forKey: key)
                    self.tempList.append(key)
                    UserDefaults.standard.set(self.tempList, forKey: GTEXT.SOL_LIST)

                    self.solCoins = []
                    self.solAddressList = UserDefaults.standard.stringArray(forKey: GTEXT.SOL_LIST) ?? []
                    self.mainQueue = [GTEXT.SOLANA]
                }
            })
    }
    
    func refreshSolInfo(id : String , nick: String){
        let flow = GetSolBalance()
        flow.setViewInfo(info: ["id": id])
        task = flow.processFlow()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { result in
                if self.solAddressList.count > 0 {
                    self.solAddressList.removeFirst()
                    
                    // calculate total
                    self.getTotalSol()
                }
                if self.solAddressList.count == 0 {
                    // remove from Queue
                    //self.mainQueue = self.mainQueue.filter(){$0 != GTEXT.SOLANA}
                    self.mainQueue.removeFirst()
                }
            }, receiveValue: { data in
                //print("back here !!!! \(data)")
                let sol = CoinInfo(type: GTEXT.SOLANA, id: id, nick: nick, pic: "", bal: data.balance ?? "", date: "")
                let key = GTEXT.SOLANA + "_" + id
                if let encodedSol = try? JSONEncoder().encode(sol) {
                    UserDefaults.standard.set(encodedSol, forKey: key)
                    self.solCoins.append(sol)
                }
            })
    }
    
    
    func loadThenRefreshSol(id : String){
        if let solData = UserDefaults.standard.object(forKey: id) as? Data {
            if let solInfo = try? JSONDecoder().decode(CoinInfo.self, from: solData) {
                refreshSolInfo(id: solInfo.id, nick: solInfo.nick)
            }
        }
    }
    
    func getSolTxn(id : String) {
        let flow = GetSolTranaction()
        flow.setViewInfo(info: ["id": id])
        task = flow.processFlow()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { result in
                
            }, receiveValue: { data in
                let list = data.signature ?? []
                if list.count > 0 {
                    self.solSignatures = list
                    //print("list sol = \(self.solSignatures)")
                }
            })
    }
    
    func fetchSolTxnDetail() -> Void {
        if solSignatures.count <= 0 {
            return
        }
        
        let txnSignature = solSignatures[0]
        if txnSignature != "" {
            // fetch ...
            let flow = GetSolTransactionDetail()
            flow.setViewInfo(info: ["id": txnSignature])
            task = flow.processFlow()
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { result in
                    if self.solSignatures.count > 0 { // user change to stake tab while loading transactions
                        self.solSignatures.removeFirst()
                    }
                    
                }, receiveValue: { data in
                    //print("back here !!!! \(data)")
                    if data.isSuccess && self.solSignatures.count > 0 { // user change to stake tab while loading transactions
                        self.solTransactions.append(data.transaction!)
                    }
                })
            
        }
    }
    
    func fetchSolStake(sol: [StakeAccountInfo]) {
        if sol.count == 0 {
            return
        }
        
        let flow = GetSolStake()
        flow.setStakeList(sol: sol)
        task = flow.processFlow()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { result in
                //
            }, receiveValue: { data in
                //print("back here !!!! \(data)")
                if data.isSuccess {
                    self.solTransactions = data.transactions!
                }
            })
    }
    
    func getTotalSol() -> Void {
        let mySol = solCoins
        if mySol.count == 0 {
            totalSol = ""
        }
        
        var total : Double = 0
        for sol in mySol {
            total += Double(sol.bal) ?? 0
        }
        
        if total > 0 {
            totalSol = getFormattedNumber(total: total)
        }
    }
    
    func getFormattedNumber(total: Double) -> String {
        var numString : String
        
        if total < 1 {
            numString = String(format: "%.4f", total)
        }
        else if total >= 1 && total < 10 {
            numString = String(format: "%.4f", total)
        }
        else if total >= 10 && total < 100 {
            numString = String(format: "%.3f", total)
        }
        else if total >= 100 && total < 1000 {
            numString = formatNumber(num: String(format: "%.3f", total))
        }
        else if total >= 1000 && total < 10000 {
            numString = formatNumber(num: String(format: "%.2f", total))
        }
        else if total >= 10000 && total < 100000 {
            numString = formatNumber(num: String(format: "%.1f", total))
        }
        else if total >= 100000 && total < 1000000000 {
            numString = formatNumber(num: String(format: "%.0f", total))
        }
        else {
            numString = String(format: "%.0f+ bil", total / 1000000000)
        }
        
        
        return numString
    }
    
    func formatNumber(num : String) -> String {
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
                formatter.usesSignificantDigits = true
                formatter.minimumSignificantDigits = 1 // default
                formatter.maximumSignificantDigits = 6 // default
        let value = NSDecimalNumber(string: num)
    
        let numString = formatter.string(for: value) ?? ""
        
        return numString
    }
    
    //  One
    func startOne() {
        if oneAddressList.count <= 0 {
            return
        }
        
        // refresh
        let address : String = oneAddressList[0]
        if address != "" {
            //print("\(oneAddressList.count) Address = \(address)")
            loadThenRefreshOne(id: address)
        }
    }
    
    func loadThenRefreshOne(id : String){
        if let oneData = UserDefaults.standard.object(forKey: id) as? Data {
            if let oneInfo = try? JSONDecoder().decode(CoinInfo.self, from: oneData) {
                refreshOneInfo(id: oneInfo.id, nick: oneInfo.nick)
            }
        }
    }
    
    func refreshOneInfo(id : String , nick: String){
        let flow = GetOneBalance()
        flow.setViewInfo(info: ["id": id])
        task = flow.processFlow()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { result in
                if self.oneAddressList.count > 0 {
                    self.oneAddressList.removeFirst()
                    
                    // calculate total
                    self.getTotalOne()
                }
                if self.oneAddressList.count == 0 {
                    // remove ONE from queue list
                    //self.mainQueue = self.mainQueue.filter(){$0 != GTEXT.HARMONY}
                    self.mainQueue.removeFirst()
                }
            }, receiveValue: { data in
                //print("back here !!!! \(data)")
                let one = CoinInfo(type: GTEXT.HARMONY, id: id, nick: nick, pic: "", bal: data.balance ?? "", date: "")
                let key = GTEXT.HARMONY + "_" + id
                if let encodedOne = try? JSONEncoder().encode(one) {
                    UserDefaults.standard.set(encodedOne, forKey: key)
                    self.oneCoins.append(one)
                }
            })
    }
    
    func storeOne(id: String, nick: String) {
        tempList = UserDefaults.standard.stringArray(forKey: GTEXT.ONE_LIST) ?? []
        let flow = GetOneBalance()
        flow.setViewInfo(info: ["id": id])
        task = flow.processFlow()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { result in
                
            }, receiveValue: { data in
                //print("back here !!!! \(self.tempList)")
                //print("back here !!!! \(data)")
                let one = CoinInfo(type: GTEXT.HARMONY, id: id, nick: nick, pic: "", bal: data.balance ?? "", date: "")
                let key = GTEXT.HARMONY + "_" + id
                if let encodedOne = try? JSONEncoder().encode(one) {
                    UserDefaults.standard.set(encodedOne, forKey: key)
                    self.tempList.append(key)
                    UserDefaults.standard.set(self.tempList, forKey: GTEXT.ONE_LIST)

                    self.oneCoins = []
                    self.oneAddressList = UserDefaults.standard.stringArray(forKey: GTEXT.ONE_LIST) ?? []
                    self.mainQueue = [GTEXT.HARMONY]
                }
            })
    }
    
    func getOneTxn(id: String) {
        let flow = GetOneTransaction()
        
        flow.setViewInfo(info: ["id": id])
        task = flow.processFlow()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { result in
                
            }, receiveValue: { data in
                //print("back here !!!! \(data)")
                let list = data.transactions ?? []
                if list.count > 0 {
                    self.oneTransactions = list
                }
            })
    }
    
    func getOneStake(id: String) {
        let flow = GetOneStake()
        
        flow.setViewInfo(info: ["id": id])
        task = flow.processFlow()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { result in
                
            }, receiveValue: { data in
                let list = data.transactions ?? []
                if list.count > 0 {
                    self.oneTransactions = list
                }
            })
    }
    
    func getTotalOne() -> Void {
        let myOne = oneCoins
        if myOne.count == 0 {
            totalOne = ""
        }
        
        var total : Double = 0
        for sol in myOne {
            total += Double(sol.bal) ?? 0
        }
        
        if total > 0 {
            totalOne = getFormattedNumber(total: total)
        }
    }
    
    
    //  Matic
    func startMatic() {
        if maticAddressList.count <= 0 {
            return
        }
        
        // refresh
        let address : String = maticAddressList[0]
        if address != "" {
            //print("\(maticAddressList.count) Address = \(address)")
            loadThenRefreshMatic(id: address)
        }
    }
    
    func loadThenRefreshMatic(id : String){
        if let maticData = UserDefaults.standard.object(forKey: id) as? Data {
            if let maticInfo = try? JSONDecoder().decode(CoinInfo.self, from: maticData) {
                refreshMaticInfo(id: maticInfo.id, nick: maticInfo.nick)
            }
        }
    }
    
    func refreshMaticInfo(id : String , nick: String){
        let flow = GetMaticBalance()
        flow.setViewInfo(info: ["id": id])
        task = flow.processFlow()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { result in
                if self.maticAddressList.count > 0 {
                    self.maticAddressList.removeFirst()
                    
                    // calculate total
                    self.getTotalMatic()
                }
                if self.maticAddressList.count == 0 {
                    //self.mainQueue = self.mainQueue.filter(){$0 != GTEXT.POLYGON}
                    self.mainQueue.removeFirst()
                }
            }, receiveValue: { data in
                //print("back here !!!! \(data)")
                let matic = CoinInfo(type: GTEXT.POLYGON, id: id, nick: nick, pic: "", bal: data.balance ?? "", date: "")
                let key = GTEXT.POLYGON + "_" + id
                if let encodedMatic = try? JSONEncoder().encode(matic) {
                    UserDefaults.standard.set(encodedMatic, forKey: key)
                    self.maticCoins.append(matic)
                }
            })
    }
    
    func storeMatic(id: String, nick: String) {
        tempList = UserDefaults.standard.stringArray(forKey: GTEXT.MATIC_LIST) ?? []
        let flow = GetMaticBalance()
        flow.setViewInfo(info: ["id": id])
        task = flow.processFlow()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { result in
                
            }, receiveValue: { data in
                //print("back here !!!! \(self.tempList)")
                let matic = CoinInfo(type: GTEXT.POLYGON, id: id, nick: nick, pic: "", bal: data.balance ?? "", date: "")
                let key = GTEXT.POLYGON + "_" + id
                if let encodedMatic = try? JSONEncoder().encode(matic) {
                    UserDefaults.standard.set(encodedMatic, forKey: key)
                    self.tempList.append(key)
                    UserDefaults.standard.set(self.tempList, forKey: GTEXT.MATIC_LIST)

                    self.maticCoins = []
                    self.maticAddressList = UserDefaults.standard.stringArray(forKey: GTEXT.MATIC_LIST) ?? []
                    self.mainQueue = [GTEXT.POLYGON]
                }
            })
    }
    
    func getMaticTxn(id: String) {
        //
    }
    
    func fetchMaticTxnDetail() -> Void {

    }
    
    func getTotalMatic() -> Void {
        let myMatic = maticCoins
        if myMatic.count == 0 {
            totalMatic = ""
        }
        
        var total : Double = 0
        for sol in myMatic {
            total += Double(sol.bal) ?? 0
        }
        
        if total > 0 {
            totalMatic = getFormattedNumber(total: total)
        }
    }
    
    // Binance
    func startBsc() {
        if bscAddressList.count <= 0 {
            return
        }
        
        // refresh
        let address : String = bscAddressList[0]
        if address != "" {
            loadThenRefreshBsc(id: address)
        }
    }
    
    func loadThenRefreshBsc(id : String){
        if let bscData = UserDefaults.standard.object(forKey: id) as? Data {
            if let bscInfo = try? JSONDecoder().decode(CoinInfo.self, from: bscData) {
                refreshBscInfo(id: bscInfo.id, nick: bscInfo.nick)
            }
        }
    }
    
    func refreshBscInfo(id : String , nick: String){
        let flow = GetBscBalance()
        flow.setViewInfo(info: ["id": id])
        task = flow.processFlow()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { result in
                if self.bscAddressList.count > 0 {
                    self.bscAddressList.removeFirst()
                    
                    // calculate total
                    self.getTotalBsc()
                }
                if self.bscAddressList.count == 0 {
                    //self.mainQueue = self.mainQueue.filter(){$0 != GTEXT.BINANCE}
                    self.mainQueue.removeFirst()
                }
            }, receiveValue: { data in
                //print("back here !!!! \(data)")
                let bsc = CoinInfo(type: GTEXT.BINANCE, id: id, nick: nick, pic: "", bal: data.balance ?? "", date: "")
                let key = GTEXT.BINANCE + "_" + id
                if let encodedBsc = try? JSONEncoder().encode(bsc) {
                    UserDefaults.standard.set(encodedBsc, forKey: key)
                    self.bscCoins.append(bsc)
                }
            })
    }
    
    func storeBsc(id: String, nick: String) {
        tempList = UserDefaults.standard.stringArray(forKey: GTEXT.BSC_LIST) ?? []
        let flow = GetBscBalance()
        flow.setViewInfo(info: ["id": id])
        task = flow.processFlow()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { result in
                
            }, receiveValue: { data in
                //print("back here !!!! \(data)")
                let bsc = CoinInfo(type: GTEXT.BINANCE, id: id, nick: nick, pic: "", bal: data.balance ?? "", date: "")
                let key = GTEXT.BINANCE + "_" + id
                if let encodedBsc = try? JSONEncoder().encode(bsc) {
                    UserDefaults.standard.set(encodedBsc, forKey: key)
                    self.tempList.append(key)
                    UserDefaults.standard.set(self.tempList, forKey: GTEXT.BSC_LIST)

                    self.bscCoins = []
                    self.bscAddressList = UserDefaults.standard.stringArray(forKey: GTEXT.BSC_LIST) ?? []
                    self.mainQueue = [GTEXT.BINANCE]
                }
            })
    }
    
    func getTotalBsc() -> Void {
        let myBsc = bscCoins
        if myBsc.count == 0 {
            totalBsc = ""
        }
        
        var total : Double = 0
        for sol in myBsc {
            total += Double(sol.bal) ?? 0
        }
        
        if total > 0 {
            totalBsc = getFormattedNumber(total: total)
        }
    }
    
    // ETH
    func startEth() {
        if ethAddressList.count <= 0 {
            return
        }
        
        // refresh
        let address : String = ethAddressList[0]
        if address != "" {
            loadThenRefreshEth(id: address)
        }
    }
    
    func loadThenRefreshEth(id : String){
        if let ethData = UserDefaults.standard.object(forKey: id) as? Data {
            if let ethInfo = try? JSONDecoder().decode(CoinInfo.self, from: ethData) {
                refreshEthInfo(id: ethInfo.id, nick: ethInfo.nick)
            }
        }
    }
    
    func refreshEthInfo(id : String , nick: String){
        let flow = GetEthBalance()
        flow.setViewInfo(info: ["id": id])
        task = flow.processFlow()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { result in
                if self.ethAddressList.count > 0 {
                    self.ethAddressList.removeFirst()
                    
                    // calculate total
                    self.getTotalEth()
                }
                if self.ethAddressList.count == 0 {
                    //self.mainQueue = self.mainQueue.filter(){$0 != GTEXT.ETHEREUM}
                    self.mainQueue.removeFirst()
                }
            }, receiveValue: { data in
                //print("back here !!!! \(data)")
                let eth = CoinInfo(type: GTEXT.ETHEREUM, id: id, nick: nick, pic: "", bal: data.balance ?? "", date: "")
                let key = GTEXT.ETHEREUM + "_" + id
                if let encodedEth = try? JSONEncoder().encode(eth) {
                    UserDefaults.standard.set(encodedEth, forKey: key)
                    self.ethCoins.append(eth)
                }
            })
    }
    
    func storeEth(id: String, nick: String) {
        tempList = UserDefaults.standard.stringArray(forKey: GTEXT.ETH_LIST) ?? []
        let flow = GetEthBalance()
        flow.setViewInfo(info: ["id": id])
        task = flow.processFlow()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { result in
                
            }, receiveValue: { data in
                //print("back here !!!! \(data)")
                let eth = CoinInfo(type: GTEXT.ETHEREUM, id: id, nick: nick, pic: "", bal: data.balance ?? "", date: "")
                let key = GTEXT.ETHEREUM + "_" + id
                if let encodedEth = try? JSONEncoder().encode(eth) {
                    UserDefaults.standard.set(encodedEth, forKey: key)
                    self.tempList.append(key)
                    UserDefaults.standard.set(self.tempList, forKey: GTEXT.ETH_LIST)

                    self.ethCoins = []
                    self.ethAddressList = UserDefaults.standard.stringArray(forKey: GTEXT.ETH_LIST) ?? []
                    self.mainQueue = [GTEXT.ETHEREUM]
                }
            })
    }
    
    func getTotalEth() -> Void {
        let myEth = ethCoins
        if myEth.count == 0 {
            totalEth = ""
        }
        
        var total : Double = 0
        for eth in myEth {
            total += Double(eth.bal) ?? 0
        }
        
        if total > 0 {
            totalEth = getFormattedNumber(total: total)
        }
    }
    
    // XLM
    func refreshXlmInfo(id : String , nick: String){
        let flow = GetXlmAccount()
        flow.setViewInfo(info: ["id": id])
        task = flow.processFlow()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { result in
                if self.xlmAddressList.count > 0 {
                    self.xlmAddressList.removeFirst()
                    
                    // calculate total
                    self.getTotalXlm()
                }
                if self.xlmAddressList.count == 0 {
                    //self.mainQueue = self.mainQueue.filter(){$0 != GTEXT.ETHEREUM}
                    self.mainQueue.removeFirst()
                }
            }, receiveValue: { data in
                //print("back here !!!! \(data)")
                let xlm = CoinInfo(type: GTEXT.STELLAR, id: id, nick: nick, pic: "", bal: data.balance ?? "", date: "", assets: data.assets ?? [])
                let key = GTEXT.STELLAR + "_" + id
                if let encodedXlm = try? JSONEncoder().encode(xlm) {
                    UserDefaults.standard.set(encodedXlm, forKey: key)
                    self.xlmCoins.append(xlm)
                }
            })
    }
    
    func loadThenRefreshXlm(id : String){
        if let xlmData = UserDefaults.standard.object(forKey: id) as? Data {
            if let xlmInfo = try? JSONDecoder().decode(CoinInfo.self, from: xlmData) {
                refreshXlmInfo(id: xlmInfo.id, nick: xlmInfo.nick)
            }
        }
    }
    
    func startXlm() {
        if xlmAddressList.count <= 0 {
            return
        }
        
        // refresh
        let address : String = xlmAddressList[0]
        if address != "" {
            loadThenRefreshXlm(id: address)
        }
    }
    
    func storeXlm(id: String, nick: String) {
        tempList = UserDefaults.standard.stringArray(forKey: GTEXT.STELLAR) ?? []
        let flow = GetXlmAccount()
        flow.setViewInfo(info: ["id": id])
        task = flow.processFlow()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { result in
                
            }, receiveValue: { data in
                //print("back here !!!! \(data)")
                let xlm = CoinInfo(type: GTEXT.STELLAR, id: id, nick: nick, pic: "", bal: data.balance ?? "", date: "", assets: data.assets ?? [])
                let key = GTEXT.STELLAR + "_" + id
                if let encodedXlm = try? JSONEncoder().encode(xlm) {
                    UserDefaults.standard.set(encodedXlm, forKey: key)
                    self.tempList.append(key)
                    UserDefaults.standard.set(self.tempList, forKey: GTEXT.XLM_LIST)

                    self.xlmCoins = []
                    self.xlmAddressList = UserDefaults.standard.stringArray(forKey: GTEXT.XLM_LIST) ?? []
                    self.mainQueue = [GTEXT.STELLAR]
                }
            })
    }
    
    func getXlmTxn(id: String) {
        let flow = GetXLMTransaction()
   
        flow.setViewInfo(info: ["id": id])
        task = flow.processFlow()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { result in
                
            }, receiveValue: { data in
                //print("back here !!!! \(data)")
                let list = data.transactions ?? []
                if list.count > 0 {
                    self.xlmTransactions = list
                    self.xlmCursor = data.cursor ?? 0
                }
            })
    }
    
    func getTotalXlm() -> Void {
        let myXlm = xlmCoins
        if myXlm.count == 0 {
            totalXlm = ""
        }
        
        var total : Double = 0
        for xlm in myXlm {
            total += Double(xlm.bal) ?? 0
        }
        
        if total > 0 {
            totalXlm = getFormattedNumber(total: total)
        }
    }
}
