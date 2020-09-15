//
//  APIManager.swift
//  ForecastAPiTest
//
//  Created by Anastasiya Osinskaya on 9/14/20.
//  Copyright © 2020 Anastasiya Osinskaya. All rights reserved.
//

import Foundation
import Alamofire

final class APIManager {
    
    // MARK: - Constants
    
    private struct Constants {
        static let contentTypeAppJson = ["Content-Type": "application/json"]
        static let imageCompressionQuality: CGFloat = 1
        static let lat = "lat"
        static let lon = "lon"
        static let lang = "lang"
        static let limit = "limit"
        static let hours = "hours"
        static let extra = "extra"
        static let wrongMessage = "Something went wrong."
        static let decodeDataMessage = "Can't decode data."
        static let responseCodeMessage = "Response with status code: "
        static let noNewsYetToday = "no news yet today"
    }
    
    // MARK: - URLs
    
    enum URLs {
        static let baseURL = "https://api.weather.yandex.ru/v2/forecast?"
        static let lat = "lat="
        static let lon = "&lon="
        static let extra = "&extra="
        static let apiKey = "9a5a159d-13fb-4143-953f-603c84025062"
    }
    
    // MARK: - QueryItems
    
    enum QueryItems {
        case lat(_ lat: Double)
        case lon(_ lon: Double)
        case extra(_ extra: Bool)
        
        var urlQueryItem: URLQueryItem {
            switch self {
            case .extra(let extra):
                return URLQueryItem(name: Constants.extra, value: String(extra))
            case .lat(let lat):
                return URLQueryItem(name: Constants.lat, value: String(lat))
            case .lon(let lon):
                return URLQueryItem(name: Constants.lon, value: String(lon))
            }
        }
    }
    
    // MARK: - Properties
    
    static let shared = APIManager()
    
    // MARK: - Init
    
    private init() { }
    
    // MARK: - Weather API
    
    func getModel(queryItems: [QueryItems], completion: @escaping(_ result: Result<Weather, Error>) -> Void) {
        let url = URLs.baseURL
        let parameters = ["X-Yandex-API-Key": "ad4b89ce-cb2c-4cde-84f7-4b0ff1194139"]
        request(for: url, queryItems: queryItems.map { $0.urlQueryItem }, parameters: parameters, completion: completion)
    }
    
    // MARK: - Requests
    
    private func request<T: Codable>(for url: String, queryItems: [URLQueryItem], parameters: [String: String] = [:], method: HTTPMethod = .get, completion: @escaping(_ result: Result<T, Error>) -> Void) {
        var urlComp = URLComponents(string: url)
        urlComp?.queryItems = queryItems
        guard var request = try? URLRequest(url: urlComp!.url!, method: method) else {
            let error = NSError.error(with: Constants.wrongMessage)
            completion(.failure(error))
            return
        }
        request.httpMethod = method.rawValue
        request.headers = HTTPHeaders(parameters)
        AF.request(request).responseData { [weak self] (response) in
            guard let self = self else {
                let error = NSError.error(with: Constants.wrongMessage)
                completion(.failure(error))
                return
            }
            completion(self.processResponse(response))
        }
    }
    
    private func request<T: Codable>(for url: String, parameters: [String: String] = [:], method: HTTPMethod = .get, completion: @escaping(_ result: Result<T, Error>) -> Void) {
        guard var request = try? URLRequest(url: url, method: method) else {
            let error = NSError.error(with: Constants.wrongMessage)
            completion(.failure(error))
            return
        }
        request.httpMethod = method.rawValue
        request.headers = HTTPHeaders(parameters)
        AF.request(request).responseData { [weak self] (response) in
            guard let self = self else {
                let error = NSError.error(with: Constants.wrongMessage)
                completion(.failure(error))
                return
            }
            completion(self.processResponse(response))
        }
    }
    
    // MARK: - Helpers
    
    private func processResponse<T: Codable>(_ response: AFDataResponse<Data>) -> Result<T, Error> {
        let result: Result<T, Error> = self.dataDecoder(response.data)
        switch result {
        case .success(let object):
            return .success(object)
        case .failure(let error):
            return .failure(error)
        }
    }
    
    private func dataDecoder<T: Codable>(_ data: Data?) -> Result<T, Error> {
        guard let data = data else {
            return .failure(NSError.error(with: Constants.decodeDataMessage))
        }
        let decoder = JSONDecoder()
        do {
            let object = try decoder.decode(T.self, from: data)
            return .success(object)
        } catch {
            print(error.localizedDescription)
            return .failure(NSError.error(with: Constants.decodeDataMessage))
        }
    }
}
