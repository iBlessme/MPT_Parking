//
//  AddCarViewController.swift
//  MPT Parking
//
//  Created by Blessme on 10.03.2021.
//

import UIKit
import Firebase
import FirebaseAuth

class AddCarViewController: UIViewController {
    @IBOutlet weak var firstCharNumber: UITextField!
    @IBOutlet weak var firstDigitNumber: UITextField!
    @IBOutlet weak var secondCharsNumber: UITextField!
    @IBOutlet weak var secondDigitsNumber: UITextField!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

       
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first as? UITouch{
            view.endEditing(true)
        }
    }
    
    
    @IBAction func addCar(_ sender: UIButton) {
        if checkValues()!{
            let carNumber: String = firstCharNumber.text! + firstDigitNumber.text! + secondCharsNumber.text! + secondDigitsNumber.text!
            let user = Auth.auth().currentUser
            let ref = Database.database().reference().child("Cars").child(carNumber)
            ref.updateChildValues([
                "uid" : String(user!.uid),
                "carNumber" : carNumber
            ])
            let refUser = Database.database().reference().child("Users").child(user!.uid)
            refUser.updateChildValues([
                                        "carNumber" : carNumber])
            self.goOtherView()
        }
    }
    
    func checkValues() -> Bool?{
        if firstCharNumber.text?.count == 1{
            if firstDigitNumber.text?.count == 3{
                if secondCharsNumber.text?.count == 2{
                    if secondDigitsNumber.text?.count == 2 || secondDigitsNumber.text?.count == 3{
                        let pattern = "[Е, У, К, Н, А, Р, О, С, М, Т]{2},[0-9]{4}"
                        
                        return true
                       
                    }else{
                        self.allertError(textString: "Некорректный регион!")
                    }
                }else{
                    self.allertError(textString: "Перепроверьте введенный номер")
                }
            }else{
                self.allertError(textString: "Должно быть 3 цифры в номере!")
            }
        }else{
            self.allertError(textString: "Номер начинается с одной буквы")
        }
        return false
    }
    
    func allertError(textString: String){
        let alert = UIAlertController(title: "Ошибка", message: textString, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    
    
    func allertGood(){
        let alert = UIAlertController(title: "Успешно", message: "Вы успешно добавили автомобиль", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    func goOtherView(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "mainView") as UIViewController
        self.present(vc, animated: true, completion: nil)
    }
    
    

}
