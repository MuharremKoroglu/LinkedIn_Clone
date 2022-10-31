//
//  AccountViewController.swift
//  LinkedIn
//
//  Created by Muharrem Köroğlu on 26.10.2022.
//

import UIKit
import Firebase
import SDWebImage

class AccountViewController: UIViewController {

    @IBOutlet weak var userProfilePicture: UIImageView!
    @IBOutlet weak var jobLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getDataFromFirestore()
    }
    
    func getDataFromFirestore () {
        
        let firestore = Firestore.firestore()
        
        firestore.collection("Users").document(Auth.auth().currentUser?.email ?? " ").addSnapshotListener { snapshot, error in
            
            if error != nil {
                self.makeAlert(title: "Error", message: error?.localizedDescription ?? "Something went wrong")
            }else{
                if snapshot != nil {
                    if let job = snapshot!.get("user_job") as? String {
                        self.jobLabel.text = job
                    }
                    if let userName = snapshot!.get("user_name") as? String {
                        self.userNameLabel.text = userName
                    }
                    if let userEmail = snapshot!.get("user_email") as? String {
                        self.emailLabel.text = userEmail
                    }
                    if let userPicture = snapshot!.get("profile_picture") as? String {
                        self.userProfilePicture.sd_setImage(with: URL(string: userPicture),placeholderImage: UIImage(named: "anon-user"))
                    }
                }
            }
        }
    }
    
    @IBAction func logOutButton(_ sender: Any) {
        
        do{
            try Auth.auth().signOut()
            self.performSegue(withIdentifier: "toBackToMainVC" , sender: nil)
        }catch{
            print("Error!")
        }
        
    }
    
    func makeAlert(title:String, message:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let button = UIAlertAction(title: "Okay", style: UIAlertAction.Style.cancel)
        alert.addAction(button)
        present(alert, animated: true)
    }
}
