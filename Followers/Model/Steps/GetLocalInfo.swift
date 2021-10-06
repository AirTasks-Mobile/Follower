//
//  GetLocalInfo.swift
//  Followers
//
//  Created by JEREMY NGUYEN on 21/07/2021.
//

import Foundation
//import UIKit

class GetLocalInfo {
    
    func getDeviceID() -> String {
        //let id = UIDevice.current.identifierForVendor?.uuidString ?? "what!!"
        let id = NSUUID().uuidString
        
        return id
    }
}
