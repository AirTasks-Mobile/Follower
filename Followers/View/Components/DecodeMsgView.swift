//
//  DecodeMsgView.swift
//  Followers
//
//  Created by JEREMY NGUYEN on 19/07/2021.
//

import SwiftUI

struct DecodeMsgView: View {
    @Binding var msg : String
    var clearMsg : String = ""
    
    var action : () -> Void
    var actionScan : () -> Void
    
    var body: some View {
        
        GeometryReader { geometry in
            VStack{
                HStack{
                    TextField("message", text: $msg)
                        .frame(width: geometry.size.width * 0.80, height: 30, alignment: .leading)
                        .background(Color(red: 239.0/255.0, green: 243.0/255.0, blue: 244.0/255.0, opacity: 1.0))
                        .cornerRadius(5.0)
                    
                    Button(action: action, label: {
                        Image(systemName: "eye")
                    })
                    //paperplane
//                    NavigationLink( destination: CodeScannerView(codeTypes: [.qr], simulatedData: "Arbdddddd\naaaaa", completion: self.handleScan),
//                        label: {
//                            Image(systemName: "qrcode.viewfinder")
//                        })
                    
                    Button(action : actionScan, label: {
                        Image(systemName: "qrcode.viewfinder")
                    })
                
                }
                
                if !clearMsg.isEmpty && clearMsg != "" {
                    HStack{
                        Image(systemName: "arrow.right")
                        Text(clearMsg)
                            .font(.body)
                            .frame(width: geometry.size.width * 0.90, alignment: .leading)
                    }
                }
            }
            .padding(.leading, 10)
            
        }
    }

}

struct DecodeMsgView_Previews: PreviewProvider {
    static var previews: some View {
        DecodeMsgView(msg: .constant("String"),clearMsg: "String dafa edd ddfdf ddd addafd ddd add ddd aaad adddd dda ddd ", action: {
            print("Okey")
        }, actionScan: {
            print("Scan")
        })
    }
}
