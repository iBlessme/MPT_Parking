//
//  ProfileViewController.swift
//  MPT Parking
//
//  Created by Blessme on 22.02.2021.
//

import UIKit
import MobileCoreServices
import Firebase
import FirebaseAuth
import FirebaseStorage


class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    @IBOutlet weak var deleteCar: UIButton!
    @IBOutlet weak var namePersonLabel: UILabel!
    @IBOutlet weak var addCarPersonButton: UIButton!
    @IBOutlet weak var carPersonLabel: UILabel!
    @IBOutlet weak var mailPersonLabel: UILabel!
    @IBOutlet weak var numberPhonePersonLabel: UILabel!
    @IBOutlet weak var surnamePersonLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var addImageUser: UIButton!
    
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
        self.loadPhoto()
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
            
            if carNumber != nil{
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
    
    
    @IBAction func deleteCarUser(_ sender: UIButton) {
        let user = Auth.auth().currentUser
        Database.database().reference().child("Users").child(user!.uid).child("carNumber").removeValue()
        self.viewDidLoad()
        
        Database.database().reference().child("Cars").child(String(carPersonLabel.text!)).removeValue()
        self.viewDidLoad()
    }
    @IBAction func addImageUser(_ sender: UIButton) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.mediaTypes = [kUTTypeImage as String]
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.allowsEditing = false
        present(imagePickerController, animated: true, completion: nil)
        
        
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let capturedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageView.contentMode = .scaleAspectFit
            imageView.image = capturedImage
            self.uploadPhotoInStorage()
        }
        dismiss(animated: true, completion: nil)
    }
    func uploadPhotoInStorage(){
        let user = Auth.auth().currentUser
        let uid: String = user!.uid
        let ref = Storage.storage().reference().child("users").child(uid)
        
        guard let imageData = imageView.image?.jpegData(compressionQuality: 0.4) else { return }
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        _ = ref.putData(imageData, metadata: metadata) {(metadata, error) in
            guard let metadata = metadata else {return}
            _ = metadata.size
            ref.downloadURL {(url, error) in
                guard let downloadURL = url else {return}
            }
        }
    }
    func loadPhoto(){
        let uid: String = Auth.auth().currentUser!.uid
        let ref = Storage.storage().reference().child("users").child(uid)
        let megaByte = Int64(1 * 1024 * 1024)
        ref.getData(maxSize: megaByte) {(data, error) in
            guard let imageData = data else {
                return
            }
            let image = UIImage(data: imageData)
            self.imageView.image = image
        }
    }
}


