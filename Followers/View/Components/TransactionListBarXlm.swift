//
//  TransactionListBarXlm.swift
//  Followers
//
//  Created by JEREMY NGUYEN on 12/01/2022.
//

import SwiftUI

struct TransactionListBarXlm: View {
    @Binding var isLoading : Bool
    @Binding var isClick : Bool
    
    var nick : String = ""
    var id : String = ""
    var isBtn : Bool = false
    
    var onClick : () -> Void

    var textReward : String = "Other Assets?"
    var body: some View {
        HStack(spacing: 0){
            Text("\(nick)")
                .font(Font.custom("Avenir-black", size: 19))
                .foregroundColor(Color.gray)
                .padding(EdgeInsets(top: 15, leading: 15, bottom: 0, trailing: 15))
            
            if isLoading && !isClick{
                ActivityIndicator()
                    .frame(width: 20, height: 20)
                    .foregroundColor(Color(red: 239.0 / 255, green: 172.0 / 255, blue: 120.0 / 255, opacity: 0.9))
            }
        }
        
        HStack(spacing: 0){
            Text("\(id)")
                .font(Font.custom("Avenir-black", size: 13))
                .foregroundColor(Color.gray)
                .padding(EdgeInsets(top: 3, leading: 15, bottom: 5, trailing: 15))
            
            if isBtn && !isClick {
                Spacer()
                Button(action: {
                    if !isClick {
                        onClick()
                        isClick = true
                    }
                }){
                    Text(" \(textReward) ")
                        .font(Font.custom("Avenir-medium", size: 13))
                        .foregroundColor(Color.green)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8.0)
                                .stroke(Color.yellow, lineWidth: 1)
                        )
                        .padding(EdgeInsets(top: 3, leading: 0, bottom: 0, trailing: 15))
                }
            }
        }
    }
  
}

struct TransactionListBarXlm_Previews: PreviewProvider {
    static var previews: some View {
        TransactionListBarXlm(isLoading: .constant(false), isClick: .constant(false), onClick: { })
    }
}
