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
        guard let url = URL(string: API_URL) else { fatalError("Missing URL") }
        let urlRequest = URLRequest(url: url)

        return urlRequest
    }
    
    func callApi(urlRequest: URLRequest) async throws -> Data {
        let (_data, _response) = try await URLSession.shared.data(for: urlRequest)
        let response = _response as? HTTPURLResponse
        
        if response?.statusCode != 200 { fatalError("An error has ocurred while fetching API. Error: \(String(describing: response))") }
        
//            let decodedData = try JSONDecoder().decode(ApiBaseResponse.self, from: _data)
//
//            guard !sportsIoApi && decodedData.errors.count == 0 else {
//                fatalError("An error has ocurred while decoding API response: \(decodedData.errors)")
//            }
            
//            let serializedResponse = try JSONEncoder().encode(decodedData.response)
//
//            return serializedResponse
//        }
        
        return _data
    }
    
    func helloWorldFlask() async -> String {
        let urlRequest = getUrlRequestObject("/")
        let apiResponse = try? await callApi(urlRequest: urlRequest)

        guard let apiResponse = apiResponse else {
            return "Error"
        }
        
        print(apiResponse)
        
        return "Lol"
    }

    
}
