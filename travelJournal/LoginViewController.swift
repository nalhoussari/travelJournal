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
        
    
        
//        init(red: CGFloat,
//        green: CGFloat,
//        blue: CGFloat,
//        alpha: CGFloat)
        //let maskColor = UIColor(red: 85/255.0, green: 172/255.0, blue: 238/255.0, alpha: 1)
        //let maskColor = UIColor(red: 85/255.0, green: 172/255.0, blue: 238/255.0, alpha: 1)
        //self.mask?.backgroundColor = maskColor.cgColor
        
        //let maskColor = UIColor(red: 85/255.0, green: 172/255.0, blue: 238/255.0, alpha: 1)
        //self.mask?.backgroundColor = UIColor.red.cgColor
        
        
            //UIColor(red: 85/255.0, green: 172/255.0, blue: 238/255.0, alpha: 1) as! CGColor
        //self.view.backgroundColor = UIColor(red: 85/255.0, green: 172/255.0, blue: 238/255.0, alpha: 1)
        
        animate()

        //
        
        //set credentials
        let defaults = UserDefaults.standard
        defaults.set(self.usernameTextField.text!, forKey: "username")
        defaults.set(self.passwordTextField.text!, forKey: "password")
        
        
        ref = Database.database().reference()
        Auth.auth().addStateDidChangeListener(){ auth, user in
            if user != nil{
                // self.performSegue(withIdentifier: self.loginToList, sender: nil)
            }
            
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
