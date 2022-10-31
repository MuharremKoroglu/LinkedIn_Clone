//
//  ViewController.swift
//  LinkedIn
//
//  Created by Muharrem Köroğlu on 25.10.2022.
//

import UIKit
import Firebase

class ViewController: UIViewController {
    
    @IBOutlet weak var userEmailTextField: UITextField!
    @IBOutlet weak var userPasswordTextField: UITextField!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    
    @IBAction func signInButton(_ sender: Any) {
        
        if userEmailTextField.text != "" && userPasswordTextField.text != "" {
            
            Auth.auth().signIn(withEmail: userEmailTextField.text!, password: userPasswordTextField.text!) { result, error in
                if error != nil {
                    self.makeAlert(title: "Error", message: error?.localizedDescription ?? "Something went wrong")
                }else {
                    
                    if result!.user.isEmailVerified == false{
                        self.makeAlert(title: "Check Your Mailbox", message: "Your e-mail address is not verified. We have sent a verification email for this. Don't forget to check your mailbox.")
                        result!.user.sendEmailVerification()
                    }else{
                        self.performSegue(withIdentifier: "toHomeVC", sender: nil)
                    }
                }
            }
        }else{
            makeAlert(title: "Error", message: "Email and password cannot be empty")
        }
        
    }
    
    
    @IBAction func passwordForgetButton(_ sender: Any) {
        
        Auth.auth().sendPasswordReset(withEmail: self.userEmailTextField.text!) { error in
            
            if error != nil {
                self.makeAlert(title: "Error", message: error?.localizedDescription ?? "Something went wrong")
            }else{
                self.makeAlert(title: "Check Your MailBox", message: "We've sent a reset email to your email address. Please check your mailbox and reset your password.")
            }
        }
        
    }

    @IBAction func signUpButton(_ sender: Any) {
        performSegue(withIdentifier: "toSignUpVC", sender: nil)
    }
    
    func makeAlert(title:String, message:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let button = UIAlertAction(title: "Okay", style: UIAlertAction.Style.cancel)
        alert.addAction(button)
        present(alert, animated: true)
    }

}

