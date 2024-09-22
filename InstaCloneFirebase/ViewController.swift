//
//  ViewController.swift
//  InstaCloneFirebase
//
//  Created by Farih Muhammad on 21/09/2024.
//

import UIKit
import Firebase

class ViewController: UIViewController {

    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func signInClicked(_ sender: UIButton) {
        performSegue(withIdentifier: "toFeedVC", sender: nil)
    }
    
    @IBAction func signUpClicked(_ sender: UIButton) {
        
        if let email = emailText.text, !email.isEmpty,
               let password = passwordText.text, !password.isEmpty {
            Auth.auth().createUser(withEmail: email, password: password) { authdata, error in
                if let errorMessage = error {
                    self.makeAlert(titleInput: "Error", messageInput: errorMessage.localizedDescription)
                } else {
                    self.performSegue(withIdentifier: "toFeedVC", sender: nil)
                }
            }
        } else {
            makeAlert(titleInput: "Error", messageInput: "Username/Password?")
        }
    }
    
    func makeAlert(titleInput:String, messageInput:String){
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .default)
        alert.addAction(okButton)
        self.present(alert, animated: true)
    }
}

