//
//  SheduleWorkOutView.swift
//  PracticeProject
//
//  Created by Aditya Majumdar on 07/08/24.
//

import SwiftUI
import SwiftData

struct SheduleWorkOutView: View {
    
    @State private var userWorkout: [SheduleWorkoutModel] = []
    @State private var presentWorkoutSheet : Bool = false
    @Environment (\.modelContext) var formData
    @State var selectedDay = ""
    @State var selectedWorkoutType = ""
    @State var showDeleteAlert : Bool = false
    
    var body: some View {
        NavigationStack{
            ZStack {
                if (userWorkout.count == 0){
                    AddYourDataView(addButtonBlockHandler: {
                        self.presentWorkoutSheet.toggle()
                    })
                }else {
                    List {
                        ForEach(userWorkout){ item in
                            WorkoutRowCell(workoutModel: item)
                                .listRowBackground(Color.clear)
                                .listRowSeparator(.hidden)
                        }
                    }.listStyle(PlainListStyle())
                }
            }.onAppear(perform: {
                fetchData()
            })
            .navigationTitle("My Workout")
            .toolbar(){
                ToolbarItem(placement: .topBarLeading) {
                    if (userWorkout.count != 0){
                        Button{
                            showDeleteAlert = true
                        }label: {
                            Image(systemName: "trash")
                                .foregroundStyle(Color.red)
                        }.alert(isPresented: $showDeleteAlert) {
                            Alert(title: Text("Confirm!!!"), message: Text("This action deletes your workout chart"), primaryButton: .destructive(Text("Delete"),
                                                                                                                                           action: {
                                deletCalorieChart()
                                fetchData()
                                
                            }), secondaryButton: .cancel())
                        }
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    HStack{
                            NavigationLink {
                                ImageGalleryView()
                            } label: {
                                Image(systemName: "photo.on.rectangle.angled")
                                    .foregroundStyle(Color.btnGradientColor)
                            }
                        
                        if (userWorkout.count != 0){
                            Button{
                                self.presentWorkoutSheet.toggle()
                                CommonFunctions.Functions.getHapticFeedback(impact: .light)
                            }label: {
                                Image(systemName: "plus.app")
                                    .foregroundStyle(Color.btnGradientColor)
                            }
                        }
                    }
                }
            }
        }.sheet(isPresented: $presentWorkoutSheet, onDismiss: {
            fetchData()
        }, content: {
            AddWorkoutSheduleView(strSelectedType: $selectedWorkoutType, sheduleChart: $userWorkout) {
                self.presentWorkoutSheet.toggle()
            }
                .presentationDetents([.fraction(0.75), .large])
        })
    }
    
    func fetchData(){
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
    func deletCalorieChart(){
        do {
            let userID =  UserDefaults.standard.value(forKey: "UserID") as! String
            try formData.delete(model: SheduleWorkoutModel.self, where: #Predicate { workout in
                workout.userID == userID
            })
        }
        catch {
            print("Failed to clear all data.")
        }
    }
}

#Preview {
    SheduleWorkOutView()
}
