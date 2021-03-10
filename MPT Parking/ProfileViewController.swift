//
//  ProfileViewController.swift
//  MPT Parking
//
//  Created by Blessme on 22.02.2021.
//

import UIKit
import Firebase
import FirebaseAuth


class ProfileViewController: UIViewController {
    
    
    @IBOutlet weak var deleteCar: UIButton!
    @IBOutlet weak var namePersonLabel: UILabel!
    @IBOutlet weak var addCarPersonButton: UIButton!
    @IBOutlet weak var carPersonLabel: UILabel!
    @IBOutlet weak var mailPersonLabel: UILabel!
    @IBOutlet weak var numberPhonePersonLabel: UILabel!
    @IBOutlet weak var surnamePersonLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        namePersonLabel.isHidden = true
        addCarPersonButton.isHidden = true
        carPersonLabel.isHidden = true
        mailPersonLabel.isHidden = true
        numberPhonePersonLabel.isHidden = true
        surnamePersonLabel.isHidden = true
        deleteCar.isHidden = true
        
        checkPerson()
        
       
    }
    
    func checkPerson(){
        Auth.auth().addStateDidChangeListener{(auth, user) in
            if user == nil{
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let vc = storyboard.instantiateViewController(identifier: "mainLoginRegistrationViewController") as UIViewController
                self.present(vc, animated: true, completion: nil)
            }else{
                self.loadProfile()
                        }
                }
        }
    func loadProfile(){
        let user = Auth.auth().currentUser
        let queryRef = Database.database().reference().child("Users").child(String(user!.uid))
        
        mailPersonLabel.text = user?.email
        mailPersonLabel.isHidden = false
        
        queryRef.queryOrderedByKey().observeSingleEvent(of: .value, with: {(snapshot) in
            let user = snapshot.value as? NSDictionary
            
            let name = user?["name"] as? String
            self.namePersonLabel.text = name
            self.namePersonLabel.isHidden = false
            
            let surname = user?["surname"] as? String
            self.surnamePersonLabel.text = surname
            self.surnamePersonLabel.isHidden = false
            
            let nubmerPhone = user?["number"] as? String
            self.numberPhonePersonLabel.text = nubmerPhone
            self.numberPhonePersonLabel.isHidden = false
            
            let carNumber = user?["carNumber"] as? String
            
            if carNumber != "nil"{
                self.carPersonLabel.text = carNumber
                self.carPersonLabel.isHidden = false
                self.addCarPersonButton.isHidden = true
                self.deleteCar.isHidden = false
            }else{
                self.addCarPersonButton.isHidden = false
            }
        }) {(error)in
            
            print(error.localizedDescription)
        }
        
    }
    @IBAction func exitProfile(_ sender: UIButton) {
        do{
            try Auth.auth().signOut()
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(identifier: "mainLoginRegistrationViewController") as UIViewController
            self.present(vc, animated: true, completion: nil)
        }catch{
            print("Ошибка при выходе")
        }
       
    }
    @IBAction func addCar(_ sender: UIButton) {
    }
}
