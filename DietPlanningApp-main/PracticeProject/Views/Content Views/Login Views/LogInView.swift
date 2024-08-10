//
//  LogInView.swift
//  PracticeProject
//
//  Created by Aditya Majumdar on 07/08/24.
//

import SwiftUI
import SwiftData

struct LogInView: View {
    
    //MARK: - Property Wrappers for variables
    @Environment(\ .modelContext) var logInInfo
    @Query var arrSignUpUserData: [UserDataModel]
   
    @State private var txtUserName = ""
    @State private var txtPassWord = ""
    @State private var allowLogIn:Bool = false
    @State private var showsAlert:Bool = false
    @State var showProgress = false
    
    //MARK: - Body View
    var body: some View {
        NavigationStack{
            ZStack{
                Color.black.ignoresSafeArea()
                //MARK: - Text Feilds
                VStack{
                    Spacer()
                    Spacer()
                    Spacer()

                    LoginTextFeildView(textFeildStr: $txtUserName, placeHolder: "User Name", textFeildType: .regular)
                        .frame(height: 60)
                        .padding(.horizontal, 20.0)
                    LoginTextFeildView(textFeildStr: $txtPassWord, placeHolder: "Password", textFeildType: .passwordFeild)
                        .frame(height: 60)
                        .padding(.horizontal, 20.0)
                        .padding(.bottom, 5.0)
                    
                    //MARK: - Create account button
                    HStack{
                        Spacer()
                        NavigationLink {
                            SignUPScreen()
                        } label: {
                            Text("Create an account ?")
                                .font(.system(size: 16))
                                .foregroundStyle(Color.btnGradientColor)
                                .padding(.trailing, 25.0)
                        }
                    }.padding(.bottom, 5.0)
                    
                    //MARK: - Login button
                    Button{
                        if checkLogIn(){
//                            NavigationLink("") {
//                                TabListView()
//                            }
                            CommonFunctions.Functions.getHapticFeedback(impact: .light)
                        } else {
                            showsAlert = true
                            CommonFunctions.Functions.getHapticFeedback(impact: .heavy)
                            
                        }
                        
                    }label: {
                        Text("Login")
                            .foregroundStyle(Color.textColor)
                            .font(.system(size: 20))
                            .bold()
                    }
                    .frame(width:200, height: 50)
                    .background(Color.brownBlackGradient)
                    .cornerRadius(10).padding(.top, 20.0)
                    
                    .alert(isPresented: $showsAlert) {
                        
                        Alert(title: Text("Invalid Credentials"),
                              message: Text("You haven't added any data yet!"),
                              dismissButton: .default(Text("Ok"), action: {
                            self.showsAlert = false
                        })
                        )
                    }
                    Spacer()

                    HStack(spacing: 10){
                        //MARK: - Sign in with apple
                        
                        Button{
                            CommonFunctions.Functions.getHapticFeedback(impact: .heavy)
                        }label: {
                            HStack(spacing: 5){
                                Image(systemName: "apple.logo")
                                Text("Sign In With Apple")
                                    .minimumScaleFactor(0.2)
                                    .font(.system(size: 14))
                                .fontWeight(.medium)                            }.foregroundStyle(Color.black)
                            
                        }.frame(width:170, height: 50)
                            .background(Color.white)
                            .cornerRadius(10).padding(.top, 20.0)
                        
                        //MARK: - Sign in with google
                        Button{
                            CommonFunctions.Functions.getHapticFeedback(impact: .heavy)
                        }label: {
                            HStack(spacing: 5){
                                Image("google.logo").resizable()
                                    .frame(width: 20, height: 20)
                                Text("Sign In With Google")
                                    .minimumScaleFactor(0.2)
                                    .font(.system(size: 14))
                                    .fontWeight(.medium)
                            }.foregroundStyle(Color.black)
                                .padding(.horizontal, 5.0)
                        }.frame(width:170, height: 50)
                            .background(Color.white)
                            .cornerRadius(10).padding(.top, 20.0)
                    }.padding(.top, 5.0)
                    Spacer()
                
                }
                //MARK: - Toolbar Contents
                
            }.toolbar(content: {
                ToolbarItem(placement: .topBarLeading) {
                    Text("Sign In")
                        .bold()
                        .foregroundStyle(Color.btnGradientColor)
                        .font(.system(size: 30))
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button{
                        
                    }label: {
                        Image(systemName: "person.fill.questionmark")
                    }.foregroundStyle(Color.white)
                }
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink{
                     SettingsView(isLogInScreen: true)
                    }label: {
                        Image(systemName: "gear")
                    }.foregroundStyle(Color.white)
                }
            })
        }
        
    }
    
    func checkLogIn() -> Bool {
        let arrFilter = arrSignUpUserData.filter({$0.name == txtUserName && $0.passWord == txtPassWord})
        
        if arrFilter.count > 0 {
            /// if all data are matched then will return true
            arrFilter[0].isLoginApproved = true
            return true
        }
        return false
    }
}

#Preview {
    LogInView()
}
