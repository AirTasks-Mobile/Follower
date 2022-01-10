//
//  StaticText.swift
//  Followers
//
//  Created by JEREMY NGUYEN on 02/01/2022.
//

import Foundation

struct GTEXT {
    static let USER_ID = "user_id"
    
    static let POLYGON = "MATIC"
    static let SOLANA = "SOL"
    static let HARMONY = "ONE"
    static let BINANCE = "BSC"
    static let ETHEREUM = "ETH"
    static let STELLAR = "XLM"
    
    static let SOL_LIST = "sol_list"
    static let MATIC_LIST = "matic_list"
    static let ONE_LIST = "one_list"
    static let BSC_LIST = "bsc_list"
    static let ETH_LIST = "eth_list"
    static let XLM_LIST = "xlm_list"
    
    static let TXN_TRANSFER = "TRANSER"
    static let TXN_STAKE = "STAKE"
    static let TXN_LIQUIDITY = "LIQUIDITY"
    static let TXN_UNSTAKE = "UNSTAKE"
    static let TXN_STAKE_REWARD = "STAKE_REWARD"
    static let TXN_STAKE_WITDRAW = "WITHDRAW"
    
    static let ONE_ROUND : Double = 1000000000000000000
    static let SOL_ROUND : Double = 1000000000
    static let ETH_ROUND : Double = 1000000000000000000
    static let XLM_ROUND : Double = 10000000
    static let MAX_TRANSACTION = 200    // Stellar
    static let MAX_LIST = 500           // Stellar, Harmony
    static let BLOCK_TRANSACTION = 200  // Stellar, Harmony
    static let COIN_MAX_TXN =  100      // Solana load one by one and slow, so load 100 transactions first
    static let COIN_TXN_BLOCK = 50      // Solna every next attempt, load 50 transactin
 
    
    // SOL
    static let SOL_STAKE_ACC = "Stake11111111111111111111111111111111111111"
    static let SOL_TRANSER_ACC = "11111111111111111111111111111111"
    static let SOL_RENT_ACC = "SysvarRent111111111111111111111111111111111"
    // ONE
    
    //STELLAR
    static let XLM_ASSET = "native"
    static let XLM_TYPE_XPAY = "path_payment_strict_send"
    static let XLM_TYPE_PAY = "payment"
    static let XLM_TYPE_CREATE_CLAIM = "create_claimable_balance"
    static let XLM_TYPE_CREATE_ACCOUNT = "create_account"
    static let XLM_TYPE_DELETE_ACCOUNT = "account_merge"
    
}
