//
//  AddWorkoutSheduleView.swift
//  PracticeProject
//
//  Created by Aditya Majumdar on 07/08/24.
//

import SwiftUI
import SwiftData

struct AddWorkoutSheduleView: View {
    
    @State private var selectedDay: String = "Monday"
    @State   var arrDays:[String] = ["Monday", "Tuesday", "Wednesday", "Thursday","Friday", "Saturday", "Sunday"]
    @State var showIndicator : Bool = false
    @EnvironmentObject var vm: ScannerViewModel
    @Binding var strSelectedType : String
    @Binding var sheduleChart: [SheduleWorkoutModel]
    
    @Environment(\.modelContext) var modelContext
    
    var dismissHandler : (() -> Void)?
    
    var body: some View {
        NavigationStack{
            ZStack{
                Color.black.ignoresSafeArea()
                VStack(spacing: 10){
                    LoginTextFeildView(textFeildStr: $strSelectedType, placeHolder: "Write Type", strUsername: "", showEditButton: false, textFeildType: .regular).frame(height: 60)
                    
                    ZStack{
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.white.opacity(0.15))
                        
                        HStack{
                            Text("Select Day")
                                .foregroundStyle(Color.white)
                                .padding()
                            Spacer()
                            Picker("Select Day", selection: $selectedDay) {
                                ForEach(arrDays, id: \.self){ i in
                                    Text("\(i)").foregroundStyle(Color.white)
                                        .tag(i)
                                }
                            }.pickerStyle(MenuPickerStyle())
                        }
                    }.frame(height: 60)
                }.padding()
            }
            .toolbar(content: {
                ToolbarItem(placement: .topBarTrailing) {
                    Button{
                      addData()
                        dismissHandler?()
                    }label: {
                        Image(systemName: "bookmark")
                    }.foregroundStyle(Color.blue)
                }
            })
            .toolbar(content: {
                ToolbarItem(placement: .topBarLeading) {
                    Text("Shedule")
                        .bold()
                        .foregroundStyle(Color.white)
                        .font(.largeTitle)
                }
            })
        }
    }
    
    func btnSaveClicked(){
        if strSelectedType != ""{
            
        }
    }
    
    func addData() {
        let userID =  UserDefaults.standard.value(forKey: "UserID") as! String
        let userSheduleData = SheduleWorkoutModel(userID: userID, day: selectedDay, workoutType: strSelectedType)
        withAnimation {
            modelContext.insert(userSheduleData)
            CommonFunctions.Functions.getHapticFeedback(impact: .light)
        }
    }
}

#Preview {
    AddWorkoutSheduleView(strSelectedType: .constant(""), sheduleChart: .constant([]))
}
