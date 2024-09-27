//
//  UserHomeScreen.swift
//  PracticeProject
//
//  Created by Aditya Majumdar on 07/08/24.
//

import SwiftUI
import SwiftData
import HealthKit

struct UserHomeScreen: View {
    @Namespace var profileAnimation
    @Environment(\.modelContext) var formData
    @EnvironmentObject var vm: ScannerViewModel
    @State private var isLoading = false
    @State private var errorMessage: String?
    @State private var foodDataStorage: [CalorieModel]      = []
    @State private var arrHomeItems   : [ActivityCardModel] = [
        ActivityCardModel(title: "New", bgColor: Color.brownBlackGradient),
        ActivityCardModel(title: "Favourites", bgColor: Color.titleGradientColor),
        ActivityCardModel(title: "Trending", bgColor: Color.orangeYellowGradient),
        ActivityCardModel(title: "Suggestions", bgColor: Color.btnGradientColor2)
    ]
    @State private var arrSideItems : [ActivityCardModel] = [
        ActivityCardModel(title: "Track",subTitle: "Have a track of your calories", bgColor: Color.brownBlackGradient),
        ActivityCardModel(title: "BMI",subTitle: "Calculate your BMI and get personal suggestions for your diet and workout", bgColor: Color.redYellowGradient),
        ActivityCardModel(title: "Monitor",subTitle: "Monitor your nutrition charts", bgColor: Color.btnGradientColor2),
        ActivityCardModel(title: "Tips",subTitle: "Want to know more..?", bgColor: Color.cardGradient)
    ]
    @State private var totalCaloriesStr : String = "0"
    @StateObject private var healthKitManager = HealthKitManagerHome()
    @State private var drawingStroke = false
    @State private var onlineImageExpanded = false
    @State private var showDarkModeScreen = false
    @State var selectedOnlineImage: UIImage?
    @State private var foodRecommendations: [FoodItemWithImage] = []
    @Binding var tabItemTag : Int
    @StateObject var apiManager = APIManager()
    @Environment(\.modelContext) var modelContext
    @Query(sort: \Item.timestamp, order: .reverse) var items: [Item]
    @State private var selectedHour: Date? = nil
    
    
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
        foodDataStorage.reduce(0) { $0 + (Int($1.calCount) ) }
    }
    
    var cardHeight : CGFloat = 200
    let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 2)
    
    var body: some View {
            ScrollView(.vertical) {
                Section{
                    ZStack{
                        RoundedRectangle(cornerRadius: 15)
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
                                VStack(alignment: .leading) {
                                    Text("Total Intake")
                                        .bold()
                                        .font(.system(size: 14))
                                        .foregroundStyle(Color.textColor)
                                    HStack(spacing: 2) {
                                        Text("\(Int(todaysNutrition.calories.rounded()))")
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
                            
                            ActivityProgressView(drawingStroke: $drawingStroke)
                                .onAppear { drawingStroke = true }
                        }.padding()
                    }.frame(height: cardHeight-15)
                        .padding(.horizontal)
                    
                }header: {
                    NavigationLink {
                        UserStatisticsView()
                    } label: {
                        HStack{
                            Text("Your Activity")
                                .bold()
                                .font(.title2)
                                .foregroundStyle(Color.textColor)
                            Image(systemName: "chevron.right").bold()
                            Spacer()
                        }.padding([.horizontal, .top])
                    }.tint(Color.textColor)
                }
                
                Section {
                    ScrollView(.horizontal) {
                        LazyHGrid(rows: [GridItem()], alignment: .center, spacing: 20) {
                            ForEach(foodRecommendations.prefix(10), id: \.foodItem.foodName) { foodItemWithImage in
                                VStack {
                                    // Use local images from assets instead of API
                                    let index = foodRecommendations.firstIndex(of: foodItemWithImage) ?? 0
                                    let imageName = "\(index + 1)" // Image names are "1", "2", ..., "10"

                                    Image(imageName) // Load from assets
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 150, height: 150)
                                        .clipShape(RoundedRectangle(cornerRadius: 10))

                                    Text(foodItemWithImage.foodItem.foodName)
                                        .font(.footnote)
                                        .multilineTextAlignment(.center)
                                        .frame(width: 150)
                                        .lineLimit(5)
                                        .truncationMode(.tail)
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                    .scrollIndicators(.hidden)
                } header: {
                    HStack {
                        Text("Recommended Foods")
                            .bold()
                            .font(.title2)
                            .foregroundStyle(Color.textColor)
                        Spacer()
                    }
                    .padding([.horizontal, .top])
                }

                
                Section{
                    ScrollView(.horizontal){
                        LazyHGrid(rows: [GridItem()], alignment: .center, spacing: 10, content: {
                            ForEach(arrSideItems) { home in
                                if let title = home.title, let subTitle = home.subTitle, let gradient = home.bgColor {
                                    
                                    ZStack(alignment: .topLeading){
                                        ZStack(alignment: .bottom){
                                            RoundedRectangle(cornerRadius: 10)
                                                .fill(gradient)
                                            ZStack(alignment: .center){
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
                                            if title == "Track"{
                                                tabItemTag = 1
                                            }else if title == "Monitor"{
                                                tabItemTag = 2
                                            }else if title == "BMI"{
                                                
                                            }else if title == "Tips"{
                                                
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
                        }).padding(.horizontal)
                    } .scrollIndicators(.hidden)
                } header: {
                    HStack{
                        Text("For you")
                            .bold()
                            .font(.title2)
                            .foregroundStyle(Color.textColor)
                        Spacer()
                    }.padding([.horizontal, .top])
                    
                }
                Section{
                    LazyVGrid(columns: [GridItem()], alignment: .center, spacing: 30, content: {
                        ForEach(arrHomeItems) { home in
                            if let title = home.title {
                                if let gradient = home.bgColor{
                                    
                                    VStack(alignment: .leading, spacing: 0){
                                        Text("\(title)")
                                            .bold()
                                            .font(.title)
                                            .foregroundStyle(Color.textColor)
                                        
                                        ZStack(alignment: .bottom){
                                            RoundedRectangle(cornerRadius: 15)
                                                .fill(gradient)
                                            ZStack(alignment: .center){
                                                UnevenRoundedRectangle(topLeadingRadius: 0, bottomLeadingRadius: 15, bottomTrailingRadius: 15, topTrailingRadius: 0)
                                                    .fill(Color.black.opacity(0.5))
                                                Text("This is for purely text purpose which need to be edited later")
                                                    .font(.footnote)
                                                    .multilineTextAlignment(.center)
                                                    .lineLimit(3)
                                                    .foregroundStyle(Color.white)
                                                    .padding(5)
                                            }
                                            .frame(height: 75)
                                        }
                                    }.frame(height: 450)
                                        .padding(.horizontal)
                                        .onTapGesture {
                                            if title == "New"{
                                                
                                            }else if title == "Favourites"{
                                                
                                            }else if title == "Trending"{
                                                
                                            }else if title == "Suggestions"{
                                                
                                            }
                                        }
                                }
                            }
                        }
                    })
                } header: {
                    HStack{
                        Text("For you")
                            .bold()
                            .font(.title2)
                            .foregroundStyle(Color.textColor)
                        Spacer()
                    }.padding([.horizontal, .top])
                }
            }.onAppear(perform: {
                fetchCalData()
                fetchFoodRecommendations()
                totalCaloriesStr = foodDataStorage.count > 0 ? String(totalCalories) : "0"
                if let user = UserDefaults.standard.object(forKey: "UserLogIN")as? Int, user == 0{
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
                        showDarkModeScreen.toggle()
                    }
                }
            })
            
            .sheet(isPresented: $showDarkModeScreen) {
                UserDefaults.standard.setValue(1, forKey: "UserLogIN")
            } content: {
                ThemePrefrenceIntroView {
                    showDarkModeScreen.toggle()
                }.interactiveDismissDisabled()
            }
    }
}
extension UserHomeScreen {
    func fetchFoodRecommendations() {
            isLoading = true
            let calorieIntake = Int(todaysNutrition.calories.rounded())
            let calorieBurned = Int(healthKitManager.caloriesBurned)
            let dailyCalorieGoal = 2250
            let remainingCalories = dailyCalorieGoal - (calorieIntake - calorieBurned)

            // Time-based calorie allocation
            let currentTime = Calendar.current.component(.hour, from: Date())
            var mealCalories: Int
            if (5...10).contains(currentTime) {
                mealCalories = remainingCalories / 3
            } else if (12...14).contains(currentTime) {
                mealCalories = remainingCalories / 2
            } else if (19...21).contains(currentTime) {
                mealCalories = remainingCalories
            } else {
                mealCalories = remainingCalories / 4
            }

            // Fetch food recommendations with a limit of 10 items
            apiManager.fetchUSDAFoodRecommendations(mealCalories: mealCalories) { result in
                DispatchQueue.main.async {
                    self.isLoading = false
                    switch result {
                    case .success(let foods):
                        let filteredFoods = foods.filter { foodItemWithImage in
                            let estimatedCaloriesForFood = foodItemWithImage.foodItem.nfCalories ?? 0
                            return (Double(calorieIntake) + estimatedCaloriesForFood) <= Double(dailyCalorieGoal)
                        }

                        self.foodRecommendations = filteredFoods.isEmpty ? Array(foods.prefix(10)) : Array(filteredFoods.prefix(10))

                        // Set the limit for concurrent image generation requests
//                        let maxImageRequests = 5
//                        var currentImageRequests = 0
//
//                        // Generate images for each food item
//                        for index in self.foodRecommendations.indices {
//                            if currentImageRequests < maxImageRequests {
//                                currentImageRequests += 1
//                                let foodName = self.foodRecommendations[index].foodItem.foodName
//                                self.generateImage(for: foodName) { image in
//                                    DispatchQueue.main.async {
//                                        if let generatedImage = image {
//                                            self.foodRecommendations[index].generatedImage = generatedImage
//                                        }
//                                        currentImageRequests -= 1
//                                    }
//                                }
//                            } else {
//                                // If too many requests are ongoing, wait and retry after a delay
//                                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
//                                    let foodName = self.foodRecommendations[index].foodItem.foodName
//                                    self.generateImage(for: foodName) { image in
//                                        DispatchQueue.main.async {
//                                            if let generatedImage = image {
//                                                self.foodRecommendations[index].generatedImage = generatedImage
//                                            }
//                                        }
//                                    }
//                                }
//                            }
//                        }

                    case .failure(let error):
                        self.errorMessage = "Error fetching food recommendations: \(error.localizedDescription)"
                    }
                }
            }
        }
//    private func generateImage(for foodName: String, completion: @escaping (UIImage?) -> Void) {
//        // Define your API key
//        let apiKey = "lmwr_sk_nnsZ7QCqdX_5Uqox75s5l8LcIyqaFwHKSVmTsjm3nrHBseK3" // Replace with your actual LimeWire API key
//
//        guard let url = URL(string: "https://api.limewire.com/v1/text-to-image") else {
//            print("Invalid URL")
//            completion(nil)
//            return
//        }
//
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.setValue(apiKey, forHTTPHeaderField: "Authorization") // Assuming LimeWire uses Bearer token
//
//        // Use a simple, trimmed prompt
//        let parameters: [String: Any] = [
//            "prompt": foodName.trimmingCharacters(in: .whitespacesAndNewlines) // Trimmed prompt
//        ]
//
//        do {
//            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
//        } catch {
//            print("Error encoding parameters: \(error)")
//            completion(nil)
//            return
//        }
//
//        // Log the request for debugging
//        if let bodyString = String(data: request.httpBody!, encoding: .utf8) {
//            print("Request Body: \(bodyString)")  // Check if this includes "prompt"
//        }
//
//        let task = URLSession.shared.dataTask(with: request) { data, response, error in
//            if let error = error {
//                print("Error fetching image: \(error)")
//                completion(nil)
//                return
//            }
//
//            guard let data = data else {
//                print("No data received")
//                completion(nil)
//                return
//            }
//
//            do {
//                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
//                    print("Parsed JSON: \(json)")
//                    // Adjust based on LimeWire's response format
//                    if let imageUrlString = json["image_url"] as? String,
//                       let imageUrl = URL(string: imageUrlString) {
//                        self.downloadImage(from: imageUrl, completion: completion)
//                    } else {
//                        print("Failed to find image URL in JSON")
//                        completion(nil)
//                    }
//                } else {
//                    print("Failed to parse JSON")
//                    completion(nil)
//                }
//            } catch {
//                print("Error decoding JSON: \(error)")
//                completion(nil)
//            }
//        }
//
//        task.resume()
//    }
//    // Helper function to download the image
//    private func downloadImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
//        let task = URLSession.shared.dataTask(with: url) { data, response, error in
//            if let error = error {
//                print("Error downloading image: \(error)")
//                completion(nil)
//                return
//            }
//
//            guard let data = data, let image = UIImage(data: data) else {
//                print("No data received or invalid image data")
//                completion(nil)
//                return
//            }
//
//            completion(image)
//        }
//        task.resume()
//    }


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
}

extension APIManager {
    func fetchUSDAFoodRecommendations(mealCalories: Int, completion: @escaping (Result<[FoodItemWithImage], Error>) -> Void) {
        // Define the API URL for USDA Food Search
        let urlString = "https://api.nal.usda.gov/fdc/v1/foods/search?api_key=vJXWHeYc8EaCFQMdVrJSRl7oXmTdgnHB9V7eTgan&max=10&query=food"
            .addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        
        guard let url = URL(string: urlString) else {
            completion(.failure(APIError.invalidURL))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                completion(.failure(APIError.serverError("Server responded with an error")))
                return
            }

            guard let data = data else {
                completion(.failure(APIError.noData))
                return
            }

            do {
                let decoder = JSONDecoder()
                let usdaResponse = try decoder.decode(USDAFoodSearchResponse.self, from: data)

                // Process and filter food items based on calories
                let foods = usdaResponse.foods.compactMap { usdaFood -> FoodItemWithImage? in
                    // Convert USDAFoodItem to FoodItem using the toFoodItem() method
                    let foodItem = usdaFood.toFoodItem()
                    
                    let foodCalories = foodItem.nfCalories ?? 0.0  // Access nfCalories from FoodItem

                    // Check if the food calories are less than or equal to mealCalories
                    if foodCalories <= Double(mealCalories) {
                        let photoUrl = usdaFood.photoUrl // Ensure this property exists in your USDAFoodItem model
                        return FoodItemWithImage(foodItem: foodItem, photoUrl: photoUrl)
                    }
                    return nil
                }

                completion(.success(foods))
            } catch {
                completion(.failure(APIError.decodingError))
            }
        }
        task.resume()
    }
}


#Preview {
    UserHomeScreen(tabItemTag: .constant(0))
}

struct ActivityCardModel: Identifiable {
    var id = UUID()
    var title : String?
    var subTitle : String?
    var bgColor : LinearGradient?
    var bgImage : String?
}
struct FoodItemWithImage: Equatable {
    let foodItem: FoodItem
    var generatedImage: UIImage?
    let photoUrl: String?

    // Conformance to Equatable
    static func == (lhs: FoodItemWithImage, rhs: FoodItemWithImage) -> Bool {
        return lhs.foodItem.foodName == rhs.foodItem.foodName &&
               lhs.generatedImage == rhs.generatedImage &&
               lhs.photoUrl == rhs.photoUrl
    }
}

struct FoodResponse: Decodable {
    let foods: [FoodItem]
}
struct Photo: Decodable {
    let thumb: String
}
struct NutritionixFood: Decodable {
    let foodName: String
    let photo: Photo
}
struct USDAFoodResponse: Decodable {
    let foods: [USDAFoodItem]
}


enum APIError: Error {
    case invalidURL
    case noData
    case decodingError
    case serverError(String)
    
    var localizedDescription: String {
        switch self {
        case .invalidURL:
            return "The URL is invalid."
        case .noData:
            return "No data was received from the server."
        case .decodingError:
            return "Failed to decode the response."
        case .serverError(let message):
            return "Server error: \(message)"
        }
    }
}
