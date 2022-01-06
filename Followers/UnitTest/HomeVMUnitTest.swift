//
//  HomeVMUnitTest.swift
//  Followers
//
//  Created by JEREMY NGUYEN on 19/07/2021.
//

import Foundation
import Combine

class HomeVMUnitTest : HomeViewModelProtocol {
    
    var bscCoins: [CoinInfo]
    
    var bscAddressList: [String]
    
    var bscTransactions: [TransactionInfo]
    
    var totalBsc: String
    
    func startBsc() {
        //
    }
    
    func storeBsc(id: String, nick: String) {
        //
    }
    
    func fetchSolStake(sol: [StakeAccountInfo]) {
        //
    }

    func getOneStake(id: String) {
        //
    }
    
    var mainQueue: [String]
    
    var totalSol: String
    
    var totalOne: String
    
    var totalMatic: String
    
    func fetchSolTxnDetail() {
        //
    }
    
    
    func fetchMaticTxnDetail() {
        //
    }
    
    var maticTransactions: [TransactionInfo]
    
    var solSignatures: [String]
    
    
    func startOne() {
        //
    }
    
    func storeOne(id: String, nick: String) {
        //
    }
    
    func getOneTxn(id: String) {
        //
    }
    
    func startMatic() {
        //
    }
    
    func storeMatic(id: String, nick: String) {
        //
    }
    
    func getMaticTxn(id: String) {
        //
    }
    
    func getSolTxn(id: String) {
        //
    }
    
    var solTransactions: [TransactionInfo]
    
    var oneTransactions: [TransactionInfo]
    
    
    func startHome() {
        //
    }
    
    
    var solAddressList: [String]
    
    var oneAddressList: [String]
    
    var maticAddressList: [String]
    
    func startSol() {
        //
    }
    
    func storeSol(id: String, nick: String) {
        //
    }
    
    var oneCoins: [CoinInfo]
    
    var maticCoins: [CoinInfo]
    
    var solCoins: [CoinInfo]
    
    
    var isOnline: Bool
 
    
    init(isOnline: Bool) {
        self.isOnline = isOnline
        
        solCoins = [CoinInfo.default, CoinInfo.default]
        oneCoins = [CoinInfo.default, CoinInfo.default]
        maticCoins = [CoinInfo.default, CoinInfo.default]
        bscCoins = [CoinInfo.default, CoinInfo.default]
        
        solAddressList = [""]
        oneAddressList = [""]
        maticAddressList = [""]
        bscAddressList = [""]
        
        solTransactions = [TransactionInfo.default]
        oneTransactions = [TransactionInfo.default]
        maticTransactions = [TransactionInfo.default]
        bscTransactions = [TransactionInfo.default]
        
        solSignatures = [""]
        //oneSignatures = [""]
        //maticSignatures = [""]
        
        totalOne = ""
        totalSol = ""
        totalMatic = ""
        totalBsc = ""
        
        mainQueue = [""]
    }

}
