//
//  ViewController.swift
//  KeyboardHandlingLogINLab
//
//  Created by Melinda Diaz on 2/4/20.
//  Copyright © 2020 Melinda Diaz. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var fluxxImage: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var passwordTextfield: UITextField!
    //you only want to use this in order to move the constraint up and down because Y Axis controls that. This is for when we are moving the keyboard so that it does not block the view of the textfields
    @IBOutlet weak var fluxxCenterLogoYConstraint: NSLayoutConstraint!
    
    private var keyboardIsVisible = false
    
    //WHy do we need this if we have the IBOutlet????
    private var originalYConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerForKeyboardNotifications()
        usernameTextField.delegate = self
        passwordTextfield.delegate = self
        
    }
    //YOu need this for the keyboard
    override func viewWillAppear(_ animated: Bool) {
        //DO NOT FORGET THE SUPER!!!!
        super.viewWillAppear(true)
        unregisterForKeyboardNotifications()
        registerForKeyboardNotifications()
    }
    
    
    private func registerForKeyboardNotifications() {
        //we want to listen to keyboard will show. when the keyboard comes upUIResponder will always have the resignFirstResponder(), We have 2 selectors keyboard will show and keyboard will hide. it can pass in data but it could be buggy
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        //you need this so the keyboard will hide it adds an observer to watch over it
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    //TODO: Why should this be in an extension????
    private func unregisterForKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
           NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
           
        
    }
    //TODO: Why UIKeyboardFrameBeginUserInfoKey????????????
    @objc private func keyboardWillShow(_ notification: NSNotification) {
        guard let keyboardFrame = notification.userInfo?["UIKeyboardFrameBeginUserInfoKey"] as? CGRect else {
            return //this is not a place for fatalError so we will just return
        }
        //this updates the UI and moves the textfield up but it will keep moving the UI up so we need to constrainthat so that it doesnt move off the screen
        moveUpKeyboard(keyboardFrame.size.height)
    }
    @objc private func keyboardWillHide(_ notification: NSNotification) {
        resetUI()
    }
    
    //Use this to call your function inside the keyboard will hide so that your constraints can be the original!!
    private func resetUI() {
        keyboardIsVisible = true
        //You want to keep track of the original constant so that you dont get any bugs
        fluxxCenterLogoYConstraint.constant -= originalYConstraint.constant
    }
    
    //this is a function that moves the keyboard up when the textfield appear
    private func moveUpKeyboard(_ height: CGFloat) {
        if keyboardIsVisible { return }
        originalYConstraint = fluxxCenterLogoYConstraint //This saves the original value
        
        fluxxCenterLogoYConstraint.constant -= (height * 0.8)//
        keyboardIsVisible = true
    }
}

extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        resetUI()
        return true //You must return a Bool in order for it to work
    }
}
