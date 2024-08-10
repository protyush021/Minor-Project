//
//  TitleHeaderView.swift
//  PracticeProject
//
//  Created by Aditya Majumdar on 07/08/24.
//

import SwiftUI

struct TitleHeaderView: View {
    var body: some View {
        HStack{
            Text("Food Name")
                .fontWeight(.semibold)
                .foregroundStyle(Color.textColor.opacity(0.5))
                .font(.system(size: 14))
            Spacer()
            HStack(alignment: .center, spacing: 10){
                Text("Pro") .fontWeight(.semibold)
                    .foregroundStyle(Color.textColor.opacity(0.5))
                    .font(.system(size: 14))
                Text("Crab") .fontWeight(.semibold)
                    .foregroundStyle(Color.textColor.opacity(0.5))
                    .font(.system(size: 14))
                Text("Fat") .fontWeight(.semibold)
                    .foregroundStyle(Color.textColor.opacity(0.5))
                    .font(.system(size: 14))
                Text("Kcal")
                    .fontWeight(.semibold)
                    .foregroundStyle(Color.textColor.opacity(0.5))
                    .font(.system(size: 14))
            }
            
        }.padding()
    }
}
struct DemoDummyViewScreen: View {
    var body: some View {
        ZStack{
            LinearGradient(colors: [.pink, .neonClr], startPoint: .bottomTrailing, endPoint: .center)
        }
    }
}
#Preview {
    DemoDummyViewScreen()
}
