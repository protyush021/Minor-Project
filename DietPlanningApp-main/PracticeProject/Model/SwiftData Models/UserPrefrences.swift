//
//  UserPrefrences.swift
//  PracticeProject
//
//  Created by Aditya Majumdar on 07/08/24.
//

import Foundation
import SwiftData

@Model
class UserPrefrences {
    
    var userID : String
    var colorScheme   : Int
    var isAccountPrivate    : Bool
    var userCalorieTarget    : Int
    @Attribute(originalName : "active_icon") var preferedAppIcon: String

    init(userID: String = "", colorScheme: Int = 0,isAccountPrivate: Bool = false, userCalorieTarget: Int = 0, preferedAppIcon: String = "") {
        self.userID = userID
        self.colorScheme = colorScheme
        self.isAccountPrivate = isAccountPrivate
        self.userCalorieTarget = userCalorieTarget
        self.preferedAppIcon = preferedAppIcon
    }
}
