//
//  Container_VC.swift
//  Pokemon
//
//  Created by Ece Ok, Vodafone on 11.04.2024.
//

import UIKit

class Container_VC: UIViewController {

    @IBOutlet weak var containerImage: UIImageView!
    var image = UIImage()
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    func resetContent () {
        DispatchQueue.main.async {
            self.containerImage.image = self.image
        }
    }

  

}
