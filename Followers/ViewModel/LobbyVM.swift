//
//  LobbyVM.swift
//  Followers
//
//  Created by JEREMY NGUYEN on 19/07/2021.
//

import Foundation
import Combine

protocol LobbyViewModelProtocol : ObservableObject {
    var isOk : Bool { get set }
    var isProcessing: Bool { get set }
    
    func startLogIn()
    func startLogOut()
}

class LobbyVM : LobbyViewModelProtocol {
    @Published var isOk: Bool = false
    @Published var isProcessing: Bool = false
    
    private var task : AnyCancellable?
    
    func startLogIn() {
        isProcessing = true
        
        let flow = LobbyFlow()
        flow.setViewInfo(info: [:])
        task = flow.processFlow()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished :
                    break
                default:
                    self.isProcessing = false
                    //self.isOk = true // testtttttt
                    break
                }
            }, receiveValue: { value in
                let isOK = value.isOK
                
                self.isOk = isOK
                self.isProcessing = false
            })
    }
    
    func startLogOut() {
        isOk = false
        isProcessing = false
    }
}
