//
//  FindCarViewController.swift
//  MPT Parking
//
//  Created by Blessme on 11.03.2021.
//

import UIKit
import Firebase
import FirebaseAuth

class FindCarViewController: UIViewController {
    @IBOutlet weak var firstChar: UITextField!
    @IBOutlet weak var firstDigits: UITextField!
    @IBOutlet weak var secondChars: UITextField!
    @IBOutlet weak var region: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    //закрытие клавиатуры
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first as? UITouch{
            view.endEditing(true)
        }
    }
    
    //кнопка найти автомобиль
    @IBAction func findCar(_ sender: Any) {
        if (!firstChar.text!.isEmpty && !firstDigits.text!.isEmpty && !secondChars.text!.isEmpty && !region.text!.isEmpty){
        let carNumber = String(firstChar.text! + firstDigits.text! + secondChars.text! + region.text!)
        self.readCarInfo(Number: carNumber)
        }else{
            allert(textString: "Заполните поля")
        }
    }
    
    //функция считывания документа машины
    func readCarInfo(Number: String){
        let ref = Database.database().reference().child("Cars").child(Number)
        ref.queryOrderedByKey().observeSingleEvent(of: .value, with: {(snapshot) in
            let car = snapshot.value as? NSDictionary
            let userUid = car?["uid"] as? String
            
            if userUid != nil{
            self.readUserInfo(useruid: userUid!)
            print(userUid!)
            }else{
                self.allert(textString: "Нет данных по этому номеру")
            }
        })
    }
    
    //функция считывания документа user
    func readUserInfo(useruid: String){
        let ref = Database.database().reference().child("Users").child(useruid)
        ref.queryOrderedByKey().observeSingleEvent(of: .value, with: {(snapshot) in
            let user = snapshot.value as? NSDictionary
            let name = user?["name"] as? String
            let surname = user?["surname"] as? String
            let mail = user?["mail"] as? String
            let numberPh = user?["number"] as? String
            self.navNewView(fio: "\(name!) \(surname!)", mail: mail!, numberPh: numberPh!)
            
        })
    }
    //вызов окна allert
    func allert(textString: String){
        let alert = UIAlertController(title: "Ошибка", message: textString, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    //переход на другое окно
    func navNewView(fio: String, mail: String, numberPh: String){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let vc = storyboard.instantiateViewController(identifier: "ShowDriverViewController") as? ShowDriverViewController else {return}
        
        //передаем значения другому контроллеру
        vc.fio = fio
        vc.numberPh = numberPh
        vc.mail = mail
        let carNumber = String(firstChar.text! + firstDigits.text! + secondChars.text! + region.text!)
        vc.carNumber = carNumber
        self.present(vc, animated: true, completion: nil)
    }
    

}
