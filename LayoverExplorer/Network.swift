//
//  Network.swift
//  LayoverExplorer
//
//  Created by Luis Castillo on 6/14/23.
//

import SwiftUI
import Foundation

class Network: ObservableObject {
    let API_URL = "http://127.0.0.1:5000"
    
    func getUrlRequestObject(_ pathname: String) -> URLRequest {
        guard let url = URL(string: API_URL + pathname) else { fatalError("Missing URL") }
        let urlRequest = URLRequest(url: url)

        return urlRequest
    }
    
    func callApi(_ urlRequest: URLRequest, _ method: String, _ body: Any?) async throws -> Data {
        var requestResponse: (Data, URLResponse)? = nil
        if (method == "GET") {
            requestResponse = try await URLSession.shared.data(for: urlRequest)
        }
        if (method == "POST") {
            requestResponse = try await URLSession.shared.upload(for: urlRequest, from: body as! Data)
        }
        
        let (_data, _response) = requestResponse!
        let response = _response as? HTTPURLResponse
        
        if response?.statusCode != 200 { fatalError("An error has ocurred while fetching API. Error: \(String(describing: response))") }
        
        return _data
    }
    
    func getAISuggestions() async -> [PlaceSuggested] {
        let parameters: [String: String] = [
            "place": "madrid",
            "thingsToDo": String(["1", "2", "3"]),
            "date": "2023-06-29 13:04:00 +0000"
        ]
        
        var suggestions: [PlaceSuggested] = []
        var urlRequest = getUrlRequestObject("/get-smart-trip")
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")

        do {
            let apiResponse = try? await callApi(urlRequest, urlRequest.httpMethod!, JSONSerialization.data(withJSONObject: parameters))

            guard let _apiResponse = apiResponse else {
                return []
            }

            let decodedSuggestions = try JSONDecoder().decode([PlaceSuggested].self, from: _apiResponse)
            
            suggestions = decodedSuggestions
        } catch {
            print("Error while waiting for chatgpt... or serializing")
            print(error)
        }
        
        return suggestions
    }
    
    func helloWorldFlask() async -> String {
        let urlRequest = getUrlRequestObject("/")
        let apiResponse = try? await callApi(urlRequest, "GET", nil)

        guard let apiResponse = apiResponse else {
            return "Error"
        }
        
        print(apiResponse)
        
        return "Lol"
    }

    
}
