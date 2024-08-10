//
//  LoginTextFeildView.swift
//  PracticeProject
//
//  Created by Aditya Majumdar on 07/08/24.
//

import SwiftUI

struct LoginTextFeildView: View {
    
    public enum TextFeildType {
        case regular
        case passwordFeild
    }
    
    @Binding var textFeildStr: String
    
    var placeHolder: String
    var strUsername: String?
    var showEditButton: Bool = false
    var textFeildType : TextFeildType
    var editButtonClicked: (() -> Void)?
    
    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.white.opacity(0.15))
            
            if textFeildType == .passwordFeild {
                SecureField("", text: $textFeildStr,
                            prompt: Text("\(placeHolder)")
                    .foregroundStyle(Color.white)
                    .font(.system(size: 15))
                )
                .padding()
                .foregroundStyle(Color.white)
                
            }else if textFeildType == .regular{
                TextField("", text: $textFeildStr,
                          prompt: Text("\(placeHolder)")
                    .foregroundStyle(Color.white)
                    .font(.system(size: 15)))
                .padding()
                .foregroundStyle(Color.white)
                
            }
        }
    }
}
#Preview {
    LoginTextFeildView(textFeildStr: .constant("Mahesh"), placeHolder: "Enter text", textFeildType: .passwordFeild)
        .frame(height: 60)
        .preferredColorScheme(.dark)
}
