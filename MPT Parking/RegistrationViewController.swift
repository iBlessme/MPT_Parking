//
//  RegistrationViewController.swift
//  MPT Parking
//
//  Created by Blessme on 18.02.2021.
//

import UIKit
import Firebase
import FirebaseAuth


class RegistrationViewController: UIViewController {
    //Аутлеты
    @IBOutlet weak var MailTextField: UITextField!
    @IBOutlet weak var NameTextField: UITextField!
    @IBOutlet weak var SurnameTextField: UITextField!
    @IBOutlet weak var NumberPhoneTextField: UITextField!
    @IBOutlet weak var PasswordTextField: UITextField!
    @IBOutlet weak var SigUpTButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    //Окно ошибки
    func allertError(textString: String){
        let alert = UIAlertController(title: "Ошибка", message: textString, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    func alertGood(){
        let alert = UIAlertController(title: "Успешно", message: "Вы прошли регистрацию", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
    }
    //Регистрация
    @IBAction func SigUp(_ sender: UIButton) {
        
        let mail = MailTextField.text!
        let name = NameTextField.text!
        let surname = SurnameTextField.text!
        let numberPhone = NumberPhoneTextField.text!
        let password = PasswordTextField.text!
        
        if (!mail.isEmpty && !name.isEmpty && !surname.isEmpty && !numberPhone.isEmpty && !password.isEmpty){
            
                
            
            //Создание пользователя
            Auth.auth().createUser(withEmail: mail, password: password ) {(result, error) in
                if error == nil {
                    if let result = result{
                        print(result.user.uid)
                        let ref = Database.database().reference().child("Users")
                        ref.child(result.user.uid).updateChildValues([
                            "uid" : result.user.uid,
                            "mail" : mail,
                            "password" : password,
                            "number" : numberPhone,
                            "name" : name,
                            "surname" : surname,
                            "carNumber" : "nil"
                        ])
                    self.alertGood()
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let vc = storyboard.instantiateViewController(identifier: "mainView") as UIViewController
                        self.present(vc, animated: true, completion: nil)
                    }
                }else{
                    self.allertError(textString: "Пользователь с такой почтой уже есть")
                }
            }
        }else{
            allertError(textString: "Не все поля заполнены")
        }
        
    }
    
    }
