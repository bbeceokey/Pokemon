//
//  LikedPokemon.swift
//  Pokemon
//
//  Created by Ece Ok, Vodafone on 12.04.2024.
//

import Foundation
import UIKit

struct LikedPokemon{
    let ability : PokemonAbility
    let image : UIImage
    
    init(ability: PokemonAbility, image: UIImage) {
        self.ability = ability
        self.image = image
    }
}
