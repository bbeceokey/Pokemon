//
//  Routes.swift
//  Pokemon
//
//  Created by Ece Ok, Vodafone on 10.04.2024.
//

import Foundation
import Alamofire

enum Router: URLRequestConvertible {

    case getpokemons
    case getPokemonAbilities(url: String)

    var method: HTTPMethod {

        return .get
        
    }
    
    var parameters: [String: Any]? {
            return nil
        }
        
        var encoding: ParameterEncoding {
            return JSONEncoding.default
        }
        
        var baseURL: URL {
            return URL(string: "https://pokeapi.co/api/v2/")!
        }
        
        var path: String {
            switch self {
            case .getpokemons:
                return "pokemon"
            case .getPokemonAbilities(let url):
                return url.replacingOccurrences(of: "https://pokeapi.co/api/v2/", with: "")
            }
        }
        
        func asURLRequest() throws -> URLRequest {
            let url = baseURL.appendingPathComponent(path)
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = method.rawValue
            return try encoding.encode(urlRequest, with: parameters)
        }
}
