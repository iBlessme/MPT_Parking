//
//  mainLoginRegistrationViewController.swift
//  MPT Parking
//
//  Created by Blessme on 18.02.2021.
//

import UIKit
import Firebase

class mainLoginRegistrationViewController: UIViewController {
    @IBOutlet weak var backButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    @IBAction func backButton(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "mainView") as UIViewController
        self.present(vc, animated: true, completion: nil)
    }
    

   
}
