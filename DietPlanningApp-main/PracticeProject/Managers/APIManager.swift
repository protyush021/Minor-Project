//
//  APIManager.swift
//  PracticeProject
//
//  Created by Aditya Majumdar on 07/08/24.
//

import SwiftUI
import Foundation

final class APIManager: ObservableObject {
    
    static let shared = APIManager()
    
    @Published var imageArray: [OnlineImageModel] = []
    
    private let baseURL = "https://trackapi.nutritionix.com/v2/search/item"
    
    // Load images from API
    func loadImagesFromAPIUrl() async {
        guard let url = URL(string: "https://picsum.photos/200/200") else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let response = response as? HTTPURLResponse, let data = data {
                print("Status Code: \(response.statusCode)")
                
                if response.statusCode == 200 {
                    let onlineImage = OnlineImageModel(imageData: data)
                    
                    DispatchQueue.main.async {
                        self.imageArray.append(onlineImage)
                    }
                }
            } else {
                if let error = error {
                    print("Error: \(error)")
                }
            }
        }.resume()
    }
    
    // Search for a food item by barcode using URLSession
    func searchItem(with barcode: String) async throws -> [FoodItem] {
        var urlComponents = URLComponents(string: baseURL)!
        urlComponents.queryItems = [
            URLQueryItem(name: "upc", value: barcode)
        ]
        
        guard let url = urlComponents.url else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("f784c79c", forHTTPHeaderField: "x-app-id")
        request.addValue("da5a32319b55edcbae5aab9bd2cdb5ce", forHTTPHeaderField: "x-app-key")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        let decoder = JSONDecoder()
        let foodResponse = try decoder.decode(FoodsResponse.self, from: data)
        return foodResponse.foods
    }
}
