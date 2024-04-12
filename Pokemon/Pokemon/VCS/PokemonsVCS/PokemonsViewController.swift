//
//  PokemonsViewController.swift
//  Pokemon
//
//  Created by Ece Ok, Vodafone on 10.04.2024.
//

import UIKit
import Koloda

class PokemonsViewController: UIViewController {
    
    
    var pokemonsList = PokemonResults()
    var pokemonAbilitiesList = [PokemonAbility]()
    var likesPokemon = [PokemonAbility]()
    var isScrollEnabled = true

 
    
    @IBOutlet weak var pokemonsTableViewone: UITableView!
    @IBOutlet weak var pokemonsTableViewtwo: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /*pokemonsTableViewone.register(UINib(nibName: "PokemonTableViewCell", bundle: nil), forCellReuseIdentifier: "pokemonCell")
        pokemonsTableViewone.dataSource = self
        pokemonsTableViewone.delegate = self
        pokemonsTableViewtwo.register(UINib(nibName: "PokemonTableViewCell", bundle: nil), forCellReuseIdentifier: "pokemonCell")
        pokemonsTableViewtwo.dataSource = self
        pokemonsTableViewtwo.delegate = self*/
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
        PokemonLogic.shared.getPokemons{ [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let pokemons):
                self.pokemonsList = pokemons
                self.fetchAbilitiesForPokemons {
                    self.pokemonsTableViewone.reloadData()
                            }
                print("------- Pokemonler ------ ", pokemons)
                
            case .failure(let error):
                print("Hata: \(error.localizedDescription)")
            }
        }
    }
   

    func fetchAbilitiesForPokemons(completion: @escaping () -> Void) {
        let dispatchGroup = DispatchGroup()
        
        for pokemon in pokemonsList.results {
            dispatchGroup.enter()
            
            guard let url = URL(string: pokemon.Url) else {
                print("Geçersiz URL: \(pokemon.Url)")
                dispatchGroup.leave()
                continue
            }
            
            PokemonLogic.shared.fetchAbilities(from: url) { result in
                switch result {
                case .success(let abilityResponse):
                    self.pokemonAbilitiesList.append(PokemonAbility(pokemon: pokemon, abilities: abilityResponse))
                    
                case .failure(let error):
                    print("Error: \(error)")
                }
                
                dispatchGroup.leave()
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            completion()
        }
    }
    
}

/*extension PokemonsViewController : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        pokemonAbilitiesList.count/2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == pokemonsTableViewone {
            // İlk TableView için hücreleri oluştur
            let cell = pokemonsTableViewone.dequeueReusableCell(withIdentifier: "pokemonCell", for: indexPath) as! PokemonTableViewCell
            
            // İlgili veriyi al
            let firstIndex = indexPath.row * 2
            let firstPokemon = pokemonAbilitiesList[firstIndex]
            
            // Hücreyi yapılandır
            cell.dataConfigure(firstPokemon)
            
            return cell
        } else if tableView == pokemonsTableViewtwo {
            // İkinci TableView için hücreleri oluştur
            let cell = pokemonsTableViewtwo.dequeueReusableCell(withIdentifier: "pokemonCell", for: indexPath) as! PokemonTableViewCell
            
            // İlgili veriyi al
            let secondIndex = indexPath.row * 2 + 1
            let secondPokemon = pokemonAbilitiesList[secondIndex]
            
            // Hücreyi yapılandır
            cell.dataConfigure(secondPokemon)
            
            return cell
        } else {
            fatalError("Unknown TableView")
        }
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
            if isScrollEnabled {
                // Eğer scroll etmeye izin verilirse, diğer TableView'ı scroll et
                if scrollView == pokemonsTableViewone {
                    pokemonsTableViewtwo.setContentOffset(pokemonsTableViewone.contentOffset, animated: false)
                } else if scrollView == pokemonsTableViewtwo {
                    pokemonsTableViewone.setContentOffset(pokemonsTableViewtwo.contentOffset, animated: false)
                }
            }
        }

    /*func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            pokemonAbilitiesList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .left)
        } else if editingStyle == .insert{
            likesPokemon.append(pokemonAbilitiesList[indexPath.row])
            tableView.deleteRows(at: [indexPath], with: .right)
        }
    }*/
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: nil){_,_, completion in
            self.pokemonAbilitiesList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .left)
            completion(true)
        }
        deleteAction.image = UIImage(systemName: "unlike")
        deleteAction.backgroundColor = .systemRed
        
        let likeAction = UIContextualAction(style: .destructive, title: nil){_,_, completion in
            self.likesPokemon.append(self.pokemonAbilitiesList[indexPath.row])
            tableView.deleteRows(at: [indexPath], with: .right)
            completion(true)
        }
        likeAction.image = UIImage(systemName: "like")
        likeAction.backgroundColor = .systemGreen
        
        let config = UISwipeActionsConfiguration(actions: [deleteAction,likeAction])
        return config
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.backgroundColor = .orange
        
        //TODO: view yap vc oluşturup detail sayfasına geçsin
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
           // TableView hücrelerinin yüksekliğini belirle
           return 300 // Örneğin, her hücrenin yüksekliği 100 piksel olsun
       }
       
}*/
