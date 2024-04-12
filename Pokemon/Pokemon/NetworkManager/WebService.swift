//
//  WebService.swift
//  Pokemon
//
//  Created by Ece Ok, Vodafone on 10.04.2024.
//
import Alamofire
import Foundation


    
final class Webservice {
        
    static let shared = Webservice()
    
    func request<T: Decodable>(request: URLRequestConvertible, decodeToType type: T.Type, completionHandler: @escaping (Result<T, Error>) -> Void) {
        
        AF.request(request).responseData { response in
            switch response.result {
            case .success(let data):
                do {
                    let decodedData = try JSONDecoder().decode(T.self, from: data)
                    completionHandler(.success(decodedData))
                } catch {
                    completionHandler(.failure(error)) // JSON decode hatası
                }
            case .failure(let error):
                completionHandler(.failure(error)) // Ağ iletişim hatası
            }
        }
    }
}

