//
//  CalorieTargetView.swift
//  PracticeProject
//
//  Created by Aditya Majumdar on 07/08/24.
//

import SwiftUI

struct CalorieTargetView: View {
    
    @State var carCountData: Int = 1000
    
    var selectedColorScheme : Int = 0
    var skipButtonBlockHandler : (() -> Void)?

    var body: some View {
        NavigationStack{
            ZStack(alignment: .bottom){
                VStack{
                    Spacer()
                    Text("Set your daily calorie intake target.")
                        .font(.title)
                        .multilineTextAlignment(.center)
                        .minimumScaleFactor(0.02)
                        .lineLimit(2)
                        .padding(.horizontal, 20)
                    Spacer()
                    HStack{
                        Button{
                            CommonFunctions.Functions.getHapticFeedback(impact: .medium)
                            carCountData -= 50
                        }label: {
                            Image(systemName: "minus")
                                .bold()
                                .frame(width: 50, height: 50)
                                .background(Color.textColor.opacity(0.15))
                                .cornerRadius(25)
                        }
                        
                        ZStack{
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.textColor.opacity(0.15))
                            Text("\(carCountData)")
                                .bold()
                        }.frame(width: 150, height: 50)
                        
                        Button{
                            CommonFunctions.Functions.getHapticFeedback(impact: .medium)
                            carCountData += 50
                        }label: {
                            Image(systemName: "plus")
                                .bold()
                                .frame(width: 50, height: 50)
                                .background(Color.textColor.opacity(0.15))
                                .cornerRadius(25)
                        }
                    }
                    Spacer()
                    Spacer()

                    Spacer()
                }
                
                VStack(spacing: 20){
                    
                    NavigationLink{
                        BMISuggestionView(selectedColorScheme: selectedColorScheme, userCalorieTarget: carCountData) {
                            skipButtonBlockHandler?()
                        }
                    }label: {
                        ZStack{
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.blue)
                            
                            Text("Save")
                                .bold()
                                .foregroundStyle(Color.white)
                        }.frame(width: 300, height: 50)
                    }
                    
                    NavigationLink{
                        BMISuggestionView(selectedColorScheme: selectedColorScheme) {
                            skipButtonBlockHandler?()
                        }
                    }label: {
                        Text("Not now")
                            .bold()
                    }
                }.padding(.bottom, 20)
            }
        }
    }
}

#Preview {
    CalorieTargetView()
}
