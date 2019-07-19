//
//  LoginViewController.swift
//  PNMTemplateScenes
//
//  Created by K Y on 7/19/19.
//  Copyright © 2019 K Y. All rights reserved.
//

import UIKit

public final class LoginViewController: UIViewController {

    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var signInButton: UIButton!
    
    @IBOutlet var constraintContentHeight: NSLayoutConstraint!
    
    // MARK: - Gestures
    
    private var endEdittingGesture: UITapGestureRecognizer!
    
    // MARK: - UI Scrolling Properties
    
    public var keyboardHeight: CGFloat = .zero
    public let animationDuration: TimeInterval = 0.3
    private var isAnimating = false
    private var lastOffset: CGPoint = .zero
    private var activeField: UITextField?
    
    // MARK: - Lifecycle Methods
    
    init() {
        super.init(nibName: "LoginViewController",
                   bundle: Bundle(for: LoginViewController.self))
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        setupKeyboardHandling()
        setupTextFields()
    }
    
    deinit {
        NotificationCenter.unregisterKeyboardHandler(self)
    }
    
    // MARK: - Setup Methods
    
    private func setupKeyboardHandling() {
        NotificationCenter.registerKeyboardHandler(self,
                                                   willShow: #selector(keyboardWillShow(_:)),
                                                   willHide: #selector(keyboardWillHide(_:)))
        endEdittingGesture = UITapGestureRecognizer(target: self,
                                                    action: #selector(dismissKeyboard))
        scrollView.addGestureRecognizer(endEdittingGesture)
    }
    
    private func setupTextFields() {
        emailTextField.handleTextChange(self, #selector(emailDidChange(_:)))
        passwordTextField.handleTextChange(self, #selector(passwordDidChange(_:)))
    }
    
    // MARK: - Custom Action Methods
    
    @IBAction func loginBtnPressed(_ sender: UIButton) {
        
        
    }
    
    func login() {
        
    }
    
}

// MARK: - Keyboard Handler & UITextFieldDelegate Methods

extension LoginViewController: UITextFieldDelegate {
    
    public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        activeField = textField
        lastOffset = self.scrollView.contentOffset
        return true
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        activeField?.resignFirstResponder()
        activeField = nil
        return true
    }
    
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    @objc func keyboardWillShow(_ sender: Notification) {
        guard keyboardHeight == .zero,
            let activeField = activeField,
            let userInfo = sender.userInfo,
            let keyboardRect = userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as? CGRect
            else { return }
        keyboardHeight = keyboardRect.height
        
        // so increase contentView's height by keyboard height
        UIView.animate(withDuration: animationDuration, animations: {
            self.constraintContentHeight.constant += self.keyboardHeight
        })
        // move if keyboard hide input field
        let frame = activeField.frame
        let distanceToBottom = scrollView.frame.size.height - frame.origin.y - frame.size.height
        let collapseSpace = keyboardHeight - distanceToBottom
        if collapseSpace < 0 {
            // no collapse
            return
        }
        // set new offset for scroll view
        UIView.animate(withDuration: animationDuration, animations: {
            // scroll to the position above keyboard 10 points
            self.scrollView.contentOffset = CGPoint(x: self.lastOffset.x,
                                                    y: collapseSpace + 10)
        })
    }
    
    @objc func keyboardWillHide(_ sender: Notification) {
        UIView.animate(withDuration: animationDuration) {
            self.constraintContentHeight.constant -= self.keyboardHeight
            self.scrollView.contentOffset = self.lastOffset
        }
        keyboardHeight = 0.0
    }
    
}

// MARK: - Validation Handler Methods

extension LoginViewController {
    
    @objc func emailDidChange(_ sender: UITextField) {
        // validate email here
        if let email = emailTextField.text, Validator.validEmail(email) {
            toggleButton()
        }
    }
    
    @objc func passwordDidChange(_ sender: UITextField) {
        // perform an animation for showing additional password field
        let animate: (Bool) -> Void = { isHidden in
            if self.isAnimating == true { return }
            self.isAnimating = true
            UIView.animate(withDuration: self.animationDuration, animations: {
                self.scrollView.layoutIfNeeded()
            }, completion: { (completed) in
                if completed {
                    self.isAnimating = false
                }
            })
        }
        if let pw = passwordTextField.text, Validator.validPassword(pw) {
            toggleButton()
            animate(false)
        }
        else {
            animate(true)
        }
    }
    
    private func toggleButton() {
        if let email = emailTextField.text, let password = passwordTextField.text,
            email.isEmpty == false, password.isEmpty == false {
            signInButton.isEnabled = true
        }
        else {
            signInButton.isEnabled = false
        }
    }
    
}
