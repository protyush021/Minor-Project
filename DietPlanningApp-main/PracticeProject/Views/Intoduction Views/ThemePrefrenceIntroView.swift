//
//  ThemePrefrenceIntroView.swift
//  PracticeProject
//
//  Created by Aditya Majumdar on 07/08/24.
//

import SwiftUI
import SwiftData

struct ThemePrefrenceIntroView: View {
    
    @Environment(\.modelContext) var modelContext
    @State private var selectedButtonTag : Int = 0
    @State private var isNavigated : Bool = false
    
    var skipButtonBlockHandler : (() -> Void)?

    var body: some View {
        ZStack{
            NavigationStack{
                ZStack(alignment: .bottom){
                    ZStack{
                        VStack{
                            Text("Select color scheme")
                                .font(.title)
                                .multilineTextAlignment(.center)
                                .minimumScaleFactor(0.02)
                                .lineLimit(2)
                                .padding(.horizontal, 20)
                            
                            VStack(spacing: 0){
                                HStack{
                                    ZStack{
                                        RoundedRectangle(cornerRadius: 10)
                                            .fill(Color.textColor.opacity(0.10))
                                            .stroke(selectedButtonTag == 0 ? Color.blue : Color.clear, lineWidth: 2.5)
                                        HStack{
                                            HStack{
                                                Image(systemName: selectedButtonTag == 0 ? "checkmark.circle.fill" : "circle")
                                                    .foregroundStyle(selectedButtonTag == 0 ? Color.blue : Color.gray)
                                                Text("Auto")
                                                    .foregroundStyle(Color.textColor)
                                                    .bold()
                                            }.padding()
                                            Spacer()
                                            ZStack{
                                                Image(systemName: "apps.iphone")
                                                    .resizable()
                                                    .foregroundStyle(Color.btnGradientColor)
                                                    .scaledToFit()
                                                    .padding()
                                            }.frame(height: 60)
                                        }
                                    }.onTapGesture(perform: {
                                        selectedButtonTag = 0
                                        changeDeviceTheme(mode: .unspecified)
                                        
                                    })
                                    .frame(height: 100)
                                    
                                }.padding(.horizontal)
                                    .padding(.vertical, 10)
                                
                                HStack{
                                    ZStack{
                                        RoundedRectangle(cornerRadius: 10)
                                            .fill(Color.textColor.opacity(0.10))
                                            .stroke(selectedButtonTag == 1 ? Color.blue : Color.clear, lineWidth: 2.5)
                                        HStack{
                                            HStack{
                                                Image(systemName: selectedButtonTag == 1 ? "checkmark.circle.fill" : "circle")
                                                    .foregroundStyle(selectedButtonTag == 1 ? Color.blue : Color.gray)
                                                Text("Light Mode")
                                                    .foregroundStyle(Color.textColor)
                                                    .bold()
                                            }.padding()
                                            Spacer()
                                            ZStack{
                                                Image(systemName: "sun.min.fill")
                                                    .resizable()
                                                    .foregroundStyle(Color.orange)
                                                    .scaledToFit()
                                                    .padding()
                                            }.frame(height: 60)
                                        }
                                    }.onTapGesture(perform: {
                                        selectedButtonTag = 1
                                        changeDeviceTheme(mode: .light)
                                        
                                    })
                                    .frame(height: 100)
                                    
                                }.padding(.horizontal)
                                    .padding(.vertical, 10)
                                
                                HStack{
                                    ZStack{
                                        RoundedRectangle(cornerRadius: 10)
                                            .fill(Color.textColor.opacity(0.10))
                                            .stroke(selectedButtonTag == 2 ? Color.blue : Color.clear, lineWidth: 2.5)
                                        
                                        HStack{
                                            HStack{
                                                Image(systemName: selectedButtonTag == 2 ? "checkmark.circle.fill" : "circle")
                                                    .foregroundStyle(selectedButtonTag == 2 ? Color.blue : Color.gray)
                                                Text("Dark Mode")
                                                    .foregroundStyle(Color.textColor)
                                                    .bold()
                                            }.padding()
                                            Spacer()
                                            ZStack{
                                                Image(systemName: "moon.stars")
                                                    .resizable()
                                                    .foregroundStyle(Color.textGradient)
                                                    .scaledToFit()
                                                    .padding()
                                            }.frame(height: 60)
                                        }
                                    }.onTapGesture(perform: {
                                        selectedButtonTag = 2
                                        changeDeviceTheme(mode: .dark)
                                    })
                                    .frame(height: 100)
                                }.padding(.horizontal)
                                    .padding(.vertical, 10)
                            }.padding()
                        }
                    }.frame(maxHeight: .infinity)
                    VStack(spacing: 20){
                        NavigationLink {
                            CalorieTargetView(selectedColorScheme: selectedButtonTag, skipButtonBlockHandler: {
                                skipButtonBlockHandler?()
                            })
                        }label: {
                            ZStack{
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.blue)
                                
                                Text("Save")
                                    .bold()
                                    .foregroundStyle(Color.white)
                            }.frame(width: 300, height: 50)
                        }
                        
                        NavigationLink {
                            CalorieTargetView(skipButtonBlockHandler: {
                                skipButtonBlockHandler?()
                            })
                        }label: {
                            Text("Not now")
                                .bold()
                        }
                    }.padding(.bottom, 20)
                }
            }
        }
    }
}

extension ThemePrefrenceIntroView{
    func changeDeviceTheme(mode: UIUserInterfaceStyle){
        UIApplication.shared.windows.forEach { window in
            window.overrideUserInterfaceStyle = mode
        }
    }
}

#Preview {
    ThemePrefrenceIntroView()
}
