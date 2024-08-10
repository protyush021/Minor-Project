//
//  UserWorkoutGraphView.swift
//  PracticeProject
//
//  Created by Aditya Majumdar on 07/08/24.
//

import SwiftUI

struct UserWorkoutGraphView : View {
    @Binding var userWorkout : [SheduleWorkoutModel]
    var cardHeight : CGFloat = 100
    
    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.textColor.opacity(0.1))
            if userWorkout.isEmpty {
                AddYourDataView(addButtonBlockHandler: {
                    
                })
            }else {
                HStack(spacing: 10){
                    ForEach(userWorkout){ user in
                        VStack(spacing:10){
                            Text("\(user.day)")
                                .font(.system(size: 8))
                                .bold()
                                .minimumScaleFactor(0.002)
                            Circle()
                                .fill(user.workoutType != "Rest" ? Color.green : Color.red)
                                .frame(height: 10)
                        }
                    }
                }
                .padding(.vertical)
                .padding(.horizontal, 10)
            }
        }.frame(height: cardHeight)
    }
}
