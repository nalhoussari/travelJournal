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
import QuartzCore


class LoginViewController: UIViewController, CAAnimationDelegate {
    // MARK: Constants
    let loginToList = "LoginToList"
    
    // MARK: Outlets
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    var ref: DatabaseReference!
    var userID : String = ""
    let spinner = UIActivityIndicatorView()
    
    //splash
    var mask: CALayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //
        self.mask = CALayer()
        self.mask!.contents = UIImage(named: "twitter logo mask")!.cgImage
        self.mask!.contentsGravity = kCAGravityResizeAspect
        self.mask!.bounds = CGRect(x: 0, y: 0, width: 100, height: 100)
        self.mask!.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.mask!.position = CGPoint(x: view.frame.size.width/2, y: view.frame.size.height/2)
        
        
        //add logo as mask to view
        self.view.layer.mask = mask
        
    
        animate()

        
        ref = Database.database().reference()
        Auth.auth().addStateDidChangeListener(){ auth, user in
             
        }
    }
    
    
    func animate() {
        
        let keyFrameAnimation = CAKeyframeAnimation(keyPath: "bounds")
        keyFrameAnimation.delegate = self as? CAAnimationDelegate
        keyFrameAnimation.duration = 1
        keyFrameAnimation.beginTime = CACurrentMediaTime() + 1 //add delay of 1 second
        
        //start animation
        let initialBounds = NSValue(cgRect:mask!.bounds)
        
        
        //bounce/zooming effect
        let middleBounds = NSValue(cgRect: CGRect(x: 0, y: 0, width: 90, height: 90))
        let finalBounds = NSValue(cgRect: CGRect(x: 0, y: 0, width: 1500, height: 1500))
        
        
        
        //add NSValues and keytimes
        keyFrameAnimation.values = [initialBounds, middleBounds, finalBounds]
        keyFrameAnimation.keyTimes = [0, 0.3, 1]
        
        
        //animation timing functions
        keyFrameAnimation.timingFunctions = [CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut),CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)]
        
        
        //add animation
        self.mask?.add(keyFrameAnimation, forKey: "bounds")

    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        
        //removes mask when animation completes
        self.view.layer.mask = nil
    }
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        
        self.view.addSubview(self.spinner)
        self.spinner.center = (self.view.center)
        self.spinner.color = UIColor.black
        self.spinner.startAnimating()
        self.spinner.hidesWhenStopped = true


        logIn(username: usernameTextField.text!, password: passwordTextField.text!)
        
    }
    
    
    func logIn(username: String, password: String){
        
        
        Auth.auth().signIn(withEmail: username, password: password) { (user, error) in
            
            if let error = error {
                
                let alert = UIAlertController(title: "Invalid Credentials", message: "\(error)", preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
                    print("OK")
                })
                self.spinner.stopAnimating()
                self.present(alert, animated: true)
                
            } else if Auth.auth().currentUser != nil {
                // successful
                self.userID = (Auth.auth().currentUser?.email)!
                self.spinner.stopAnimating()
                self.navigationController?.popToRootViewController(animated: true)
            }
            else {
                // We can add: alert to user
                self.spinner.stopAnimating()
                self.navigationController?.popToRootViewController(animated: true)
            }
        }
    }
    
    
    @IBAction func signupButtonTapped(_ sender: Any) {
        let alert = UIAlertController(title: "Register",
                                      message: "Register",
                                      preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Save",
                                       style: .default) { action in
                                        let emailField = alert.textFields![0]
                                        let passwordField = alert.textFields![1]
                                        
                                        self.view.addSubview(self.spinner)
                                        self.spinner.center = (self.view.center)
                                        self.spinner.color = UIColor.black
                                        self.spinner.startAnimating()
                                        self.spinner.hidesWhenStopped = true

                                        
                                        Auth.auth().createUser(withEmail: emailField.text!,
                                                               password: passwordField.text!) { user, error in
                                                                if error == nil {
                                                                    
                                                                    self.logIn(username: emailField.text!, password: passwordField.text!)
                                                                    
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
