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
    var reward : String?
    
    static let `default` = TransactionInfo(type: "", id: "", amt: "",src: "", des: "" ,date: "", fee: "", status: "", reward: "")
}

// SOL

struct SOLContext : Codable, Hashable {
    var slot : Int
}

struct SOLResult : Codable, Hashable {
    var context : SOLContext?
    var value : Int?
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
    var fee : Int?
    var postBalances : [Int]?
    var preBalances : [Int]?
    var rewards : [Int]?
}

struct SOLTransaction : Codable, Hashable {
    var message : SOLMessage?
}

struct SOLMessage : Codable, Hashable {
    var accountKeys : [String]?
}

// ONE
struct ONETxs : Codable, Hashable {
    var id : String?
    var timestamp : String?
    var from : String?
    var to : String?
    var value : Int?
    var type: String?
}

struct ONETransaction : Codable, Hashable {
    var from : String?
    var gas : Int?
    var gasPrice : Int?
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
    var amount : Double?
    var reward : Double?
}

// MATIC

