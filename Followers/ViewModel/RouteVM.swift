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
    var isState : Bool { get set }
    var isPigeon : Bool { get set }
    
    func backHome()
    func startScanQR()
    func startState()
    func startPigeon()
}

class RouteVM : RouteViewModelProtocol {
    @Published var isOnline: Bool = true
    @Published var isHome: Bool = true
    @Published var isScanQR: Bool = false
    @Published var isState: Bool = false
    @Published var isPigeon: Bool = false

    func backHome() {
        isHome = true
        
        isScanQR = false
        isState = false
        isPigeon = false
    }
    
    func startScanQR() {
        isHome = false
        isScanQR = true
    }
    
    func startState() {
        isHome = false
        isState = true
    }
    
    func startPigeon() {
        isHome = false
        isPigeon = true
    }
}
