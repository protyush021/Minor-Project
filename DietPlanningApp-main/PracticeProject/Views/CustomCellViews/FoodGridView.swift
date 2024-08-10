//
//  FoodGridView.swift
//  PracticeProject
//
//  Created by Aditya Majumdar on 07/08/24.
//

import SwiftUI

struct FoodGridView: View {
    
    let sheetTitle:String
    let calorieCount:String
    let gridWidth: CGFloat
    let gridHeight: CGFloat
    
    var deleteBlockHandler: (() -> Void)?
    var body: some View {
        ZStack{
            ZStack(alignment:.topTrailing){
                RoundedRectangle(cornerRadius: 15)
                    .fill(Color.textColor.opacity(0.10))
                       Button{
                           deleteBlockHandler?()
                       }label: {
                           Image(systemName: "xmark.circle.fill")
                               .font(.system(size: (gridHeight * 0.15)))
                               .foregroundStyle(Color.textColor.opacity(0.5))
                       }.padding([.top, .trailing], 7.5)
            }
            VStack{
                Text(sheetTitle)
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(Color.textColor)
                    .font(.system(size: 20))
                    .lineLimit(1)
                    .minimumScaleFactor(0.2)
                
                Text("\(calorieCount)")
                    .fontWeight(.heavy)
                    .foregroundStyle(Color.btnGradientColor)
                    .font(.system(size: 50))
                    .lineLimit(1)
                    .minimumScaleFactor(0.2)
            }.padding()
        }.frame(width: gridWidth ,height: gridHeight)
    }
}

#Preview {
    FoodGridView(sheetTitle: "First List", calorieCount: "10000", gridWidth: 200, gridHeight: 175)
}
