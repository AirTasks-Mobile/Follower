//
//  HomeVMUnitTest.swift
//  Followers
//
//  Created by JEREMY NGUYEN on 19/07/2021.
//

import Foundation
import Combine

class HomeVMUnitTest : HomeViewModelProtocol {
    var isOnline: Bool
    
    var pigeon: [String : String]
    
    var sparrows: [String : String]
    
    var visitedStates: [String : String]
    
    var ownedStates: [String : String]
    
    init(isOnline: Bool, pigeon: [String:String], sparrows:[String:String], vState: [String:String], oState: [String:String]) {
        //
        self.isOnline = isOnline
        self.pigeon = pigeon
        self.sparrows = sparrows
        self.visitedStates = vState
        self.ownedStates = oState
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
    
    
}
