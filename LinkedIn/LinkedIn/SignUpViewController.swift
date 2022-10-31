//
//  SignUpViewController.swift
//  LinkedIn
//
//  Created by Muharrem Köroğlu on 25.10.2022.
//

import UIKit
import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore

class SignUpViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    @IBOutlet weak var userEmailTextField: UITextField!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var userJobTextField: UITextField!
    @IBOutlet weak var userPasswordTextField: UITextField!
    @IBOutlet weak var userImageView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userImageView.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(selectProfilePicture))
        userImageView.addGestureRecognizer(gestureRecognizer)
        
    }
    

    @IBAction func signUpButton(_ sender: Any) {
        
        if userEmailTextField.text != "" && userPasswordTextField.text != "" && userNameTextField.text != "" && userJobTextField.text != ""{

            Auth.auth().createUser(withEmail: userEmailTextField.text!, password: userPasswordTextField.text!) { result, error in
                
                let storage = Storage.storage()
                let storageReference = storage.reference()
                let mediaFolder = storageReference.child("userProfilePictures")
                
                if let data = self.userImageView.image?.jpegData(compressionQuality: 0.5) {
                    let uuid = UUID().uuidString
                    let imageReference = mediaFolder.child("\(self.userNameTextField.text ?? uuid).jpg")
                    imageReference.putData(data) { metadata, error in
                        
                        if error != nil {
                            self.makeAlert(title: "Error", message: error?.localizedDescription ?? "Something went wrong")
                        }else {
                            imageReference.downloadURL { url, error in
                                
                                if error != nil{
                                    self.makeAlert(title: "Error", message: error?.localizedDescription ?? "Something went wrong")
                                }else {
                                    let imageURL = url?.absoluteString
                                    
                                    let firestore = Firestore.firestore()
                                    
                                    let firestoreUser = ["profile_picture" : imageURL!, "user_email" : self.userEmailTextField.text!, "user_name" : self.userNameTextField.text!, "user_job" : self.userJobTextField.text!, "account_date" : FieldValue.serverTimestamp()] as [String : Any]
                                    
                                    firestore.collection("Users").document(self.userEmailTextField.text!).setData(firestoreUser, merge: false)
                                }
                            }
                        }
                    }
                }
                if error != nil {
                    self.makeAlert(title: "Error", message: error?.localizedDescription ?? "Something went wrong")
                }else{
                    self.performSegue(withIdentifier: "toMainVC", sender: nil)
                }
            }

        }else{
            makeAlert(title: "Error", message: "Please fill in the blanks!")
        }
        
        
    }
    
    @objc func selectProfilePicture () {
        let selectedImage = UIImagePickerController()
        selectedImage.allowsEditing = true
        selectedImage.delegate = self
        selectedImage.sourceType = .photoLibrary
        present(selectedImage, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        userImageView.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true)
    }
    
    
    
    func makeAlert(title:String, message:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let button = UIAlertAction(title: "Okay", style: UIAlertAction.Style.cancel)
        alert.addAction(button)
        present(alert, animated: true)
    }
    

}
