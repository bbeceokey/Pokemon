//
//  getPokemons.swift
//  Pokemon
//
//  Created by Ece Ok, Vodafone on 10.04.2024.
//

import Foundation
import Alamofire
protocol PokemonProtocol {
    func getPokemons(completionHandler: @escaping (Result<PokemonResults, Error>) -> Void)
    func fetchAbilities(from url: URL, completion: @escaping (Result<Welcome, Error>) -> Void)
}

final class PokemonLogic: PokemonProtocol {
    
    static let shared: PokemonLogic = {
        let instance = PokemonLogic()
        return instance
    }()
    
    func getPokemons(completionHandler: @escaping (Result<PokemonResults, Error>) -> Void) {
        Webservice.shared.request(request:Router.getpokemons, decodeToType: PokemonResults.self, completionHandler: completionHandler)
    }
    
    func fetchAbilities(from url: URL, completion: @escaping (Result<Welcome, Error>) -> Void) {
        AF.request(url).responseDecodable(of: Welcome.self) { response in
            switch response.result {
            case .success(let abilityResponse):
                completion(.success(abilityResponse))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    /*func getPokemonAbilities(url: String, completion: @escaping (Result<PokemonResponse, Error>) -> Void) {
        guard let urlConvertible = URL(string: url) else {
            let error = NSError(domain: "", code: 400, userInfo: [NSLocalizedDescriptionKey: "Geçersiz URL"])
            completion(.failure(error))
            return
        }
        
        Webservice.shared.request(request: urlConvertible as! URLRequestConvertible, decodeToType: PokemonResponse.self) { result in
            completion(result)
        }
    }*/


}
