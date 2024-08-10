//
//  FoodCardView.swift
//  PracticeProject
//
//  Created by Aditya Majumdar on 07/08/24.
//

import SwiftUI

struct FoodCardView: View {
    var height : CGFloat
    var strCardTitle : String
    var strCardHeadLine : String
    var strCardDescription : String
    var expandButtonHandler : (() -> Void)?
    var backgroundImageString : String
    var customBackgroundColor : LinearGradient
    var body: some View {
        ZStack(alignment: .topTrailing){
            ZStack(alignment: .bottom){
                ZStack{
                    RoundedRectangle(cornerRadius: 15)
                        .fill(customBackgroundColor)
                    Image("\(backgroundImageString)")
                        .resizable()
                        .scaledToFit()
                        .frame(height: height*3/5)
                    
                }.frame(height: height)
                Text("\(strCardDescription)")
                    .multilineTextAlignment(.leading)
                    .foregroundStyle(Color.white)
                    .lineLimit(2)
                    .font(.headline)
                    .bold()
                    .padding()
            }
            Button{
                
            }label: {
                ZStack{
                    UnevenRoundedRectangle(topLeadingRadius: 0, bottomLeadingRadius: 15, bottomTrailingRadius: 0, topTrailingRadius: 15)
                        .fill(Color.red)
                    Text("\(strCardTitle)")
                        .font(.title3)
                        .bold()
                        .foregroundStyle(Color.white)
                        .minimumScaleFactor(0.2)
                        
                }.frame(minWidth: height*1/3, maxWidth: height/2)
                .frame(height: 40)
            }
        }
    }
}

#Preview {
    FoodCardView(height: 400, strCardTitle: "Hello", strCardHeadLine: "This is a sub line for card", strCardDescription: "Your can view the list of all food items with unhealthy foods", backgroundImageString: "google.logo", customBackgroundColor: Color.btnGradientColor)
}
