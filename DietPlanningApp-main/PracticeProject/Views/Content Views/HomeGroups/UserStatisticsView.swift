//
//  UserStatisticsView.swift
//  PracticeProject
//
//  Created by Aditya Majumdar on 07/08/24.
//

import SwiftUI
import SwiftData
import Charts

struct UserStatisticsView: View {
    @Environment(\.modelContext) var formData
    @EnvironmentObject var vm: ScannerViewModel
    @StateObject private var healthKitManager = HealthKitManagerHome()
    @State var totalCaloriesStr : String = "0"
    @State private var drawingStroke = false
    @State private var foodDataStorage : [CalorieModel] = []
    @State var userWorkout     : [SheduleWorkoutModel]  = []
    @State var chartData               : [UserChart]    = []
    
    var totalCalories: Int {
        foodDataStorage.reduce(0) { $0 + (Int($1.calCount) ) }
    }
    
    var body: some View {
        NavigationStack{
            List{
                Section{
                    ZStack{
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.textColor.opacity(0.1))
                        HStack{
                            VStack(alignment: .leading, spacing: 10){
                                VStack(alignment: .leading) {
                                    Text("Calories Burned")
                                        .bold()
                                        .font(.system(size: 14))
                                        .foregroundStyle(Color.textColor)
                                    HStack(spacing: 2) {
                                        
                                        Text("\(Int(healthKitManager.caloriesBurned))")
                                            .font(.title)
                                            .bold()
                                            .foregroundStyle(Color.textColor)
                                        Text("Kcal")
                                            .font(.title3)
                                            .foregroundStyle(Color.textColor)
                                    }
                                }
                                VStack(alignment: .leading){
                                    Text("Total Intake")
                                        .bold()
                                        .font(.system(size: 14))
                                        .foregroundStyle(Color.textColor)
                                    HStack(spacing:2){
                                        Text("\(totalCaloriesStr)")
                                            .font(.title)
                                            .bold()
                                            .foregroundStyle(Color.pink)
                                        Text("Cal")
                                            .font(.title3)
                                            .foregroundStyle(Color.pink)
                                    }
                                }
                            }.padding(.leading)
                            Spacer()
                            
                            ActivityProgressView(drawingStroke: $drawingStroke, animationDuration: 3.0)
                                .onAppear { drawingStroke.toggle() }
                            
                        }.padding()
                    }.frame(height: 185)
                        .listRowSeparator(.hidden)
                }header: {
                    Text("Your Activity")
                        .bold()
                        .font(.title2)
                        .foregroundStyle(Color.textColor)
                }
                
                Section{
                    VStack{
                        UserWorkoutGraphView(userWorkout: $userWorkout, cardHeight: 100)
                        HStack{
                            GraphLegendView(legendColor: .green, legendName: "Regular")
                            GraphLegendView(legendColor: .red, legendName: "Rest")
                            Spacer()
                        }.padding(.horizontal)
                    }
                    .listRowSeparator(.hidden)
                }header: {
                    Text("Shedule")
                        .bold()
                        .font(.title2)
                        .foregroundStyle(Color.textColor)
                }
                
                Section{
                    CalorieGraphChartView(foodDataStorage: $foodDataStorage, cardHeight: foodDataStorage.count > 0 ? 300 : 200)
                        .listRowSeparator(.hidden)
                }header: {
                    Text("Calorie graph")
                        .bold()
                        .font(.title2)
                        .foregroundStyle(Color.textColor)
                }
                
            }.listStyle(PlainListStyle())
                .navigationTitle("Weekly Statistics")
                .navigationBarTitleDisplayMode(.inline)
        }
        .onAppear(perform: {
            addChartData()
            fetchCalData()
            fetchWorkoutData()
            totalCaloriesStr = foodDataStorage.count > 0 ? String(totalCalories) : "0"
        })
    }
}
#Preview {
    UserStatisticsView()
        .preferredColorScheme(.dark)
}

extension UserStatisticsView{
    
    func fetchCalData(){
        let userID =  UserDefaults.standard.value(forKey: "UserID") as! String
        let descriptor = FetchDescriptor<CalorieModel>(predicate: #Predicate { data in
            data.userID == userID
        })
        do {
            foodDataStorage = try formData.fetch(descriptor)
            print(foodDataStorage)
        }catch { }
    }
    
    func fetchWorkoutData(){
        let userID =  UserDefaults.standard.value(forKey: "UserID") as! String
        let descriptor = FetchDescriptor<SheduleWorkoutModel>(predicate: #Predicate { data in
            data.userID == userID
        })
        do {
            userWorkout = try formData.fetch(descriptor)
            print(userWorkout)
        }catch {
            print(error)
        }
    }
    func addChartData(){
        chartData = [
        UserChart(day: "Monday", time: 1),
        UserChart(day: "Tuesday", time: 4),
        UserChart(day: "Wednesday", time: 3),
        UserChart(day: "Thusday", time: 10),
        UserChart(day: "Friday", time: 3),
        UserChart(day: "Saturday", time: 1),
        UserChart(day: "Sunday", time: 5)
        ]
    }
}

