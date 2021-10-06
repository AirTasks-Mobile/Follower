//
//  HomeVMUnitTest.swift
//  Followers
//
//  Created by JEREMY NGUYEN on 19/07/2021.
//

import Foundation
import Combine

class HomeVMUnitTest : HomeViewModelProtocol {
    var secretMsg: String
    
    func getSecretMsg(info: String) {
        //
    }
    
    var isOnline: Bool
    
    var pigeon: [String : String]
    
    var sparrows: [String : String]
    
    var visitedStates: [String : String]
    
    var ownedStates: [String : String]
    
    var clearMsg: String
    
    init(isOnline: Bool, pigeon: [String:String], sparrows:[String:String], vState: [String:String], oState: [String:String], clearMsg: String) {
        //
        self.isOnline = isOnline
        self.pigeon = pigeon
        self.sparrows = sparrows
        self.visitedStates = vState
        self.ownedStates = oState
        self.clearMsg = clearMsg
        
        secretMsg = ""
    }
    
    func fetchInfo() {
        //
    }
    
    func fetchVisitedStates() {
        //
    }
    
    func fetchOwnedStates() {
        //
    }
    
    func updatePigeon(info: [String : String]) {
        //
    }
    
    func updateSparrows(info: [String : String]) {
        //
    }
    
    func getClearMsg(info: String) {
        //
    }
}
