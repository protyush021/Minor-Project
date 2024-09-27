//
//  RapidAPIModel.swift
//  PracticeProject
//
//  Created by Aditya Majumdar on 27/09/24.
//

import Foundation

// Define the RapidAPI headers with your API key and host.
let headers = [
    "x-rapidapi-key": "fa046b92femsh0adc27ab4a35195p1baea8jsn1edf90983e22",
    "x-rapidapi-host": "img4me.p.rapidapi.com"
]

// Function to generate an image from text
func generateImageFromText(text: String) {
    // URL encoding the text for the API request
    guard let encodedText = text.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
          let url = URL(string: "https://img4me.p.rapidapi.com/?text=\(encodedText)&font=trebuchet&size=12&fcolor=000000&bcolor=FFFFFF&type=png") else {
        print("Invalid URL")
        return
    }

    // Create a mutable URL request
    var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
    request.httpMethod = "GET"
    request.allHTTPHeaderFields = headers

    // Create a URL session data task
    let session = URLSession.shared
    let dataTask = session.dataTask(with: request) { (data, response, error) in
        // Handle error
        if let error = error {
            print("Error: \(error.localizedDescription)")
            return
        }

        // Handle the response
        guard let httpResponse = response as? HTTPURLResponse else {
            print("Invalid response")
            return
        }

        // Print the HTTP response status code
        print("HTTP Response Status Code: \(httpResponse.statusCode)")

        // If there's data, handle it (e.g., save the image)
        if let data = data {
            // You can process the image data here
            // Example: Convert to UIImage (if this is for an iOS app)
            // let image = UIImage(data: data)
        }
    }

    // Start the data task
    dataTask.resume()
}

