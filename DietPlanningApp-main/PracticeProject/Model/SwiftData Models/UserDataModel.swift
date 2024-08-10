//
//  UserDataModel.swift
//  PracticeProject
//
//  Created by Aditya Majumdar on 07/08/24.
//

import Foundation
import SwiftData

@Model
class UserDataModel  {
    
    @Attribute(.unique) var userID : String
    @Attribute(originalName: "user_name") var userName: String
    var passWord: String
    var name: String
    var isLoginApproved : Bool 
    @Relationship(deleteRule: .cascade) var userPrefrence : UserPrefrences?
    @Relationship(deleteRule: .cascade) var dietChart     : CalorieModel?
    @Relationship(deleteRule: .cascade) var workoutChart  : SheduleWorkoutModel?
    
    init(userID: String, userName: String, passWord: String, name: String, isLoginApproved: Bool, userPrefrence: UserPrefrences? = nil, dietChart: CalorieModel? = nil, workoutChart: SheduleWorkoutModel? = nil) {
        self.userID = userID
        self.userName = userName
        self.passWord = passWord
        self.name = name
        self.isLoginApproved = isLoginApproved
        self.userPrefrence = userPrefrence
        self.dietChart = dietChart
        self.workoutChart = workoutChart
    }
}
