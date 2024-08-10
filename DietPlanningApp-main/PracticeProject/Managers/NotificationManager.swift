//
//  NotificationManager.swift
//  PracticeProject
//
//  Created by Aditya Majumdar on 07/08/24.
//

import Foundation
import UserNotifications

@MainActor
class NotificationManager : ObservableObject{
    
    @Published var permissionsEnabled = false
    
    init(){
        Task{
            await getAuthorisationStatus()
        }
    }
    
    func request() async{
        do {
            try await UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound])
            await getAuthorisationStatus()
        }catch{
            print(error)
        }
    }
    

    func getAuthorisationStatus() async {
        let status = await UNUserNotificationCenter.current().notificationSettings()
        
        switch status.authorizationStatus {
        case .authorized:
            permissionsEnabled = true
        default:
            permissionsEnabled = false
        }
    }
    
    func stopNotifications() async {
           do {
               // Remove all delivered notifications
                UNUserNotificationCenter.current().removeAllDeliveredNotifications()
               
               //Remove all pending notification requests
                UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
               
               // Optional: Reset authorization status to .notDetermined if needed
               try await UNUserNotificationCenter.current().requestAuthorization(options: [])
               
               // Update permissions status
               await getAuthorisationStatus()
           } catch {
               print(error)
           }
       }
}
