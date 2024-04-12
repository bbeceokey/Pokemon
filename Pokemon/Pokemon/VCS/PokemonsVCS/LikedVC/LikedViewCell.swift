//
//  LikedViewCell.swift
//  Pokemon
//
//  Created by Ece Ok, Vodafone on 12.04.2024.
//

import UIKit

class LikedViewCell: UITableViewCell {

    @IBOutlet weak var pokemonImage: UIImageView!
    @IBOutlet weak var pokemonName: UILabel!
    @IBOutlet weak var özellikler: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func dataConfigure(_ pokemon : LikedPokemon) {
        var abilitiesText = " "
        pokemonImage.image = pokemon.image
        pokemonName.text = pokemon.ability.pokemon.name
        for ability in pokemon.ability.abilities.abilities {
            abilitiesText += ability.ability.name + "\n"
        }
        özellikler.text = abilitiesText
    }
    
}
