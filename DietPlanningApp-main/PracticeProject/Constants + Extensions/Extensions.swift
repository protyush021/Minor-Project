//
//  Extensions.swift
//  PracticeProject
//
//  Created by Aditya Majumdar on 07/08/24.
//

import Foundation
import SwiftUI

extension Color {
    //Colors
    static let tabIconColor = Color("neonClr")
    static let textColor = Color("TextColor")
    static let mainColor = Color("MainColor")

    //Gradients
    static let btnGradientColor = LinearGradient(colors: [.blue, .pink], startPoint: .top, endPoint: .bottomTrailing)
    static let btnGradientColor2 = LinearGradient(colors: [.pink, .red], startPoint: .top, endPoint: .bottomTrailing)
    static let viewGradientColor = LinearGradient(colors: [.secondary.opacity(0.75), .green.opacity(0.75)], startPoint: .top, endPoint: .bottomTrailing)
    static let blueYellowGradient = LinearGradient(colors: [.blue, .yellow], startPoint: .topLeading, endPoint: .bottomTrailing)
    static let orangeYellowGradient = LinearGradient(colors: [.orange, .yellow], startPoint: .top, endPoint: .bottom)
    static let pinkNeonGradient = LinearGradient(colors: [.blue.opacity(0.2), .blue], startPoint: .topLeading, endPoint: .bottom)
    static let brownBlackGradient = LinearGradient(colors: [.black, .brown], startPoint: .topLeading, endPoint: .bottom)
    static let voiletPinkGradient = LinearGradient(colors: [.blue, .pink], startPoint: .topLeading, endPoint: .trailing)
    static let redYellowGradient = LinearGradient(colors: [.red, .orange], startPoint: .leading, endPoint: .top)
    static let textGradient = LinearGradient(colors: [.black, .blue], startPoint: .topLeading, endPoint: .bottomTrailing)
    static let titleGradientColor = LinearGradient(colors: [.green, .blue], startPoint: .bottomLeading, endPoint: .topTrailing)
    static let cardGradient = LinearGradient(colors: [.brown, .yellow], startPoint: .leading, endPoint: .topTrailing)
}
