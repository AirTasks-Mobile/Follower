//
//  XLMTransactionView.swift
//  Followers
//
//  Created by JEREMY NGUYEN on 08/01/2022.
//

import SwiftUI

struct XLMTransactionView: View {
    @Binding var srcId : String
    @Binding var nick : String
    var txn : TransactionInfo
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0){
            Text("ID: \(txn.id)")
                .font(Font.custom("Avenir-medium", size: 17))
                .foregroundColor(Color.gray)
            Divider()
            Text("Date: \(txn.date)")
                .font(Font.custom("Avenir-medium", size: 17))
                .foregroundColor(Color.gray)
            Divider()
            if txn.type == GTEXT.XLM_TYPE_XPAY || txn.type == GTEXT.XLM_TYPE_PAY || txn.type == GTEXT.XLM_TYPE_CREATE_CLAIM {
                HStack{
                    Text("From: \(getStoredXlmAddressName(id:srcId, nick: nick, address: txn.src, scheme: txn.scheme))")
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
                    Text("To: \(getStoredXlmAddressName(id:srcId, nick: nick, address: txn.des, scheme: txn.scheme))")
                        .font(Font.custom("Avenir-medium", size: 13))
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
            }

            if txn.type == GTEXT.XLM_TYPE_XPAY {
                Text("From Asset: \(txn.status)")
                    .font(Font.custom("Avenir-medium", size: 17))
                    .foregroundColor(Color.gray)
                
                Divider()
            }

            Text("Type: \(getType(type: txn.type, srcAcc: txn.src, desAcc: txn.des))")
                .font(Font.custom("Avenir-medium", size: 17))
                .foregroundColor(Color.gray)

        }
        .buttonStyle(PlainButtonStyle())
        //.padding(EdgeInsets(top: 25, leading: 15, bottom: 0, trailing: 15))
    }
    
    func getType(type: String, srcAcc: String, desAcc: String) -> String {
        var mType = ""
        if type == GTEXT.XLM_TYPE_XPAY || type == GTEXT.XLM_TYPE_PAY {
            mType = "Payment"
        }
        else if type == GTEXT.XLM_TYPE_CREATE_CLAIM {
            mType = "Claimable"
        }
        else if type == GTEXT.XLM_TYPE_CREATE_ACCOUNT {
            if srcId == srcAcc {
                mType = "Create Account \(desAcc)"
            }
            else {
                mType = "Create \(nick) from Account \(srcAcc)"
            }
        }
        else if type == GTEXT.XLM_TYPE_DELETE_ACCOUNT {
            if srcId == srcAcc {
                mType = "Delete \(nick) (merge to Account \(desAcc) )"
            }
            else {
                mType = "Merge with Account \(srcAcc)"
            }
            
        }
        
        return mType
    }
    
    func getStoredXlmAddressName(id: String, nick: String, address: String, scheme: String) -> String {
        if id == address {
            return nick
        }
        
        let storedList : [String] = UserDefaults.standard.stringArray(forKey: GTEXT.XLM_LIST) ?? []

        
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

struct XLMTransactionView_Previews: PreviewProvider {
    static var previews: some View {
        XLMTransactionView(srcId: .constant(""), nick: .constant(""),txn: TransactionInfo.default)
    }
}
