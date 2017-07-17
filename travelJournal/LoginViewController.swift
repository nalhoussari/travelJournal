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
import FirebaseStorage
import FirebaseAuth


class LoginViewController: UIViewController {
    

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
//        self.navigationController?.isNavigationBarHidden = true
    }
    
    @IBAction func loginButtonTapped(_ sender: Any) {
    }
    @IBAction func signupButtonTapped(_ sender: Any) {
    }
    override func viewWillDisappear(_ animated: Bool) {
//        self.navigationController?.isNavigationBarHidden = false
    }
    
    override func didReceiveMemoryWarning() {  super.didReceiveMemoryWarning()}
}
