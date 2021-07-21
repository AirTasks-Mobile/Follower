//
//  ViewState.swift
//  Followers
//
//  Created by JEREMY NGUYEN on 19/07/2021.
//

import Foundation

struct LobbyState {
    var isOK : Bool
}

struct HomeState {
    var pigeon : [String:String]?
    var sparrows : [String:String]?
    var visitedStates : [String:String]?
    var ownedStates : [String: String]?
    
    var clearMsg : String?
}

struct LocalState {
    var status : String
}
