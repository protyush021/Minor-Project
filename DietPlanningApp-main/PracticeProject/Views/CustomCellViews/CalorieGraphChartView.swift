//
//  CalorieGraphChartView.swift
//  PracticeProject
//
//  Created by Aditya Majumdar on 07/08/24.
//

import SwiftUI
import Charts

struct CalorieGraphChartView : View{
    
    @Binding var foodDataStorage : [CalorieModel]
    var cardHeight : CGFloat
    
    var body: some View{
        ZStack{
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.textColor.opacity(0.1))
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            if foodDataStorage.count > 0{
                Chart{
                    ForEach(foodDataStorage){ data in
                        BarMark(x: .value("Food", data.name), y: .value("Calories", data.calCount))
                            .foregroundStyle(Color.titleGradientColor)
                    }
                }.padding()
            } else {
                AddYourDataView {
                    
                }
            }
        }.frame(height: cardHeight)
    }
}
