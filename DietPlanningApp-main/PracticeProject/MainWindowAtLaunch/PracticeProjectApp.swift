//
//  PracticeProjectApp.swift
//  PracticeProject
//
//  Created by Aditya Majumdar on 07/08/24.
//
import SwiftData
import SwiftUI

@main
struct PracticeProjectApp: App {
    @StateObject private var vm = ScannerViewModel()
    @StateObject var nutriVM = NutritionViewModel()

    let container: ModelContainer

    var body: some Scene {
        WindowGroup {
            SplashScreen()
                .environmentObject(vm)
                .environmentObject(nutriVM)
                .modelContainer(container)
        }
    }

    init() {
        let schema = Schema([UserDataModel.self, Item.self])
        let config = ModelConfiguration("AppModel", schema: schema)
        do {
            container = try ModelContainer(for: schema, configurations: config)
        } catch {
            fatalError("Failed to load Core Data stack: \(error)")
        }
    }
}
