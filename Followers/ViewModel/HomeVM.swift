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
    var solAddressList : [String] { get set }
    var oneAddressList : [String] { get set }
    var maticAddressList : [String] { get set }
    var bscAddressList : [String] { get set }
    
    var solTransactions : [TransactionInfo] { get set }
    var oneTransactions : [TransactionInfo] { get set }
    var maticTransactions : [TransactionInfo] { get set }
    var bscTransactions : [TransactionInfo] { get set }
    
    var solSignatures : [String] { get set }
    //var oneSignatures : [String] { get set }
    //var maticSignatures : [String] { get set }
    
    var totalSol : String { get set }
    var totalOne : String { get set }
    var totalMatic : String { get set }
    var totalBsc : String { get set }
    
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
}

class HomeVM : HomeViewModelProtocol {

    @Published var isOnline: Bool = true
    @Published var solCoins: [CoinInfo] = []
    @Published var oneCoins: [CoinInfo] = []
    @Published var maticCoins: [CoinInfo] = []
    @Published var bscCoins: [CoinInfo] = []
    @Published var solAddressList: [String] = []
    @Published var oneAddressList: [String] = []
    @Published var maticAddressList: [String] = []
    @Published var bscAddressList: [String] = []
    @Published var tempCoins: [CoinInfo] = []
    @Published var solTransactions: [TransactionInfo] = []
    @Published var oneTransactions: [TransactionInfo] = []
    @Published var maticTransactions: [TransactionInfo] = []
    @Published var bscTransactions: [TransactionInfo] = []
    @Published var solSignatures: [String] = []
    //@Published var oneSignatures: [String] = []
    //@Published var maticSignatures: [String] = []
    @Published var totalSol: String = ""
    @Published var totalOne: String = ""
    @Published var totalMatic: String = ""
    @Published var totalBsc: String = ""
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
        
        mainQueue = [GTEXT.SOLANA, GTEXT.HARMONY, GTEXT.POLYGON, GTEXT.BINANCE]
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
            if total < 1 {
                totalSol = String(format: "%.4f", total)
            }
            else if total >= 1 && total < 10 {
                totalSol = String(format: "%.4f", total)
            }
            else if total >= 10 && total < 100 {
                totalSol = String(format: "%.3f", total)
            }
            else if total >= 100 && total < 1000 {
                totalSol = formatNumber(num: String(format: "%.3f", total))
            }
            else if total >= 1000 && total < 10000 {
                totalSol = formatNumber(num: String(format: "%.2f", total))
            }
            else if total >= 10000 && total < 100000 {
                totalSol = formatNumber(num: String(format: "%.1f", total))
            }
            else if total >= 100000 && total < 1000000000 {
                totalSol = formatNumber(num: String(format: "%.0f", total))
            }
            else {
                totalSol = String(format: "%.0f+ bil", total / 1000000000)
            }
        }
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
                //print("back here !!!! \(data)")
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
            if total < 1 {
                totalOne = String(format: "%.4f", total)
            }
            else if total >= 1 && total < 10 {
                totalOne = String(format: "%.4f", total)
            }
            else if total >= 10 && total < 100 {
                totalOne = String(format: "%.3f", total)
            }
            else if total >= 100 && total < 1000 {
                totalOne = formatNumber(num: String(format: "%.3f", total))
            }
            else if total >= 1000 && total < 10000 {
                totalOne = formatNumber(num: String(format: "%.2f", total))
            }
            else if total >= 10000 && total < 100000 {
                totalOne = formatNumber(num: String(format: "%.1f", total))
            }
            else if total >= 100000 && total < 1000000000 {
                totalOne = formatNumber(num: String(format: "%.0f", total))
            }
            else {
                totalOne = String(format: "%.0f+ bil", total / 1000000000)
            }
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
                    self.mainQueue = self.mainQueue.filter(){$0 != GTEXT.POLYGON}
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
            if total < 1 {
                totalMatic = String(format: "%.4f", total)
            }
            else if total >= 1 && total < 10 {
                totalMatic = String(format: "%.4f", total)
            }
            else if total >= 10 && total < 100 {
                totalMatic = String(format: "%.3f", total)
            }
            else if total >= 100 && total < 1000 {
                totalMatic = formatNumber(num: String(format: "%.3f", total))
            }
            else if total >= 1000 && total < 10000 {
                totalMatic = formatNumber(num: String(format: "%.2f", total))
            }
            else if total >= 10000 && total < 100000 {
                totalMatic = formatNumber(num: String(format: "%.1f", total))
            }
            else if total >= 100000 && total < 1000000000 {
                totalMatic = formatNumber(num: String(format: "%.0f", total))
            }
            else {
                totalMatic = String(format: "%.0f bil", total / 1000000000)
            }
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
                    self.mainQueue = self.mainQueue.filter(){$0 != GTEXT.BINANCE}
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
            if total < 1 {
                totalBsc = String(format: "%.4f", total)
            }
            else if total >= 1 && total < 10 {
                totalBsc = String(format: "%.4f", total)
            }
            else if total >= 10 && total < 100 {
                totalBsc = String(format: "%.3f", total)
            }
            else if total >= 100 && total < 1000 {
                totalBsc = formatNumber(num: String(format: "%.3f", total))
            }
            else if total >= 1000 && total < 10000 {
                totalBsc = formatNumber(num: String(format: "%.2f", total))
            }
            else if total >= 10000 && total < 100000 {
                totalBsc = formatNumber(num: String(format: "%.1f", total))
            }
            else if total >= 100000 && total < 1000000000 {
                totalBsc = formatNumber(num: String(format: "%.0f", total))
            }
            else {
                totalBsc = String(format: "%.0f bil", total / 1000000000)
            }
        }
    }
}
