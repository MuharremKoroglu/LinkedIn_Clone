//
//  UploadViewController.swift
//  LinkedIn
//
//  Created by Muharrem Köroğlu on 26.10.2022.
//

import UIKit
import FirebaseStorage
import FirebaseAuth
import FirebaseFirestore

class UploadViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var postCommentTextField: UITextField!
    var userName = ""
    var profilePicture = ""
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        postImage.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imagePicker))
        postImage.addGestureRecognizer(gestureRecognizer)

    }
    
    @IBAction func uploadButton(_ sender: Any) {
        
        let storage = Storage.storage()
        let storageReference = storage.reference()
        let mediaFolder = storageReference.child("posts_media")
        
        if let data = self.postImage.image?.jpegData(compressionQuality: 0.5) {
            let uuid = UUID().uuidString
            let imageReference = mediaFolder.child("\(uuid).jpg")
            imageReference.putData(data) { metadata, error in
                
                if error != nil {
                    self.makeAlert(title: "Error", message: error?.localizedDescription ?? "Something went wrong")
                }else{
                    imageReference.downloadURL { url, error in
                        
                        if error != nil {
                            self.makeAlert(title: "Error", message: error?.localizedDescription ?? "Something went wrong")
                        }else{
                            let imageUrl = url?.absoluteString
                            
                            let firestore = Firestore.firestore()
                            firestore.collection("Users").document(Auth.auth().currentUser?.email ?? " ").addSnapshotListener { snapshot, error in
                                if error != nil {
                                    self.makeAlert(title: "Error", message: error?.localizedDescription ?? "Something went wrong")
                                }else{
                                    if snapshot != nil {
                                        if let userName = snapshot!.get("user_name") as? String {
                                            self.userName = userName
                                            if let profilePicture = snapshot?.get("profile_picture") as? String{
                                                self.profilePicture = profilePicture
                                                let firestorePosts = ["post_media" : imageUrl! , "post_comment" : self.postCommentTextField.text ?? " ","posted_by" : self.userName , "post_date" : FieldValue.serverTimestamp(), "post_claps" : 0,"user_profile_picture" : self.profilePicture] as? [String : Any]
                                                
                                                firestore.collection("Posts").addDocument(data: firestorePosts!) { error in
                                                    if error != nil {
                                                        self.makeAlert(title: "Error", message: error?.localizedDescription ?? "Something went wrong")
                                                    }else{
                                                        self.postImage.image = UIImage(named: "select-image")
                                                        self.postCommentTextField.text = ""
                                                        self.makeAlert(title: "Success", message: "Your post uploaded successfully!")
                                                        self.tabBarController?.selectedIndex = 0
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        
        
    }
    
    @objc func imagePicker () {
        
        let pickedImage = UIImagePickerController()
        pickedImage.delegate = self
        pickedImage.allowsEditing = true
        pickedImage.sourceType = .photoLibrary
        present(pickedImage, animated: true)
  
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        postImage.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true)
    }
    
    func makeAlert(title:String, message:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let button = UIAlertAction(title: "Okay", style: UIAlertAction.Style.cancel)
        alert.addAction(button)
        present(alert, animated: true)
    }
    
}
