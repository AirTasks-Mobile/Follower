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
    
    var clearMsg : String {get set}
    
    func fetchInfo()
    func fetchVisitedStates()
    func fetchOwnedStates()
    
    func updatePigeon(info: [String:String])
    func updateSparrows(info: [String:String])
    
    func getClearMsg(info: String)
}

class HomeVM : HomeViewModelProtocol {
    @Published var isOnline: Bool = true
    
    @Published var pigeon: [String : String] = [:]
    @Published var sparrows: [String : String] = [:]
    @Published var visitedStates: [String : String] = [:]
    @Published var ownedStates: [String : String] = [:]
    
    @Published var clearMsg: String = ""
    
    private var task : AnyCancellable?
    
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
        clearMsg = ""
        
        let flow = GetClearMsg()
        flow.setViewInfo(info: ["clearMsg" : info])
        
        task = flow.processFlow()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { result in
                print("get clear msg resut \(result)")
                switch result {
                case .finished:
                    break
                case .failure(.SERVER):
                    self.clearMsg = "[server error]"
                    break
                default:
                    self.clearMsg = "[error]"
                    break
                }
            }, receiveValue: { value in
                let msg : String = value.clearMsg ?? ""
                print("get clear msg value \(msg)")
                if msg != ""
                {
                    self.clearMsg = msg
                }
            })
    }
}
