//
//  RouteVMUnitTest.swift
//  Followers
//
//  Created by JEREMY NGUYEN on 21/07/2021.
//

import Foundation
import Combine

class RouteVMUnitTest : RouteViewModelProtocol {
    var isXlm: Bool
    
    func startXlm() {
        //
    }
    
    var isEth: Bool
    
    func startEth() {
        //
    }
    
    var isBsc: Bool
    
    func startBsc() {
        //
    }
    
    var isAbout: Bool
    
    func startAbout() {
        //
    }
    
    var isSol: Bool
    
    var isOne: Bool
    
    var isMatic: Bool
    
    func startScanQR() {
        //
    }
    
    func startSol() {
        //
    }
    
    func startOne() {
        //
    }
    
    func startMatic() {
        //
    }
    

    var isOnline: Bool
    
    var isHome: Bool
    
    var isScanQR: Bool
    
    
    init(isOnline : Bool) {
        self.isOnline = isOnline
        self.isHome = false
        isScanQR = false
        isMatic = false
        isOne = false
        isSol = false
        isAbout = false
        isBsc = false
        isEth = false
        isXlm = false
    }
    
    func backHome() {
        //
    }
    

    
}
