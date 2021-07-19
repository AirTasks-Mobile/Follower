//
//  QRCodeView.swift
//  Followers
//
//  Created by JEREMY NGUYEN on 25/05/2021.
//

import SwiftUI
import CoreImage.CIFilterBuiltins
import CodeScanner

struct QRCodeView: View {
    @State private var name = "Hi"
    @State private var email = "hi_there@gmail.com"
    @State private var isShowingScanner = false
    
    let qrCodeContext = CIContext()
    let qrCodeFilter = CIFilter.qrCodeGenerator()
    
    var body: some View {
        NavigationView {
            VStack {
                TextField("Name", text: $name)
                    .textContentType(.name)
                    .font(.title)
                    .padding(.horizontal)
                
                TextField("Email Address", text: $email)
                    .textContentType(.emailAddress)
                    .font(.title)
                    .padding([.horizontal, .bottom])
                
                Spacer()
                
                Image(uiImage: genQRCode(from: "\(name)\n\(email)"))
                    .interpolation(.none)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                
                Spacer()
            }
            .navigationBarTitle("QR Code")
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
    
    func genQRCode(from stringInput : String) -> UIImage {
        let data = Data(stringInput.utf8)
        qrCodeFilter.setValue(data, forKey: "inputMessage")
        
        if let outputImage = qrCodeFilter.outputImage {
            if let cgimg = qrCodeContext.createCGImage(outputImage, from: outputImage.extent)
            {
                return UIImage(cgImage: cgimg)
            }
        }
        
        return UIImage(systemName: "xmark.circle") ?? UIImage()
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

struct QRCodeView_Previews: PreviewProvider {
    static var previews: some View {
        QRCodeView()
    }
}
