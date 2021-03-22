//
//  LoginViewController.swift
//  MPT Parking
//
//  Created by Blessme on 18.02.2021.
//

import UIKit
import Firebase
import FirebaseAuth

class LoginViewController: UIViewController {
    
    var window: UIWindow?
    
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

       
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first as? UITouch{
            view.endEditing(true)
        }
    }
    
    func showNewWindow(){

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "mainView") as UIViewController
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func signIn(_ sender: UIButton) {
        
        Auth.auth().signIn(withEmail: loginTextField.text!, password: passwordTextField.text!) {(result, error) in
            if error == nil{
                self.showNewWindow()
               
                
       
            }
            
        }
    }
    

}
