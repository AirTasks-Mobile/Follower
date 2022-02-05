//
//  TransactionView.swift
//  Followers
//
//  Created by JEREMY NGUYEN on 05/01/2022.
//

import SwiftUI

struct TransactionView: View {
    @Binding var srcId : String
    @Binding var nick : String
    var txn : TransactionInfo
    
    //var texxtColor : Color = Color(red: 255.0/255, green: 255.0/255, blue: 255.0/255)
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0){
            Text("Date: \(txn.date)")
                .font(Font.custom("Avenir-medium", size: 17))
                .foregroundColor(Color.gray)
            Divider()
            
            HStack {
                Text("From: \(getStoredAddressName(id:srcId, nick: nick, address: txn.src, scheme: txn.scheme))")
                    .font(Font.custom("Avenir-medium", size: 17))
                    .foregroundColor(Color.gray)
                Button(action: {
                    UIPasteboard.general.setValue(txn.src, forPasteboardType: "public.plain-text")
                }){
                    Image(systemName: "doc.on.doc")
                        .resizable()
                        .foregroundColor(.gray)
                        .frame(width: 17, height: 17, alignment: .leading)
                }
            }
            
            Divider()
            HStack{
                Text("To: \(getStoredAddressName(id:srcId, nick: nick, address: txn.des, scheme: txn.scheme))")
                    .font(Font.custom("Avenir-medium", size: 17))
                    .foregroundColor(Color.gray)
                Button(action: {
                    UIPasteboard.general.setValue(txn.des, forPasteboardType: "public.plain-text")
                }){
                    Image(systemName: "doc.on.doc")
                        .resizable()
                        .foregroundColor(.gray)
                        .frame(width: 17, height: 17, alignment: .leading)
                }
            }
            
            Divider()

            Text("Fee: \(txn.scheme) \(txn.fee)")
                .font(Font.custom("Avenir-medium", size: 17))
                .foregroundColor(Color.gray)
            
            Divider()

            Text("Type: \(txn.type)")
                .font(Font.custom("Avenir-medium", size: 17))
                .foregroundColor(Color.gray)
            if (txn.subToken?.count ?? 0) > 0 {
                Text("\(getSubToken(tokens: txn.subToken ?? []))")
                    .font(Font.custom("Avenir-medium", size: 15))
                    .foregroundColor(Color.gray)
            }

        }
        //.padding(EdgeInsets(top: 25, leading: 15, bottom: 0, trailing: 15))
    }
    
    func getSubToken(tokens: [SubToken]) -> String {
        //print("FEEE = \(txn.fee)")
        var tokenString : String = ""
        for token in tokens {
            if tokenString == "" {
                tokenString += "\(token.token_owner ?? "")  \(token.amount ?? "") \(token.token_name ?? "")"
            }
            else {
                tokenString += " / \(token.token_owner ?? "")  \(token.amount ?? "") \(token.token_name ?? "")"
            }
        }
        return tokenString
    }
    
    func getStoredAddressName(id: String, nick: String, address: String, scheme: String) -> String {
        if id == address {
            return nick
        }
        
        var storedList : [String] = []
        if scheme == GTEXT.SOLANA {
            storedList = UserDefaults.standard.stringArray(forKey: GTEXT.SOL_LIST) ?? []
        }
        else if scheme == GTEXT.HARMONY {
            storedList = UserDefaults.standard.stringArray(forKey: GTEXT.ONE_LIST) ?? []
        }
        else if scheme == GTEXT.STELLAR {
            storedList = UserDefaults.standard.stringArray(forKey: GTEXT.XLM_LIST) ?? []
        }
        else {
            return address
        }
        
        for storedId in storedList {
            if let storedData = UserDefaults.standard.object(forKey: storedId) as? Data {
                if let storedInfo = try? JSONDecoder().decode(CoinInfo.self, from: storedData){
                    if storedInfo.id == address {
                        return storedInfo.nick
                    }
                }
            }
        }
        
        return address
    }
}

struct TransactionView_Previews: PreviewProvider {
    static var previews: some View {
        TransactionView(srcId: .constant(""), nick: .constant(""),txn: TransactionInfo.default)
    }
}
