//
//  GetStartedView.swift
//  PracticeProject
//
//  Created by Aditya Majumdar on 07/08/24.
//

import SwiftUI

struct GetStartedView: View {
    
    @Environment(\.modelContext) var modelContext
    @State private var showIndicator : Bool = false
    
    var selectedColorScheme : Int = 0
    var userCalorieTarget : Int = 0
    var skipButtonBlockHandler : (() -> Void)?
    
    var body: some View {
        NavigationStack{
            ZStack(alignment: .bottom){
                ZStack{
                    VStack(spacing: 25){
                        Spacer()
                        Text("Your prefrences have been saved successfully.")
                            .font(.title)
                            .multilineTextAlignment(.center)
                            .minimumScaleFactor(0.02)
                            .lineLimit(2)
                            .padding(.horizontal, 20)
                        ZStack{
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color.textColor.opacity(0.15))
                                .frame(height: 200)
                                .padding(.horizontal, 20)
                            Image(systemName: "person.badge.shield.checkmark")
                                .resizable()
                                .frame(width: 100, height: 100)
                                .foregroundStyle(Color.brownBlackGradient)
                        }
                        
                        Spacer()
                        Spacer()
                    }
                }.frame(maxHeight: .infinity)
                
                VStack(spacing: 20){
                    Button{
                        if showIndicator{
                            addData()
                            
                        }
                    }label: {
                        ZStack{
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.blue)
                            if !showIndicator{
                                ProgressView()
                                    .progressViewStyle(.circular)
                                    .foregroundStyle(Color.white)
                            }else {
                                Text("Get started")
                                    .bold()
                                    .foregroundStyle(Color.white)
                            }
                            
                        }.frame(width: 300, height: 50)
                    }
                    
                    Button{
                        
                    }label: {
                        Text("Not now")
                            .bold()
                            .foregroundStyle(Color.clear)
                    }
                }.padding(.bottom, 20)
            }.onAppear(perform: {
                DispatchQueue.main.asyncAfter(deadline: .now() + 5){
                    showIndicator.toggle()
                }
            })
            .navigationTitle("You are all set now")
            .toolbarTitleDisplayMode(.inline)
        }
    }
    
    func addData() {
            let userID =  UserDefaults.standard.value(forKey: "UserID") as! String
            let userPreffData = UserPrefrences(userID: userID,
                                         colorScheme: selectedColorScheme,
                                         isAccountPrivate: false,
                                         userCalorieTarget: userCalorieTarget,
                                         preferedAppIcon: "")
            withAnimation {
                modelContext.insert(userPreffData)
                CommonFunctions.Functions.getHapticFeedback(impact: .light)
                skipButtonBlockHandler?()
            }
    }
}

#Preview {
    GetStartedView()
}
