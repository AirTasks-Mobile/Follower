//
//  RouteVM.swift
//  Followers
//
//  Created by JEREMY NGUYEN on 21/07/2021.
//

import Foundation
import Combine

protocol RouteViewModelProtocol : ObservableObject {
    var isOnline : Bool { get set }
    var isHome : Bool { get set }
    var isScanQR : Bool { get set }
    var isSol : Bool { get set }
    var isOne : Bool { get set }
    var isMatic : Bool { get set }
    var isBsc : Bool { get set }
    var isEth : Bool { get set }
    var isAbout : Bool { get set }
    
    func backHome()
    func startScanQR()
    func startAbout()
    
    func startSol()
    func startOne()
    func startMatic()
    func startBsc()
    func startEth()
}

class RouteVM : RouteViewModelProtocol {
    @Published var isOnline: Bool = true
    @Published var isHome: Bool = true
    @Published var isScanQR: Bool = false
    @Published var isSol: Bool = false
    @Published var isOne: Bool = false
    @Published var isMatic: Bool = false
    @Published var isBsc: Bool = false
    @Published var isEth: Bool = false
    @Published var isAbout: Bool = false

    func backHome() {
        isHome = true
        
        isScanQR = false
        isSol = false
        isOne = false
        isMatic = false
        isAbout = false
        isBsc = false
        isEth = false
    }
    
    func startScanQR() {
        isHome = false
        isScanQR = true
    }
    
    func startAbout() {
        isAbout = true
        isHome = false
    }
    
    func startSol() {
        isHome = false
        isOne = false
        isMatic = false
        
        isSol = true
    }
    
    func startOne() {
        isHome = false
        isSol = false
        isMatic = false
        
        isOne = true
    }
    
    func startMatic() {
        isHome = false
        isSol = false
        isOne = false
        
        isMatic = true
    }
    
    func startBsc() {
        isHome = false
        isSol = false
        isOne = false
        isMatic = false
        
        isBsc = true 
    }
    
    func startEth() {
        isHome = false
        isSol = false
        isOne = false
        isMatic = false
        isBsc = false
        
        isEth = true 
    }
}
