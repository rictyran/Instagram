//
//  ViewController.swift
//  Instagram
//
//  Created by Richard Tyran on 3/10/15.
//  Copyright (c) 2015 Richard Tyran. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    var signupActive = true
    
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    func displayAlert(title:String, error:String) {
        
        var alert = UIAlertController(title: title, message: error, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { action in
            
            self.dismissViewControllerAnimated(true, completion: nil)
            
        }))
        
        self.presentViewController(alert, animated: true, completion: nil)

    }
    
    
    
    @IBOutlet var username: UITextField!
    
    @IBOutlet var password: UITextField!
    
    @IBOutlet var alreadyRegistered: UILabel!
    
    @IBOutlet var signUpButton: UIButton!
    
    @IBOutlet var signUpLabel: UILabel!
    
    @IBOutlet var signUpToggleButton: UIButton!
    
    @IBAction func toggleSignUp(sender: AnyObject) {
        
        if signupActive == true {
            
            signupActive = false
            
            signUpLabel.text = "Use the form below to log in"
            
            signUpButton.setTitle("Log in", forState: UIControlState.Normal)
            
            alreadyRegistered.text = "Not Registered?"
            
            signUpToggleButton.setTitle("Sign Up", forState: UIControlState.Normal)
        
        } else {
            
            signupActive = true
            
            signUpLabel.text = "Use the form below to sign up"
            
            signUpButton.setTitle("Sign Up", forState: UIControlState.Normal)
            
            alreadyRegistered.text = "Already Registered?"
            
            signUpToggleButton.setTitle("Log In", forState: UIControlState.Normal)
            
        }
        
        
    }
    
    @IBAction func signUp(sender: AnyObject) {
    
        var error = ""
        
        if username.text == "" || password.text == "" {
            
            error = "Please enter a username and password"
            
        }
        
        if error != "" {
            
            displayAlert("Error in Form", error: error)
            
        } else {
            
            

            activityIndicator = UIActivityIndicatorView(frame: CGRectMake(0, 0, 50, 50))
            activityIndicator.center = self.view.center
            activityIndicator.hidesWhenStopped = true
            activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
            view.addSubview(activityIndicator)
            activityIndicator.startAnimating()
            UIApplication.sharedApplication().beginIgnoringInteractionEvents()
            
            if signupActive == true {
                
                var user = PFUser()
                user.username = username.text
                user.password = password.text
                
                user.signUpInBackgroundWithBlock { (succeeded: Bool!, signupError: NSError!) -> Void in
                
                    self.activityIndicator.stopAnimating()
                    UIApplication.sharedApplication().endIgnoringInteractionEvents()
                
                    if signupError == nil {
                        
                        println("signed up")
                        
                        self.performSegueWithIdentifier("jumpToUserTable", sender: "self")
                    
                    } else {
                    
                        if let errorString = signupError.userInfo?["error"] as? NSString {
                        
                            error = errorString
                        
                        } else {
                        
                            error = "Please try again later"
                    
                        }
                
                        self.displayAlert("Could not sign up", error: error)
                    
                    }
                
                }
                
            } else {
                
                PFUser.logInWithUsernameInBackground(username.text, password: password.text) {
                    (user: PFUser!, signupError: NSError!) -> Void in
                    
                    self.activityIndicator.stopAnimating()
                    UIApplication.sharedApplication().endIgnoringInteractionEvents()
                    
                    if signupError == nil {
                        
                        self.performSegueWithIdentifier("jumpToUserTable", sender: "self")
                        
                        println("logged in")
                        
                    } else {
                        
                        if let errorString = signupError.userInfo?["error"] as? NSString {
                            
                            error = errorString
                            
                        } else {
                            
                            error = "Please try again later"
                            
                        }
                        
                        self.displayAlert("Could not log in", error: error)
                        
                    }
                }
            }
            
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        println(PFUser.currentUser())
        
    }

    override func viewDidAppear(animated: Bool) {
        
        if PFUser.currentUser() != nil {
            
            self.performSegueWithIdentifier("jumpToUserTable", sender: "self")
            
        }
        
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBarHidden = true
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.navigationController?.navigationBarHidden = false
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }

}






//    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
//
//    @IBOutlet var pickedImage: UIImageView!
//
//    func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!)
//
//    {
//
//        println("Image selected")
//        self.dismissViewControllerAnimated(true, completion: nil)
//        pickedImage.image = image
//    }
//
//
//    @IBAction func pickImage(sender: AnyObject) {
//
//        var image = UIImagePickerController()
//        image.delegate = self
//        image.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
//
////      to use camera instead of photo library
//        image.sourceType = UIImagePickerControllerSourceType.Camera
//
//        image.allowsEditing = false
//        self.presentViewController(image, animated: true, completion: nil)
//
//    }
//
//    @IBAction func pause(sender: AnyObject) {
//
//        activityIndicator = UIActivityIndicatorView(frame: CGRectMake(0, 0, 50, 50))
//        activityIndicator.center = self.view.center
//        activityIndicator.hidesWhenStopped = true
//        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
//        view.addSubview(activityIndicator)
//        activityIndicator.startAnimating()
////        UIApplication.sharedApplication().beginIgnoringInteractionEvents()
//
//    }
//
//    @IBAction func restore(sender: AnyObject) {
//
//        activityIndicator.stopAnimating()
////        UIApplication.sharedApplication().endIgnoringInteractionEvents()
//
//    }
//
//    @IBAction func createAlert(sender: AnyObject) {
//
//        var alert = UIAlertController(title: "Hey there!", message: "Are you sure?", preferredStyle: UIAlertControllerStyle.Alert)
//
//        alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { action in
//
//            self.dismissViewControllerAnimated(true, completion: nil)
//
//        }))
//
//        self.presentViewController(alert, animated: true, completion: nil)
//
//    }
