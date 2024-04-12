//
//  LikedViewController.swift
//  Pokemon
//
//  Created by Ece Ok, Vodafone on 12.04.2024.
//

import UIKit

class LikedViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        pokemons.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "likedCell", for: indexPath) as! LikedViewCell
        cell.dataConfigure(pokemons[indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    var sendData: ((Any) -> Void)?
    var pokemons: [LikedPokemon] = []
    @IBOutlet weak var pokemonsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pokemonsTableView.register(UINib(nibName: "LikedViewCell", bundle: nil), forCellReuseIdentifier:  "likedCell")
        if !pokemons.isEmpty {
            sendData?(pokemons)
            print("pokemons geldi")
            
        } else {
           print("başarısız")
        }
        
        pokemonsTableView.dataSource = self
        pokemonsTableView.delegate   = self

        // Do any additional setup after loading the view.
    }
}
