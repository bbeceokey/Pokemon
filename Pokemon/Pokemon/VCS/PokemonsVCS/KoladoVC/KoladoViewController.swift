//
//  KoladoViewController.swift
//  Pokemon
//
//  Created by Ece Ok, Vodafone on 11.04.2024.
//

import UIKit
import Koloda
var likedArray = [LikedPokemon]()
var unlikedArray = [Any]()
class KoladoViewController: UIViewController{
    var containers = [Container_VC]()
    var pokemonsList = PokemonResults()
    var pokemonAbilitiesList = [PokemonAbility]()
    var likesPokemon = [LikedPokemon]()
    var sendData: ((Any) -> Void)?
    @IBOutlet weak var likedBtn: UIButton!
    
    @IBOutlet weak var kolodaimage: KolodaView!
    //@IBOutlet weak var kolodaImage : KolodaView!
    let arr = [UIImage(named: "pokemon.image"),UIImage(named: "pokemon.image"),UIImage(named: "pokemon.image"),UIImage(named: "pokemon.image"),UIImage(named: "pokemon.image"),UIImage(named: "pokemon.image"),UIImage(named: "pokemon.image"),UIImage(named: "pokemon.image"),UIImage(named: "pokemon.image"),UIImage(named: "pokemon.image"),UIImage(named: "pokemon.image"),UIImage(named: "pokemon.image"),UIImage(named: "pokemon.image"),UIImage(named: "pokemon.image"),UIImage(named: "pokemon.image"),UIImage(named: "pokemon.image"),UIImage(named: "pokemon.image"),UIImage(named: "pokemon.image"),UIImage(named: "pokemon.image"),UIImage(named: "pokemon.image")]
    override func viewDidLoad() {
        super.viewDidLoad()
        kolodaimage.dataSource = self
        kolodaimage.delegate = self

    }
   
    func showFeedbackMessage(_ message: String, color: UIColor) {
        let feedbackLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 40))
        feedbackLabel.center = CGPoint(x: view.center.x, y: view.center.y - 100)
        feedbackLabel.textAlignment = .center
        feedbackLabel.backgroundColor = color.withAlphaComponent(0.9)
        feedbackLabel.textColor = .white
        feedbackLabel.text = message
        feedbackLabel.layer.cornerRadius = 20
        feedbackLabel.clipsToBounds = true
        
        view.addSubview(feedbackLabel)
        
        UIView.animate(withDuration: 0.5, delay: 0.5, options: .curveEaseOut, animations: {
            feedbackLabel.alpha = 0.0
        }, completion: { _ in
            feedbackLabel.removeFromSuperview()
        })
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
        PokemonLogic.shared.getPokemons{ [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let pokemons):
                self.pokemonsList = pokemons
                self.fetchAbilitiesForPokemons {
                                self.loadContainersView()
                                self.kolodaimage.reloadData()
                            }
                print("------- Pokemonler ------ ", pokemons)
                print(pokemonAbilitiesList.count)
            case .failure(let error):
                print("Hata: \(error.localizedDescription)")
            }
        }
        
    }
   
    @IBAction func likedBtnTapped(_ sender: Any) {
        if let receiverVC = LikedViewController(nibName: "LikedViewController", bundle: nil) as? LikedViewController {
            receiverVC.pokemons = likedArray
            receiverVC.sendData = { [weak self] data in
                print("Alınan veri: \(data)")
            }
            self.present(receiverVC, animated: true)

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
    override func viewDidAppear(_ animated: Bool) {
            }
    
    func loadContainersView(){
        for pokemonAbility in pokemonAbilitiesList {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "Container_VC") as! Container_VC
                self.addChild(vc)
                containers.append(vc)
            }
    }
    
}
    extension KoladoViewController : KolodaViewDataSource, KolodaViewDelegate {
        func kolodaNumberOfCards(_ koloda: Koloda.KolodaView) -> Int {
            return pokemonAbilitiesList.count
        }
        
        func kolodaSpeedThatCardShouldDrag(_ koloda: KolodaView) -> DragSpeed {
            return .moderate
        }
        
        func koloda(_ koloda: Koloda.KolodaView, viewForCardAt index: Int) -> UIView {
            let container = containers[index]
            container.image = self.arr[index]!
            let pokemonNameLabel = UILabel(frame: CGRect(x: 0, y: 0, width: container.view.frame.width, height: 50))
            pokemonNameLabel.text = pokemonAbilitiesList[index].pokemon.name.capitalized
               pokemonNameLabel.textColor = .black
               pokemonNameLabel.font = UIFont.boldSystemFont(ofSize: 18)
            pokemonNameLabel.textAlignment = .left
               
               // Örnek arka plan rengi: Gri ve yarı saydam
            container.view.backgroundColor = UIColor.white.withAlphaComponent(1.0)
               
               container.resetContent()
               container.view.addSubview(pokemonNameLabel)
            return container.view
        }
        
        func koloda(_ koloda: Koloda.KolodaView, viewForCardOverlayAt index: Int) -> Koloda.OverlayView? {
            return nil
        }
        
        func koloda(_ koloda: Koloda.KolodaView, didSwipeCardAt index: Int, in direction: SwipeResultDirection) {
            if direction == .left {
                // Sağa sürüklendiğinde
                var likedPokemon = LikedPokemon(ability: pokemonAbilitiesList[index], image: arr[index]!)
                likedArray.append(likedPokemon)
                showFeedbackMessage("Add Liked",color: .systemGreen)
            } else if direction == .right {
                // Sola sürüklendiğinde
                var unlikedPokemon = LikedPokemon(ability: pokemonAbilitiesList[index], image: arr[index]!)
                unlikedArray.append(unlikedPokemon)
                showFeedbackMessage("Dont Like",color: .systemRed)
            }
        }
    }

