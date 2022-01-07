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
    var result : Double
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

// ETH
struct ETHResponseBalance : Decodable {
    var id : Int?
    var result : String
}

class InfoApi : ApiInterface {
    var info : FlowModel?
    
    init(info: FlowModel){
        self.info = info
    }
    func getURL() -> URL {
        let url = "http://192.168.1.103:5000/api"
        let solMainnet = "https://api.mainnet-beta.solana.com"
        //let solDevnet = "https://api.devnet.solana.com"
        //let solLocal = "http://localhost:8899"
        
        let oneMainnet = "https://api.harmony.one"
        //let oneDevnet = "https://api.s0.pops.one"
        
        //let binanceMainnet = "https://api.binance.com"
        let bscMainnent = "https://bsc-dataseed.binance.org"
        
        let maticMainnet = "https://polygon-rpc.com"
        
        let ethAchemyMainnet = "https://eth-mainnet.alchemyapi.io/v2/tBdd0HrN3GLMirZ04eBnKPCOOuBml7HF"
        // achemy websocket : wss://eth-mainnet.alchemyapi.io/v2/tBdd0HrN3GLMirZ04eBnKPCOOuBml7HF
        
        
        switch info?.type {
            case .NORMAL:
                return URL(string: url + "/check_in")!
            case .GET_CLEAR_MSG:
               return URL(string: url + "/secure")!
            case .GET_SECRET_MSG:
                return URL(string: url + "/secure")!
            case .GET_SOL_BALANCE:
                return URL(string: solMainnet)!
            case .GET_SOL_ACC_INFO:
                return URL(string: solMainnet)!
            case .GET_SOL_TXN_INFO:
                return URL(string: solMainnet)!
            case .GET_SOL_STAKE_INFO:
                return URL(string: solMainnet)!
            case .GET_ONE_BALANCE:
                return URL(string: oneMainnet)!
            case .GET_ONE_ACC_INFO:
                //let oneId = info?.token ?? ""
                //let getInfoMainnet = "https://api.harmony.one/address?id=\(oneId)&tx_view=ALL"
                return URL(string: oneMainnet)!
            case .GET_ONE_STAKE_INFO:
                return URL(string: oneMainnet)!
            case .GET_MATIC_BALANCE:
                return URL(string: maticMainnet)!
            case .GET_BSC_BALANCE:
                return URL(string: bscMainnent)!
        case .GET_ETH_BALANCE:
            return URL(string: ethAchemyMainnet)!
            default:
                break
        }
        
        return URL(string: url + "/mock_clear")!
    }
    
    func getMethod() -> String {
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
        request.httpBody = buildPayload()
     
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
                //print("error = \(error.localizedDescription)")
                return FlowError.FAIL
            }
            .eraseToAnyPublisher()
    }
    
}
