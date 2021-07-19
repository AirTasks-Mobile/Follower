//
//  HomeVM.swift
//  Followers
//
//  Created by JEREMY NGUYEN on 19/07/2021.
//

import Foundation
import Combine

protocol HomeViewModelProtocol : ObservableObject {
    var isOnline : Bool { get set }
    var pigeon : [String:String] { get set }
    var sparrows : [String:String] { get set }
    var visitedStates : [String:String] { get set }
    var ownedStates : [String: String] { get set }
    
    func fetchInfo()
    func fetchVisitedStates()
    func fetchOwnedStates()
    
    func updatePigeon(info: [String:String])
    func updateSparrows(info: [String:String])
}

class HomeVM : HomeViewModelProtocol {
    @Published var isOnline: Bool = true
    
    @Published var pigeon: [String : String] = [:]
    @Published var sparrows: [String : String] = [:]
    @Published var visitedStates: [String : String] = [:]
    @Published var ownedStates: [String : String] = [:]
    
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
