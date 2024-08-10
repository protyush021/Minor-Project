import SwiftUI
import SwiftData

struct CalculateDetailScreen: View {
    
    @Environment(\.modelContext) var modelContext
    
    //MARK: - Property Wrappers for variables
    @Binding var calCountDatabase: [CalorieModel]
    
    @State private var foodName: String = ""
    @State private var foodTotalCalories: String = ""
    @State private var consumedQuantity: String = ""
    @State private var protienInput: String = ""
    @State private var carbsInput: String = ""
    @State private var fatsInput: String = ""
    @State var suggestedMealArray : [String] = ["Item1","Item2","Item3","Item4"]
    @State var addMealToggle : Bool = false
    var dismissSheetHandler: (() -> Void)?
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    Section{
                        ScrollView(.horizontal){
                            LazyHGrid(rows: [GridItem()], alignment: .center, spacing: 10, content: {
                                ForEach(suggestedMealArray, id: \.self){ item in
                                    ZStack{
                                        ZStack(alignment: .topTrailing){
                                            RoundedRectangle(cornerRadius: 10)
                                                .fill(Color.textColor.opacity(0.15))
                                            Button{
                                                self.addMealToggle.toggle()
                                            }label: {
                                                Image(systemName: "plus.circle")
                                                    .foregroundStyle(Color.textColor.opacity(0.5))
                                                    .padding(10)
                                            }
                                        }.frame(width: 125, height: 125)
                                        VStack{
                                            Text("🥣")
                                                .font(.system(size: 30))
                                            Text("\(item)")                                                .font(.system(size: 20))
                                                .bold()
                                        }.padding()
                                    }
                                }
                            })
                        }.scrollIndicators(.hidden)
                                .listRowSeparator(.hidden)
                                .listRowBackground(Color.clear)
                            
                    }header: {
                        HStack{
                            Text("Suggestions")
                            Spacer()
                            Image(systemName: "chevron.right").bold()
                        }
                    }
                        Section("Add your meal info") {
                            TextField("Enter name of your food item", text: $foodName)
                        }
                        Section("Calories") {
                            TextField("Enter Calories per 100 gm", text: $foodTotalCalories).keyboardType(.numberPad)
                            TextField("Enter your Quantity Intake in gm", text: $consumedQuantity).keyboardType(.numberPad)
                        }
                        Section("Macros") {
                            TextField("Protien per 100 gm", text: $protienInput).keyboardType(.numberPad)
                            TextField("Carbs per 100 gm", text: $carbsInput).keyboardType(.numberPad)
                            TextField("Fats per 100 gm", text: $fatsInput).keyboardType(.numberPad)
                        }
                    }
                .listStyle(DefaultListStyle())
            }
            .onAppear(perform: {
                let userID =  UserDefaults.standard.value(forKey: "UserID") as! String

                let descriptor = FetchDescriptor<CalorieModel>(predicate: #Predicate { data in
                    data.userID == userID
                })
                do {
                    calCountDatabase = try modelContext.fetch(descriptor)
                }catch {
                    
                }
            })
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        if (foodName.count > 0) || (foodTotalCalories.count > 0) || (consumedQuantity.count > 0) || (protienInput.count > 0) || (carbsInput.count > 0) || (fatsInput.count > 0){
                            addData()
                        }
                        dismissSheetHandler?()
                    }) {
                        Image(systemName: "checkmark.rectangle.stack")
                            .foregroundColor(.accentColor) // Adjust color as needed
                    }
                }
            }
            .navigationTitle("Add your calorie intake")
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $addMealToggle) {
            } content: {
                
            }
        }
    }
    
    func addData() {
        if let intCal = Int(foodTotalCalories), let intQuantity = Int(consumedQuantity), let intProtien = Int(protienInput), let intCarbs = Int(carbsInput), let intFats = Int(carbsInput)  {
            
            let calorieCount = (intCal * intQuantity) / 100
            let protienCount = (intProtien * intQuantity) / 100
            let carbsCount = (intCarbs * intQuantity) / 100
            let fatsCount = (intFats * intQuantity) / 100
            let userID =  UserDefaults.standard.value(forKey: "UserID") as! String

            let calData = CalorieModel(userID        : userID,
                                       name          : foodName,
                                       calories      : intCal,
                                       quantity      : intQuantity,
                                       protien       : intProtien,
                                       carbs         : intCarbs,
                                       fats          : intFats,
                                       calCount      : calorieCount,
                                       protienCount  : protienCount,
                                       carbsCount    : carbsCount,
                                       fatsCount     : fatsCount)
            withAnimation {
                modelContext.insert(calData)
                CommonFunctions.Functions.getHapticFeedback(impact: .light)
            }
        } else { print("Error: Unable to convert one or both values to Int.")  }
    }
}
