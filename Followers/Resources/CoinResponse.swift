//
//  CoinResponse.swift
//  Followers
//
//  Created by JEREMY NGUYEN on 02/01/2022.
//

import Foundation

struct CoinInfo : Hashable, Codable {
    var type : String
    var id : String
    var nick : String
    var pic : String
    var bal : String
    var date : String
    var stakes : [StakeAccountInfo]?
    var liquidities : [LiquidityAccountInfo]?
    
    static let `default` = CoinInfo(type: "", id: "", nick: "..", pic: "", bal: "...", date: "")
}

struct TransactionInfo : Hashable, Codable {
    var type : String
    var id : String
    var amt : String
    var src : String
    var des : String
    var date : String
    var fee : String
    var status : String
    var scheme : String
    var reward : String?
    var commission : String?
    var stake : StakeAccountInfo?
    var liquidity : LiquidityAccountInfo?
    
    static let `default` = TransactionInfo(type: "", id: "", amt: "",src: "", des: "" ,date: "", fee: "", status: "", scheme: "",reward: "", commission: "")
}
struct UnStakeInfo : Hashable, Codable {
    var id : String?
    var amt : String?
    var date : String?
    
    static let `default` = UnStakeInfo(id: "", amt: "", date: "")
}
struct StakeAccountInfo : Hashable, Codable {
    var scheme : String
    var src : String
    var des : String
    var deposit : String
    var date : String?
    var epoch : String?
    var fee : String?
    var unstakes : [UnStakeInfo]?
    
    static let `default` = StakeAccountInfo(scheme: "", src: "", des: "", deposit: "", date: "", epoch: "", fee: "")
}

struct LiquidityAccountInfo : Hashable, Codable {
    var scheme : String
    var src : String
    var des : String
    var deposit : String
    var date : String?
    var epoch : String?
    var fee : String?
    
    static let `default` = LiquidityAccountInfo(scheme: "", src: "", des: "", deposit: "", date: "", epoch: "", fee: "")
}

// SOL

struct SOLContext : Codable, Hashable {
    var slot : Int
}

struct SOLResult : Codable, Hashable {
    var context : SOLContext?
    var value : Double? // here ?????
}

struct SOLMulResult : Codable, Hashable {
    var context : SOLContext?
    var value : [SOLValue]?
}

struct SOLValue : Codable, Hashable {
    var data : [String]?
    var executable : Bool?
    var lamports : Int?
    var owner : String?
    var rentEpoch : Int?
    
    static let `default` = SOLValue(data: [""], executable: false, lamports: 1, owner: "", rentEpoch: 1)
}

struct SOLSignatureResult : Codable, Hashable {
    var blockTime : Int?
    var confirmationStatus : String?
    var signature : String?
    var slot : Int?
}

struct SOLTransactionDetailResult : Codable, Hashable {
    var blockTime : Int?
    var meta : SOLMeta?
    var slot : Int?
    var transaction : SOLTransaction?
}

struct SOLMeta : Codable, Hashable {
    var fee : Double? // here
    var postBalances : [Double]? // here
    var preBalances : [Double]? // here
    var rewards : [Double]?  // here
}

struct SOLTransaction : Codable, Hashable {
    var message : SOLMessage?
}

struct SOLMessage : Codable, Hashable {
    var accountKeys : [String]?
}

struct SOLReward : Codable, Hashable {
    var amount : Double? // here
    var commission : Int?
    var epoch : Int?
    var postBalance : Double? // here
}

// ONE
struct ONETxs : Codable, Hashable {
    var id : String?
    var timestamp : String?
    var from : String?
    var to : String?
    var value : Double? // here
    var type: String?
}

struct ONETransaction : Codable, Hashable {
    var from : String?
    var gas : Int? 
    var gasPrice : Double? // here
    var hash : String?
    var shardID : Int?
    var timestamp : Int?
    var to : String?
    var toShardID : Int?
    var value : Double?
}

struct ONEResult : Codable, Hashable {
    var transactions : [ONETransaction]?
}

struct ONEStakeResult : Codable, Hashable {
    var validator_address : String?
    var delegator_address : String?
    var Undelegations : [ONEUndelegations?]
    var amount : Double?
    var reward : Double?
}

struct ONEUndelegations : Codable, Hashable {
    var Amount : Double?
    var Epoch : Int?
}
// MATIC

