//
//  ShowDriverViewController.swift
//  MPT Parking
//
//  Created by Blessme on 17.03.2021.
//

import UIKit

class ShowDriverViewController: UIViewController {
    @IBOutlet weak var fioLabel: UILabel!
    @IBOutlet weak var mailLabel: UILabel!
    @IBOutlet weak var phNumberLabel: UILabel!
    @IBOutlet weak var carNumberLabel: UILabel!
    @IBOutlet weak var imageViewDrivar: UIImageView!
    
    var image = UIImage()
    var fio = ""
    var mail = ""
    var numberPh = ""
    var carNumber = ""
    override func viewDidLoad() {
        super.viewDidLoad()

        imageViewDrivar.image = image
        fioLabel.text = fio
        mailLabel.text = mail
        phNumberLabel.text = numberPh
        carNumberLabel.text = carNumber
    }
    
    @IBAction func callDriver(_ sender: UIButton) {
        if let url = URL(string: "tel://\(numberPh)") {
             UIApplication.shared.openURL(url)
         }
    }
}
