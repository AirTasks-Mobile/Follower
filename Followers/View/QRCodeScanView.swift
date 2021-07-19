//
//  QRCodeScanView.swift
//  Followers
//
//  Created by JEREMY NGUYEN on 25/05/2021.
//

import SwiftUI
import CodeScanner

struct QRCodeScanView: View {
    @State private var isShowingScanner = false
    
    var body: some View {
        NavigationView {
            List {
                VStack{
                Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
                }
            }
            .navigationBarTitle("Scanner")
            .navigationBarItems(trailing: Button(action: {
                self.isShowingScanner = true
            }) {
                Image(systemName: "qrcode.viewfinder")
                Text("Scan")
            })
            .sheet(isPresented: $isShowingScanner) {
                CodeScannerView(codeTypes: [.qr], simulatedData: "Arbdddddd\naaaaa", completion: self.handleScan)
            }
        }
    }
    
    func handleScan(result: Result<String, CodeScannerView.ScanError>) {
        self.isShowingScanner = false
        print("QR Code result")
        switch result {
        case .success(let code):
            let details = code.components(separatedBy: "\n")
            guard details.count == 2 else { return }
            print("name \(details[0])")
            print("email \(details[1])")

        case .failure(let error):
            print("Scanning failed: \(error.localizedDescription)")
        }
    }
}

struct QRCodeScanView_Previews: PreviewProvider {
    static var previews: some View {
        QRCodeScanView()
    }
}
