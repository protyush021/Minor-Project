//
//  SplashScreen.swift
//  PracticeProject
//
//  Created by Aditya Majumdar on 07/08/24.
//

import SwiftUI
import SwiftData

struct SplashScreen: View {
    
    //MARK: - Property Wrappers for variables
    
    @State var isSplashScreenActive: Bool = false
    @StateObject private var vm = ScannerViewModel()

    @Query(filter: #Predicate<UserDataModel> { data in
        data.isLoginApproved == true
    }) var fetchDataBase: [UserDataModel]
    
    
    @Environment(\.modelContext) var formData

    //MARK: - Body View
    
    var body: some View {
        ZStack{
            if self.isSplashScreenActive {
                if fetchDataBase.count > 0 {
                    if fetchDataBase[0].isLoginApproved {
                        TabListView()
                            .environmentObject(vm)
                            .navigationBarBackButtonHidden()                        
                    } else { LogInView() }
                } else { LogInView() }
                
            } else {
                Color.black.ignoresSafeArea()
                VStack{
                    Text("Welcome Back !!!")
                        .fontWeight(.medium)
                        .foregroundStyle(Color.white)
                        .font(.system(size: 40))
                    Image("IconApp2")
                        .resizable()
                        .scaledToFit()
                }
            }
        }
        
        //MARK:  View will appear
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                withAnimation {
                    self.isSplashScreenActive = true
                }
            }
        }
    }
}

#Preview {
    SplashScreen()
}
