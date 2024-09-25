//
//  UserHomeScreen.swift
//  PracticeProject
//
//  Created by Aditya Majumdar on 07/08/24.
//

import SwiftUI
import SwiftData
import HealthKit

struct ActivityCardModel: Identifiable {
    var id = UUID()
    var title: String?
    var subTitle: String?
    var bgColor: LinearGradient?
}

struct UserHomeScreen: View {
    @Binding var tabItemTag: Int
    
    init(tabItemTag: Binding<Int>) {
        self._tabItemTag = tabItemTag
    }

    @Namespace var profileAnimation
    @Environment(\.modelContext) var formData
    @EnvironmentObject var vm: ScannerViewModel
    
    @State private var foodDataStorage: [CalorieModel] = []
    @State private var arrHomeItems: [ActivityCardModel] = [
        ActivityCardModel(title: "New", bgColor: Color.brownBlackGradient),
        ActivityCardModel(title: "Favourites", bgColor: Color.titleGradientColor),
        ActivityCardModel(title: "Trending", bgColor: Color.orangeYellowGradient),
        ActivityCardModel(title: "Suggestions", bgColor: Color.btnGradientColor2)
    ]
    @State private var arrSideItems: [ActivityCardModel] = [
        ActivityCardModel(title: "Track", subTitle: "Have a track of your calories", bgColor: Color.brownBlackGradient),
        ActivityCardModel(title: "BMI", subTitle: "Calculate your BMI and get personal suggestions for your diet and workout", bgColor: Color.redYellowGradient),
        ActivityCardModel(title: "Monitor", subTitle: "Monitor your nutrition charts", bgColor: Color.btnGradientColor2),
        ActivityCardModel(title: "Tips", subTitle: "Want to know more..?", bgColor: Color.cardGradient)
    ]
    @State private var totalCaloriesStr: String = "0"
    @State private var drawingStroke = false
    @State private var onlineImageExpanded = false
    @State private var showDarkModeScreen = false
    @State var selectedOnlineImage: UIImage?
    
    @StateObject var apiManager = APIManager()
    @Environment(\.modelContext) var modelContext
    @Query(sort: \Item.timestamp, order: .reverse) var items: [Item]
    @State private var selectedHour: Date? = nil

    // HealthKit-related properties
    private var healthStore = HKHealthStore()
    @State private var caloriesBurned: Double = 0.0
    
    // This property aggregates today's nutritional data
    private var todaysNutrition: (calories: Double, fat: Double, carbs: Double, protein: Double) {
        let calendar = Calendar.current
        let todayItems = items.filter { calendar.isDateInToday($0.timestamp) }
        
        let totalCalories = todayItems.compactMap { $0.nfCalories }.reduce(0, +)
        let totalFat = todayItems.compactMap { $0.nfTotalFat }.reduce(0, +)
        let totalCarbs = todayItems.compactMap { $0.nfTotalCarbohydrate }.reduce(0, +)
        let totalProtein = todayItems.compactMap { $0.nfProtein }.reduce(0, +)
        return (totalCalories, totalFat, totalCarbs, totalProtein)
    }
    
    var totalCalories: Int {
        foodDataStorage.reduce(0) { $0 + (Int($1.calCount)) }
    }
    
    var cardHeight: CGFloat = 200
    let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 2)
    
    var body: some View {
        ScrollView(.vertical) {
            Section {
                HStack(spacing: 20) {
                    // Calorie Intake
                    VStack {
                        ZStack {
                            Circle()
                                .stroke(Color.green.opacity(0.3), lineWidth: 10)
                            Circle()
                                .trim(from: 0, to: CGFloat(min(todaysNutrition.calories, 2000)) / 2000)
                                .stroke(Color.green, lineWidth: 10)
                                .rotationEffect(.degrees(-90))
                            Text("\(Int(todaysNutrition.calories.rounded()))")
                                .font(.title)
                                .bold()
                                .foregroundStyle(Color.green)
                        }
                        .frame(width: 80, height: 80)
                        
                        Text("Calories Consumed")
                            .bold()
                            .font(.system(size: 14))
                            .foregroundStyle(Color.textColor)
                        Text("Kcal")
                            .font(.title3)
                            .foregroundStyle(Color.green)
                    }
                    
                    Spacer()
                    
                    // Calories Burned
                    VStack {
                        ZStack {
                            Circle()
                                .stroke(Color.red.opacity(0.3), lineWidth: 10)
                            Circle()
                                .trim(from: 0, to: CGFloat(min(caloriesBurned, 2000)) / 2000)
                                .stroke(Color.red, lineWidth: 10)
                                .rotationEffect(.degrees(-90))
                            Text("\(Int(caloriesBurned.rounded()))")
                                .font(.title)
                                .bold()
                                .foregroundStyle(Color.red)
                        }
                        .frame(width: 80, height: 80)
                        
                        Text("Calories Burned")
                            .bold()
                            .font(.system(size: 14))
                            .foregroundStyle(Color.textColor)
                        Text("Kcal")
                            .font(.title3)
                            .foregroundStyle(Color.red)
                    }
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 15).fill(Color.textColor.opacity(0.1)))
                .padding(.horizontal)
            

            } header: {
                HStack {
                    Text("Your Activity")
                        .bold()
                        .font(.title2)
                        .foregroundStyle(Color.textColor)
                    Spacer()
                }
                .padding([.horizontal, .top])
            }
            
            Section {
                ScrollView(.horizontal) {
                    LazyHGrid(rows: [GridItem()], alignment: .center, spacing: 10) {
                        ForEach(arrSideItems) { home in
                            if let title = home.title, let subTitle = home.subTitle, let gradient = home.bgColor {
                                ZStack(alignment: .topLeading) {
                                    ZStack(alignment: .bottom) {
                                        RoundedRectangle(cornerRadius: 10)
                                            .fill(gradient)
                                        ZStack(alignment: .center) {
                                            UnevenRoundedRectangle(topLeadingRadius: 0, bottomLeadingRadius: 10, bottomTrailingRadius: 10, topTrailingRadius: 0)
                                                .fill(Color.black.opacity(0.5))
                                            Text("\(subTitle)")
                                                .font(.footnote)
                                                .multilineTextAlignment(.center)
                                                .lineLimit(3)
                                                .foregroundStyle(Color.white)
                                                .padding(5)
                                        }
                                        .frame(height: 75)
                                    }
                                    .frame(width: 250, height: 275)
                                    .onTapGesture {
                                        if title == "Track" {
                                            tabItemTag = 1
                                        } else if title == "Monitor" {
                                            tabItemTag = 2
                                        }
                                    }
                                    Text("\(title)")
                                        .bold()
                                        .font(.title)
                                        .foregroundStyle(Color.white)
                                        .padding([.top, .leading], 20)
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                .scrollIndicators(.hidden)
            } header: {
                HStack {
                    Text("For you")
                        .bold()
                        .font(.title2)
                        .foregroundStyle(Color.textColor)
                    Spacer()
                }
                .padding([.horizontal, .top])
            }
        }
        .onAppear(perform: {
            fetchCalData()
            totalCaloriesStr = foodDataStorage.count > 0 ? String(totalCalories) : "0"
            requestAuthorization() // Request authorization for HealthKit
            fetchCaloriesBurnedFromHealthKit() // Fetch calories from HealthKit on appear
            if let user = UserDefaults.standard.object(forKey: "UserLogIN") as? Int, user == 0 {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    showDarkModeScreen.toggle()
                }
            }
        })
        .sheet(isPresented: $showDarkModeScreen) {
            UserDefaults.standard.setValue(1, forKey: "UserLogIN")
        } content: {
            ThemePrefrenceIntroView {
                showDarkModeScreen.toggle()
            }
            .interactiveDismissDisabled()
        }
    }
}

extension UserHomeScreen {
    
    func fetchCalData() {
        let userID = UserDefaults.standard.value(forKey: "UserID") as! String
        let descriptor = FetchDescriptor<CalorieModel>(predicate: #Predicate { calObj in
            calObj.userID == userID
        })
        do {
            foodDataStorage = try formData.fetch(descriptor)
            print("Data Successfully fetched")
        } catch {
            print("Error is: ", error.localizedDescription)
        }
    }
    
    // Request permission to read HealthKit data
    func requestAuthorization() {
        let readDataTypes = Set([
            HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!
        ])
        
        healthStore.requestAuthorization(toShare: nil, read: readDataTypes) { success, error in
            if !success {
                print("HealthKit authorization failed.")
            }
        }
    }
    
    // Fetch calories burned from HealthKit
    func fetchCaloriesBurnedFromHealthKit() {
        let energyType = HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned)!
        let startDate = Calendar.current.startOfDay(for: Date())
        let endDate = Date()
        
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictStartDate)
        
        let query = HKSampleQuery(sampleType: energyType, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { query, results, error in
            
            guard let results = results as? [HKQuantitySample] else {
                print("Error fetching calories burned: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            // Sum the calories burned
            let totalCaloriesBurned = results.reduce(0) { $0 + $1.quantity.doubleValue(for: HKUnit.kilocalorie()) }
            DispatchQueue.main.async {
                self.caloriesBurned = totalCaloriesBurned
            }
        }
        
        healthStore.execute(query)
    }
}
