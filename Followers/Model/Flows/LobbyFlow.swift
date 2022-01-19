//
//  LobbyFlow.swift
//  Followers
//
//  Created by JEREMY NGUYEN on 19/07/2021.
//

import Foundation
import Combine

class LobbyFlow : BaseFlow {
    var id : String = ""
    var userID : String = ""
    
    override func onStart() -> Bool {
        if viewInfo.isEmpty{
            
        }
        
        userID = viewInfo["user_id"] ?? "new_user"
        //userID = "20210723130105fNQUhpfNR1RvcgX1KyzFykqJeAB8ONcKpHy0Vwci4"
        //print("current user id \(userID)")
        id = viewInfo["device_id"] ?? ""
        
        let current_id = NSUUID().uuidString
        //print("current device id \(current_id)")
        
        if id == "" {
            id = current_id
            UserDefaults.standard.setValue(current_id, forKey: "device_id")
        }
        else if id != current_id {
            //print("different device id")
            UserDefaults.standard.setValue(current_id, forKey: "device_id")
        }
        
        //print("id= \(id)")
        return true
    }
    
    override func onEnd(info: FlowModel) {
        //
        //print("store this token \(info.token ?? "")")
        print(" received user id = \(info.userID ?? "")")
        let id = info.userID
        
        if id != "" || id != "new_user" || id != "old_user" || id != "welcome_back" || id != userID {
            UserDefaults.standard.set(id, forKey: "user_id")
        }
    }
    
    override func onExecute() -> AnyPublisher<FlowModel, FlowError> {
        let connectHost = InfoApi(info: FlowModel(type: FLOW.NORMAL, deviceID: id, userID: userID))
        return connectHost.connectHost()
            .map{ apiData -> FlowModel in
                return self.convertApiToFlow(info: apiData)
            }
            .eraseToAnyPublisher()
    }
  
    func convertApiToFlow(info: ResInfo) -> FlowModel{

        
        return FlowModel(isSuccess: true, message: "a")
    }
}
