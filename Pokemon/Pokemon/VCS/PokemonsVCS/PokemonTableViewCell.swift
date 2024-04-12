//
//  PokemonTableViewCell.swift
//  Pokemon
//
//  Created by Ece Ok, Vodafone on 10.04.2024.
//

import UIKit

class PokemonTableViewCell: UITableViewCell {
    @IBOutlet weak var cellStack: UIStackView!
    @IBOutlet weak var pokemonimageone: UIImageView!
    @IBOutlet weak var pokemonNameone: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func dataConfigure(_ pokemon1: PokemonAbility){
        pokemonNameone.text = pokemon1.pokemon.name
        pokemonimageone.image = UIImage(named: "pokemon.image")
       
        //TODO urlden image çekilicek
    }

   
    
}
