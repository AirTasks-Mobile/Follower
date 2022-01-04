//
//  LobbyVM.swift
//  Followers
//
//  Created by JEREMY NGUYEN on 19/07/2021.
//

import Foundation
import Combine

protocol LobbyViewModelProtocol : ObservableObject {
    var isOk : Bool { get set }
    var isProcessing: Bool { get set }
    var userID : String { get set }
    var deviceID : String { get set }
    
    func startLogIn()
    func startLogOut()
}

class LobbyVM : LobbyViewModelProtocol {
    @Published var isOk: Bool = false
    @Published var isProcessing: Bool = false
    
    @Published var userID: String = UserDefaults.standard.string(forKey: "user_id") ?? ""
    @Published var deviceID: String = UserDefaults.standard.string(forKey: "device_id") ?? ""
    
    private var task : AnyCancellable?
    
    func startLogIn() {
        isProcessing = true
        
        if isProcessing {
            isOk = true // testtttttt
            isProcessing = false
            return
        }
        
        let flow = LobbyFlow()
        flow.setViewInfo(info: ["user_id": userID, "device_id": deviceID])
        task = flow.processFlow()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished :
                    break
                default:
                    self.isProcessing = false
                    break
                }
                
                
                
            }, receiveValue: { value in
                let isOK = value.isSuccess
                let user = value.userID ?? ""
                
                self.isOk = isOK
                self.isProcessing = false
                
                if user != "" && user != "new_user" && user != "old_user" && user != self.userID {
                    self.userID = user
                }
            })
    }
    
    func startLogOut() {
        isOk = false
        isProcessing = false
    }
}
