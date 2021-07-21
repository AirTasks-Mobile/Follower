//
//  RouteVMUnitTest.swift
//  Followers
//
//  Created by JEREMY NGUYEN on 21/07/2021.
//

import Foundation
import Combine

class RouteVMUnitTest : RouteViewModelProtocol {
    var isPigeon: Bool
    
    func startPigeon() {
        
    }
    
    var isOnline: Bool
    
    var isHome: Bool
    
    var isScanQR: Bool
    
    var isState: Bool
    
    init(isOnline : Bool, isHome: Bool, isScanQR: Bool, isState: Bool) {
        self.isOnline = isOnline
        self.isHome = isHome
        self.isScanQR = isScanQR
        self.isState = isState
        
        self.isPigeon = false
    }
    
    func backHome() {
        //
    }
    
    func startScanQR() {
        //
    }
    
    func startState() {
        //
    }
    
    
}
