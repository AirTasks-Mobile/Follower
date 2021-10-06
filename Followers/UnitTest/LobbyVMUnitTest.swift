//
//  LobbyVMUnitTest.swift
//  Followers
//
//  Created by JEREMY NGUYEN on 19/07/2021.
//

import Foundation
import Combine

class LobbyVMUnitTest : LobbyViewModelProtocol {
    var deviceID: String
    
    @Published var userID: String
    
    @Published var isOk: Bool
    @Published var isProcessing: Bool
    
    
    init(isOk: Bool, isProcessing: Bool){
        self.isOk = isOk
        self.isProcessing = isProcessing
        
        userID = ""
        deviceID = ""
    }
    
    func startLogIn() {
        //
    }
    
    func startLogOut() {
        //
    }
}
