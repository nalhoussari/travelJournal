//
//  LoginViewController.swift
//  travelJournal
//
//  Created by Katrina de Guzman on 2017-07-13.
//  Copyright © 2017 Noor Alhoussari. All rights reserved.
//
import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth


class LoginViewController: UIViewController {
    // MARK: Constants
    let loginToList = "LoginToList"
    
    // MARK: Outlets
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    var ref: DatabaseReference!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        Auth.auth().addStateDidChangeListener(){ auth, user in
            if user != nil{
                // self.performSegue(withIdentifier: self.loginToList, sender: nil)
            }
            
        }
    }
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        Auth.auth().signIn(withEmail: usernameTextField.text!, password: passwordTextField.text!)
    }
    @IBAction func signupButtonTapped(_ sender: Any) {
        let alert = UIAlertController(title: "Register",
                                      message: "Register",
                                      preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Save",
                                       style: .default) { action in
                                        let emailField = alert.textFields![0]
                                        let passwordField = alert.textFields![1]
                                        
                                        Auth.auth().createUser(withEmail: emailField.text!,
                                                               password: passwordField.text!) { user, error in
                                                                if error == nil {
                                                                    Auth.auth().signIn(withEmail: self.usernameTextField.text!,
                                                                                       password: self.passwordTextField.text!)
                                                                }
                                        }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .default)
        
        alert.addTextField { textEmail in
            textEmail.placeholder = "Enter your email"
        }
        
        alert.addTextField { textPassword in
            textPassword.isSecureTextEntry = true
            textPassword.placeholder = "Enter your password"
        }
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
        
    }
}
