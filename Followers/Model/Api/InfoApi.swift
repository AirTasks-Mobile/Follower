//
//  InfoApi.swift
//  Followers
//
//  Created by JEREMY NGUYEN on 19/07/2021.
//

import Foundation
import Foundation
import Combine

protocol ApiInterface {
    func getURLRequest() -> URLRequest
    func setupNetwork() -> Void
    func buildPayload() -> Data
    func connectHost<T: Decodable>() -> AnyPublisher<T, FlowError>
}

struct ResInfo : Decodable {
    var payload : String?
    var res_sec : String?
}

struct SOLRespone : Decodable {
    var jsonrpc : String?
    var params : [String]?
    var result : SOLResult?
    var value : SOLValue?
    var id : Int32
}

struct SOLResponeGetBalance : Decodable {
    var jsonrpc : String
    var result : SOLResult
    var id : Int32
}

struct SOLResponeGetTokenBalance : Decodable {
    var jsonrpc : String
    var result : SOLTokenResult?
    var id : Int32
}

struct SOLResponeMulAcc : Decodable {
    var jsonrpc : String?
    var result : SOLMulResult?
    var id : Int32
}

struct SOLResponeGetSignatureInfo : Decodable {
    var jsonrpc : String?
    var result : [SOLSignatureResult]?
    var id : Int32
}

struct SOLResponseGetTransactionDetail : Decodable {
    var jsonrpc : String?
    var result : SOLTransactionDetailResult?
    var id : Int32
}

struct SOLResponseStake : Decodable {
    var jsonrpc : String?
    var result : [SOLReward?]
    var id : Int32
}

// One
struct ONEResponseGetBalance : Decodable {
    var jsonrpc : String?
    var id : String?
    var result : Double?
    var error : OneError?
}

struct ONEResponseGeAddress : Decodable {
    var balance : Double?
    var id : String?
    var txs : [ONETxs]?
}

struct ONEResponseGetTransaction : Decodable {
    var jsonrpc : String?
    var id : String?
    var result : ONEResult?
}

struct ONEResponseGetStake : Decodable {
    var jsonrpc : String?
    var id : String?
    var result : [ONEStakeResult]?
}

struct ONEResponseValidator : Decodable {
    var jsonrpc : String?
    var id : String?
    var result : OneValidatorResult?
}
// ETH
struct ETHResponseBalance : Decodable {
    var id : Int?
    var result : String
}

// Stellar
struct XLMResponseAccount : Codable, Hashable {
    var _links : XLMLinks?
    var id : String?
    var account_id : String?
    var last_modified_time : String?
    var balances : [XLMBalance?]
}

struct XLMResponseOperation : Codable, Hashable {
    var _links : XLMOpLinks?
    var _embedded : XLMOpRecord?
}

class InfoApi : ApiInterface {
    var info : FlowModel?
    
    init(info: FlowModel){
        self.info = info
    }
    func getURL() -> URL {
    
        //let solMainnet = "https://api.mainnet-beta.solana.com"
        //let solDevnet = "https://api.devnet.solana.com"
        let solMainnet = "http://127.0.0.1:8899" // localhost
        
        let oneMainnet = "https://api.harmony.one"
        //let oneDevnet = "https://api.s0.pops.one"
        
        //let binanceMainnet = "https://api.binance.com"
        let bscMainnent = "https://bsc-dataseed.binance.org"
        
        let maticMainnet = "https://polygon-rpc.com"
        
        let ethAchemyMainnet = "https://eth-mainnet.alchemyapi.io/v2/tBdd0HrN3GLMirZ04eBnKPCOOuBml7HF"
        // achemy websocket : wss://eth-mainnet.alchemyapi.io/v2/tBdd0HrN3GLMirZ04eBnKPCOOuBml7HF
        
        let xlmMainnet = "https://horizon.stellar.org"
        
        switch info?.type {
            case .GET_SOL_BALANCE:
                return URL(string: solMainnet)!
            case .GET_SOL_ACC_INFO:
                return URL(string: solMainnet)!
            case .GET_SOL_TXN_INFO:
                return URL(string: solMainnet)!
            case .GET_SOL_STAKE_INFO:
                return URL(string: solMainnet)!
            case .GET_SOL_TOKEN_BALANCE:
                return URL(string: solMainnet)!
            case .GET_ONE_BALANCE:
                return URL(string: oneMainnet)!
            case .GET_ONE_ACC_INFO:
                //let oneId = info?.token ?? ""
                //let getInfoMainnet = "https://api.harmony.one/address?id=\(oneId)&tx_view=ALL"
                return URL(string: oneMainnet)!
            case .GET_ONE_VALIDATOR_INFO:
                return URL(string: oneMainnet)!
            case .GET_ONE_STAKE_INFO:
                return URL(string: oneMainnet)!
            case .GET_MATIC_BALANCE:
                return URL(string: maticMainnet)!
            case .GET_BSC_BALANCE:
                return URL(string: bscMainnent)!
            case .GET_ETH_BALANCE:
                return URL(string: ethAchemyMainnet)!
            case .GET_STELLAR_ACCOUNT:
                let xlmId = info?.token ?? ""
                let xlmEndpoint = "\(xlmMainnet)/accounts/\(xlmId)"
                return URL(string: xlmEndpoint)!
            case .GET_STELLAR_OPERATION:
                let xlmId = info?.token ?? ""
                let cur = info?.cursor ?? ""
                var xlmEndpoint : String
                if cur != "" && cur != " " {
                    xlmEndpoint = "\(xlmMainnet)/accounts/\(xlmId)/operations?limit=200&order=desc&cursor=\(cur)&include_failed=false"
                }
                else {
                    xlmEndpoint = "\(xlmMainnet)/accounts/\(xlmId)/operations?limit=200&order=desc&include_failed=false"
                }

                return URL(string: xlmEndpoint)!
            default:
                break
        }
     
        return URL(string: "")!
    }
    
    func getMethod() -> String {
        if info?.type == .GET_STELLAR_ACCOUNT || info?.type == .GET_STELLAR_OPERATION {
            return "GET"
        }
        return "POST"
    }
    
    func getURLRequest() -> URLRequest {
        let url = getURL()
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = getMethod()
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        return urlRequest
    }
    
    func setupNetwork() {
        //
    }
    
    func buildPayload() -> Data {
        //print("build payload \(info?.secretMsg)")
        let build = BuildMsg(info: info!)
        
        return build.getRequestMsg()!
    }
    
    
    func connectHost<T: Decodable>() -> AnyPublisher<T, FlowError> {
        var request = getURLRequest()
        if info?.type == .GET_STELLAR_ACCOUNT || info?.type == .GET_STELLAR_OPERATION {
            // no body for GET
            //print("request = \(request)")
        }
        else {
            request.httpBody = buildPayload()
        }
     
        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap{ output in
                guard let res = output.response as? HTTPURLResponse, (200...299).contains(res.statusCode) else {
                    //print("res = \(output.response)")
                    throw FlowError.FAIL
                }
               
                //print("JSON response : \(String(data: output.data, encoding: .utf8))")
                return output.data
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .mapError{ error -> FlowError in
                print("error = \(error.localizedDescription)")
                return FlowError.FAIL
            }
            .eraseToAnyPublisher()
    }
    
}
