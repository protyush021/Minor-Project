//
//  SheduleWorkoutModel.swift
//  PracticeProject
//
//  Created by Aditya Majumdar on 07/08/24.
//

import Foundation
import SwiftData

@Model
class SheduleWorkoutModel  {
    var userID : String
    var day : String
    var workoutType : String
    
    init(userID: String, day: String, workoutType: String) {
        self.userID = userID
        self.day = day
        self.workoutType = workoutType
    }
}
