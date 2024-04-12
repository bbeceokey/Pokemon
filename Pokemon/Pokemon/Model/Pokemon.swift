//
//  Pokemon.swift
//  Pokemon
//
//  Created by Ece Ok, Vodafone on 10.04.2024.
//

import Foundation


struct Welcome: Decodable {
    let abilities: [AbilityElement]
}

// MARK: - AbilityElement
struct AbilityElement: Decodable {
    let ability: AbilityAbility
    let isHidden: Bool
    let slot: Int

    enum CodingKeys: String, CodingKey {
        case ability
        case isHidden = "is_hidden"
        case slot
    }
}

// MARK: - AbilityAbility
struct AbilityAbility: Decodable {
    let name: String
    let url: String
}

struct PokemonAbility : Decodable {
    let pokemon: Pokemon
    var abilities: Welcome
    

    init(pokemon: Pokemon, abilities: Welcome) {
        self.pokemon = pokemon
        self.abilities = abilities
        
    }

    
    init() {
        self.pokemon = Pokemon(name: "", Url: "")
        self.abilities = Welcome(abilities: [])
       
    }
}
struct PokemonResults : Decodable {
    var results : [Pokemon]
    
    init(results: [Pokemon] = []) {
            self.results = results
        }
}

struct Pokemon : Decodable {
    let name : String
    let Url : String
    //var abilities: [Ability]
    
    enum CodingKeys: String, CodingKey {
        case name
        case Url = "url"
        //case abilities = "abilities"
    }
}


