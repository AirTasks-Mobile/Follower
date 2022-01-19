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
    var assets : [AssetInfo]?
    
    static let `default` = CoinInfo(type: "", id: "", nick: "..", pic: "", bal: "...", date: "")
}

struct TransactionInfo : Hashable, Codable {
    var type : String
    var id : String
    var count : Int?
    var amt : String
    var src : String
    var des : String
    var date : String
    var fee : String               // Stellar source asset type
    var status : String            // Stellar source asset code
    var scheme : String
    var reward : String?        // Stellar asset type
    var commission : String?    // Stellar asset code
    var stake : StakeAccountInfo?
    var liquidity : LiquidityAccountInfo?
    var validator : ValidatorInfo?
    
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

struct AssetInfo : Hashable, Codable {
    var type : String
    var code : String
    var balance : String?
    var isOk : Bool?
    var issuer : String?
    static let `default` = AssetInfo(type: "", code: "", isOk: false, issuer: "")
}

struct ValidatorInfo : Hashable, Codable {
    var active : String?
    var address : String?
    var details : String?
    var name : String?
    var rate : String?
    var maxRate : String?
    var website : String?
    var stake : String?
    var votingPowerAdjusted : String?
    var shardId : Int?
    var status : String?
    
    static let `default` = ValidatorInfo(active: "", address: "", details: "", name: "", rate: "", website: "", stake: "", votingPowerAdjusted: "", shardId: 0)
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

struct ONEVoting : Codable, Hashable {
    var effectiveStake : Double?
    var shardId : Int?
    var votingPowerAdjusted : String?
    
    enum CodingKeys : String, CodingKey {
        case effectiveStake = "effective-stake"
        case shardId = "shard-id"
        case votingPowerAdjusted = "voting-power-adjusted"
    }
}

struct OneValidator : Codable, Hashable {
    var address : String?
    var details : String?
    var name : String?
    var rate : String?
    var website : String?
    var maxRate : String?
    
    enum CodingKeys : String, CodingKey {
        case address
        case details
        case name
        case rate
        case website
        case maxRate = "max-rate"
    }
}

struct OneValidatorResult : Codable, Hashable {
    var activeStatus : String?
    var eposStatus : String?
    var eposWinningStake : String?
    var totalStake : Double?
    //var currentEpochVotingPower : ONEVoting?
    var validator : OneValidator?
    
    enum CodingKeys : String, CodingKey {
        case activeStatus = "active-status"
        //case currentEpochVotingPower = "current-epoch-voting-power"
        case validator
        case eposStatus = "epos-status"
        case eposWinningStake = "epos-winning-stake"
        case totalStake = "total-delegation"
    }
}

struct OneError : Codable, Hashable {
    var message : String?
}

// STELLAR
struct XLMLink : Codable, Hashable {
    var href : String?
    var templated : Bool?
}

struct XLMLinks : Codable, Hashable {
    var transactions : XLMLink?
    var payments : XLMLink?
}

struct XLMBalance : Codable, Hashable {
    var balance : String
    var is_authorized : Bool?
    var is_clawback_enabled : Bool?
    var asset_type : String?
    var asset_code : String?
}

struct XLMOpLinks : Codable, Hashable {
    var next : XLMLink?
    var prev : XLMLink?
}

struct XLMClaimant : Codable, Hashable {
    var destination : String?
}

struct XLMPath : Codable, Hashable {
    var asset_type : String?
    var asset_code : String?
    var asset_issuer : String?
}

struct XLMRecord : Codable, Hashable {
    var id : String?
    var transaction_successful : Bool?
    var source_account : String?
    var type : String?
    var created_at : String?
    var asset : String?
    var asset_type : String?
    var asset_code : String?
    var amount : String?
    var source_amount : String?
    var source_asset_code : String?
    var source_asset_type : String?
    var to : String?
    //var path : [XLMPath]? // no need this, just don't care about this
    // var claimants : [XLMClaimant]? // no need this, check source_aacount is enough
    
    var account : String?
    var into : String?
    
    var starting_balance : String?
}

struct XLMOpRecord : Codable, Hashable {
    var records : [XLMRecord]?
}


