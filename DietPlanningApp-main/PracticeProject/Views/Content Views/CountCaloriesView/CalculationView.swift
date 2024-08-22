//
//  CalculationView.swift
//  PracticeProject
//
//  Created by Aditya Majumdar on 07/08/24.
//
import SwiftData
import SwiftUI

struct CalculationView: View {
    
    //MARK: - Property Wrappers for variables
    @Environment(\.modelContext) var formData
    @EnvironmentObject var vm: ScannerViewModel
    @State private var isSheetPresented = false
    @State private var foodDataStorage: [CalorieModel] = []
    @State var deleteSheetClicked : Bool = false
    
    var totalCalories: Int {
        foodDataStorage.reduce(0) { $0 + (Int($1.calCount) ) }
    }
    var totalProtien: Int {
        foodDataStorage.reduce(0) { $0 + (Int($1.protienCount) ) }
    }
    var totalCarbs: Int {
        foodDataStorage.reduce(0) { $0 + (Int($1.carbsCount) ) }
    }
    var totalFats: Int {
        foodDataStorage.reduce(0) { $0 + (Int($1.fatsCount) ) }
    }
    
    var body: some View {
        NavigationView{
            
            ZStack{
                if !(totalCalories > 0) {
                    AddYourDataView {
                        self.isSheetPresented.toggle()
                    }
                } else {
                    List{
                        Section{
                            TitleHeaderView()
                            VStack(spacing: 5){
                                ForEach(foodDataStorage) { item in
                                    CalculateRowCell(foodItem: item)
                                }
                            }
                        } .listRowBackground(Color.clear)
                            .listRowSeparatorTint(Color.clear)
                        
                        
                        Section(){
                            VStack{
                                HStack{
                                    Text("Total Protien")
                                        .font(.system(size: 16))
                                        .fontWeight(.regular)
                                        .minimumScaleFactor(0.2)
                                    Spacer()
                                    Text("\(totalProtien) g")
                                        .font(.system(size: 16))
                                        .fontWeight(.regular)
                                        .minimumScaleFactor(0.2)
                                }
                                .padding([.top, .leading, .trailing], 10.0)
                                
                                HStack{
                                    Text("Total Carbs")
                                        .font(.system(size: 16))
                                        .fontWeight(.regular)
                                        .minimumScaleFactor(0.2)
                                    Spacer()
                                    Text("\(totalCarbs) g")
                                        .font(.system(size: 16))
                                        .fontWeight(.regular)
                                        .minimumScaleFactor(0.2)
                                }
                                .padding([.top, .leading, .trailing], 10.0)
                                
                                HStack{
                                    Text("Total Fats")
                                        .font(.system(size: 16))
                                        .fontWeight(.regular)
                                        .minimumScaleFactor(0.2)
                                    Spacer()
                                    Text("\(totalFats) g")
                                        .font(.system(size: 16))
                                        .fontWeight(.regular)
                                        .minimumScaleFactor(0.2)
                                }
                                .padding([.top, .leading, .trailing], 10.0)
                                HStack{
                                    Text("Total calories")
                                        .font(.system(size: 16))
                                        .fontWeight(.regular)
                                        .minimumScaleFactor(0.2)
                                    Spacer()
                                    Text("\(totalCalories) Kcal")
                                        .font(.system(size: 16))
                                        .fontWeight(.regular)
                                        .minimumScaleFactor(0.2)
                                }.padding([.top, .leading, .trailing], 10.0)
                                
                            }
                            
                            .listRowSeparatorTint(Color.clear)
                        }
                    } .listStyle(PlainListStyle())
                        .background(Color.clear)
                }
            }
            .onAppear(perform: {
                fetchData()
                
            })
            .toolbar {
                if (totalCalories > 0) {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button{
                            isSheetPresented.toggle()
                        }label: {
                            Image(systemName: "note.text.badge.plus").foregroundStyle(Color.btnGradientColor)
                        }
                    }
                    ToolbarItem(placement: .topBarLeading) {
                        Button {
                            self.deleteSheetClicked.toggle()
                        } label: {
                            Image(systemName: "trash")
                                .foregroundStyle(Color.red)
                        }
                    }
                }
            }.alert("Are You Sure ?", isPresented: $deleteSheetClicked, actions: {
                Button(role: .destructive) {
                    self.deletCalorieChart()
                    self.fetchData()
                } label: {
                    Text("Delete")
                }

            })
            .sheet(isPresented: $isSheetPresented) {
                CalculateDetailScreen(
                    calCountDatabase: $foodDataStorage, dismissSheetHandler: {
                        isSheetPresented.toggle()
                        fetchData()
                    }
                )
                .presentationDetents([.large])
            }
            .navigationTitle("Calories")
        }
    }
    
    func fetchData(){
        let userID =  UserDefaults.standard.value(forKey: "UserID") as! String
        let descriptor = FetchDescriptor<CalorieModel>(predicate: #Predicate { data in
            data.userID == userID
        })
        do {
            foodDataStorage = try formData.fetch(descriptor)
            print(foodDataStorage)
        }catch {
            
        }
    }
    
    func deleteItemAtRow(_ indexSet: IndexSet){
        for index in indexSet {
            let destination = foodDataStorage[index]
            formData.delete(destination)
        }
    }
    
    func deletCalorieChart(){
        do {
            let userID =  UserDefaults.standard.value(forKey: "UserID") as! String
            try formData.delete(model: CalorieModel.self, where: #Predicate { calorieData in
                calorieData.userID == userID
            })
        }
        catch {
            print("Failed to clear all data.")
        }
    }
}

#Preview {
    CalculationView()
}
