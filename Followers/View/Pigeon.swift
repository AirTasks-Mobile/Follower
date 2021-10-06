//
//  Pigeon.swift
//  Followers
//
//  Created by JEREMY NGUYEN on 29/04/2021.
//

import SwiftUI

struct Pigeon: View {
    @EnvironmentObject var homeVM : HomeVM
    @State var msg : String = ""
    var goBack : () -> Void
    
    
    var body: some View {
        GeometryReader { geo in
            VStack{
                ZStack{
                    HeaderView()
                    BackButton(action: goBack)
                }
                .frame(width: geo.size.width, height: geo.size.height * 0.15)
            
                VStack (alignment: .leading) {
                    Text("Pigeon")
                    HStack{
                        TextField("16 characters max", text: $msg)
                            .frame(width: geo.size.width * 0.80, height: 30, alignment: .leading)
                            .background(Color(red: 239.0/255.0, green: 243.0/255.0, blue: 244.0/255.0, opacity: 1.0))
                            .cornerRadius(5.0)
                        
                        Button(action: getMsg, label: {
                            Image(systemName: "eye")
                        })
                    }
                }
                .padding(.top, 30)
            }
        }
        .background(Color(red : 219.0/255, green: 227.0/255, blue: 145.0/255))
        .edgesIgnoringSafeArea(.all)
    }
    
    func getMsg(){
        if msg.count > 16 {
            msg = ""
        }
        
        homeVM.getSecretMsg(info: msg)
    }
}

struct Pigeon_Previews: PreviewProvider {
    static var previews: some View {
        Pigeon(goBack: {
            print("back")
        })
    }
}
