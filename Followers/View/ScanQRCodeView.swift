//
//  ScanQRCodeView.swift
//  Followers
//
//  Created by JEREMY NGUYEN on 21/07/2021.
//

import SwiftUI
import CodeScanner

struct ScanQRCodeView: View {
    @Binding var msg : String 
    var goBack : () -> Void
    
    var body: some View {
        CodeScannerView(codeTypes: [.qr], simulatedData: "Arbdddddd\naaaaa", completion: self.handleScan)
    }
    
    func handleScan(result: Result<String, CodeScannerView.ScanError>) {
        print("QR Code result")
        switch result {
        case .success(let code):
            //let details = code.components(separatedBy: "\n")
            print("qr = \(code)")
            msg = code
        case .failure(let error):
            print("Scanning failed: \(error.localizedDescription)")
        }
        
        goBack()
    }
}

struct ScanQRCodeView_Previews: PreviewProvider {
    static var previews: some View {
        ScanQRCodeView(msg: .constant("msg"), goBack: {
            print("back")
        })
    }
}
