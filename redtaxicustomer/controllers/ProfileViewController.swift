//
//  ProfileViewController.swift
//  redtaxicustomer
//
//  Created by Hak Holding on 8/3/20.
//  Copyright © 2020 Hak Holding. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var closeButton: UIButton!

    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.navigationController?.setNavigationBarHidden(true, animated: true)

        self.submitButton.layer.masksToBounds = true
        self.submitButton.layer.cornerRadius = 22
        Functions.addCornerShadow(view: self.closeButton, cornerRadius: 20)
        Functions.addCorner(view: self.imageView, cornerRadius: 60)
        
        self.hideKeyboardWhenTappedAround()
    }
    
    @IBAction func changeImageAction(_ sender: Any)
    {
        let actionSheet: UIAlertController = UIAlertController(title: "Please select", message: "Option to select", preferredStyle: .actionSheet)
        
        let cancelActionButton = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            print("Cancel")
        }
        actionSheet.addAction(cancelActionButton)

        let cameraActionButton = UIAlertAction(title: "Camera", style: .default)
        { _ in
               let pickerController = UIImagePickerController()
               pickerController.delegate = self
               pickerController.allowsEditing = true
               pickerController.mediaTypes = ["public.image"]
               pickerController.sourceType = .camera
               self.present(pickerController, animated: true, completion: nil)
        }
        actionSheet.addAction(cameraActionButton)

        let albumActionButton = UIAlertAction(title: "Album", style: .default)
            { _ in
                let pickerController = UIImagePickerController()
                pickerController.delegate = self
                pickerController.allowsEditing = true
                pickerController.mediaTypes = ["public.image"]
                pickerController.sourceType = .photoLibrary
                self.present(pickerController, animated: true, completion: nil)
        }
        actionSheet.addAction(albumActionButton)
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    @IBAction func submitAction(_ sender: Any)
    {
        if self.firstNameTextField.text!.isEmpty || self.lastNameTextField.text!.isEmpty || self.emailTextField.text!.isEmpty
        {
            return
        }
        let firstName = self.firstNameTextField.text
        let lastName = self.lastNameTextField.text
        let email = self.emailTextField.text
        ApiController.sharedInstance.setProfile(first_name: firstName!, last_name: lastName!, email: email!, image:self.imageView.image!, completionHandler: { (data, error) -> Void in
            if error == nil
            {
                DispatchQueue.main.async {
                    AppDelegate.sharedInstance.startApp()
                }
            }
        })
    }
    
    @IBAction func termsAndConditionsAction(_ sender: Any)
    {
    }
    
    @IBAction func onCloseAction(_ sender: Any)
    {
        AppDelegate.sharedInstance.startApp()
    }

    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any])
    {
        let backgroundImage = (info[UIImagePickerController.InfoKey.originalImage] as? UIImage)!
        self.imageView.image = backgroundImage
        picker.dismiss(animated: true, completion: nil)
    }
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {

    }
}
