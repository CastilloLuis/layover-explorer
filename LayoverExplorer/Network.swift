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
    
    func getAISuggestions(_ place: String, _ thingsToDo: [String], _ date: String, _ hours: String) async -> [SuggestedPlace] {
        let parameters: [String: Any?] = [
            "place": place,
            "thingsToDo": thingsToDo,
            "date": date,
            "hours": hours
        ]
        var suggestions: [SuggestedPlace] = []

        do {
            var urlRequest = getUrlRequestObject("/get-smart-trip")
            urlRequest.httpMethod = "POST"
            urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            let apiResponse = try? await callApi(urlRequest, urlRequest.httpMethod!, JSONSerialization.data(withJSONObject: parameters))

            guard let _apiResponse = apiResponse else {
                return []
            }

            let decodedSuggestions = try JSONDecoder().decode([SuggestedPlace].self, from: _apiResponse)
            
            suggestions = decodedSuggestions
        } catch {
            print("Error while waiting for chatgpt... or serializing")
            print(error)
        }
        
        return suggestions
    }
    
    func getCountries() async -> [Country] {
        var countries: [Country] = []
        
        do {
            var urlRequest = getUrlRequestObject("/get-countries")
            urlRequest.httpMethod = "GET"
            
            let apiResponse = try? await callApi(urlRequest, urlRequest.httpMethod!, nil)
            guard let _apiResponse = apiResponse else {
                return []
            }
            
            let decodedCountries = try JSONDecoder().decode([Country].self, from: _apiResponse)
            
            countries = decodedCountries
        } catch {
            print("Error while getting countries...")
            print(error)
        }
        return [countries[0], countries[1], countries[2], countries[3], countries[4], countries[5], countries[6]]
    }
    
}
