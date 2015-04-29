//
//  postViewController.swift
//  Instagram
//
//  Created by Richard Tyran on 4/28/15.
//  Copyright (c) 2015 Richard Tyran. All rights reserved.
//

import UIKit

class postViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    func displayAlert(title:String, error:String) {
        
        var alert = UIAlertController(title: title, message: error, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { action in
            
            self.dismissViewControllerAnimated(true, completion: nil)
            
        }))
        
        self.presentViewController(alert, animated: true, completion: nil)
        
    }

    var photoSelected:Bool = false
    
    @IBOutlet var imageToPost: UIImageView!

    @IBAction func logout(sender: AnyObject) {
    
        PFUser.logOut()
        
        self.performSegueWithIdentifier("logout", sender: self)
    
    
    }
    @IBAction func chooseImage(sender: AnyObject) {
        
        var image = UIImagePickerController()
        image.delegate = self
        image.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        image.allowsEditing = false
        
        self.presentViewController(image, animated: true, completion: nil)
    
    }
    
    @IBOutlet var shareText: UITextField!
    
    
    @IBAction func postImage(sender: AnyObject) {
    
        var error = ""
        
        if (photoSelected == false) {
            
            error = "Please select an image to post"
        
        } else if (shareText.text == "") {
            
            error = "Please enter a message"
        }
        
        if (error != "") {
            
            
            displayAlert("Cannot post image", error: error)
            
        } else {
            
            activityIndicator = UIActivityIndicatorView(frame: CGRectMake(0, 0, 50, 50))
            activityIndicator.center = self.view.center
            activityIndicator.hidesWhenStopped = true
            activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
            view.addSubview(activityIndicator)
            activityIndicator.startAnimating()
            UIApplication.sharedApplication().beginIgnoringInteractionEvents()

            var post = PFObject(className: "Post")
            post["Title"] = shareText.text
            post["username"] = PFUser.currentUser().username
            
            post.saveInBackgroundWithBlock{(success: Bool!, error: NSError!) -> Void in
                
                if success == false {
                    
                    self.activityIndicator.stopAnimating()
                    UIApplication.sharedApplication().endIgnoringInteractionEvents()
                    
                    self.displayAlert("Could not post image", error: "Please try again later")
                    
                } else {
                    
                    let imageData = UIImagePNGRepresentation(self.imageToPost.image)
                
                    let imageFile = PFFile(name: "image.png", data: imageData)
                
                    post["imageFile"] = imageFile
                    
                    post.saveInBackgroundWithBlock{ (success: Bool!, error: NSError!) -> Void in
                        
                        self.activityIndicator.stopAnimating()
                        UIApplication.sharedApplication().endIgnoringInteractionEvents()
                        
                        if success == false {
                            
                            self.displayAlert("Could not post image", error: "Please try again later")
                            
                        } else {
                            
                            self.displayAlert("Image Posted!", error: "Your image posted successfully")
                           
                            self.photoSelected = false
                            
                            self.imageToPost.image = UIImage(named: "female.png")
                            
                            self.shareText.text = ""
 
                            println("posted successfully")
                            
                        }
                    }
                    
                }
        
            }
    
        }
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        
        println("Image Selected")
        self.dismissViewControllerAnimated(true, completion: nil)
        
        imageToPost.image = image
        
        photoSelected = true
        
        }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        photoSelected = false
        
        imageToPost.image = UIImage(named: "female.png")
        
        shareText.text = ""
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
}
