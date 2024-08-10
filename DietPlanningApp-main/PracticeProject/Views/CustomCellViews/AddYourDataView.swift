//
//  AddYourDataView.swift
//  PracticeProject
//
//  Created by Aditya Majumdar on 07/08/24.
//

import SwiftUI

struct AddYourDataView: View {
    
    var addButtonBlockHandler : (() -> Void)?
    var turnOffHaptics : Bool = false
    
    var body : some View{
        VStack(spacing: 10){
            Button{
                if !turnOffHaptics {
                    CommonFunctions.Functions.getHapticFeedback(impact: .light)
                }
                addButtonBlockHandler?()
            }label: {
                ZStack{
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.textColor.opacity(0.15))
                    Image(systemName: "plus")
                        .resizable()
                        .frame(width: 15, height: 15)
                        .foregroundStyle(Color.accentColor)
                }
            }.frame(width: 40, height: 40).padding(.top, 5)
            
            Text("Add your data")
                .font(.system(size: 18))
                .bold()
        }
    }
}

#Preview {
    AddYourDataView()
}
