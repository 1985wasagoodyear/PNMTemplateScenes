//
//  SignupViewController.swift
//  PNMTemplateScenes
//
//  Created by K Y on 7/19/19.
//  Copyright © 2019 K Y. All rights reserved.
//

import UIKit

public final class SignupViewController: UIViewController {

    // MARK: - XIB Outlets
    
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var firstNameTextField: UITextField!
    @IBOutlet var lastNameTextField: UITextField!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var confirmPasswordTextField: UITextField!
    @IBOutlet var createAccountButton: UIButton!
    
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
        super.init(nibName: "SignupViewController",
                   bundle: Bundle(for: SignupViewController.self))
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
    
    private func setupKeyboardHandling() {
        NotificationCenter.registerKeyboardHandler(self,
                                                   willShow: #selector(keyboardWillShow(_:)),
                                                   willHide: #selector(keyboardWillHide(_:)))
        endEdittingGesture = UITapGestureRecognizer(target: self,
                                                    action: #selector(dismissKeyboard))
        scrollView.addGestureRecognizer(endEdittingGesture)
    }
    
    private func setupTextFields() {
        firstNameTextField.handleTextChange(self, #selector(firstNameDidChange(_:)))
        lastNameTextField.handleTextChange(self, #selector(lastNameDidChange(_:)))
        emailTextField.handleTextChange(self, #selector(emailDidChange(_:)))
        passwordTextField.handleTextChange(self, #selector(passwordDidChange(_:)))
        confirmPasswordTextField.handleTextChange(self, #selector(confirmPasswordDidChange(_:)))
    }
    
    // MARK: - Action Methods
    
    @IBAction func createAccountBtnPressed(_ sender: UIButton) {
        signup()
    }
    
    func signup() {
        
    }
    
}

// MARK: - Keyboard Handler & UITextFieldDelegate Methods

extension SignupViewController: UITextFieldDelegate {
    
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

extension SignupViewController {
    
    @objc func firstNameDidChange(_ sender: UITextField) {
        // validate name here
    }
    
    @objc func lastNameDidChange(_ sender: UITextField) {
        // validate last name here
    }
    
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
                self.confirmPasswordTextField.isHidden = isHidden
            }, completion: { (completed) in
                if completed {
                    self.isAnimating = false
                }
            })
        }
        if let pw = passwordTextField.text, Validator.validPassword(pw) {
            self.confirmPasswordTextField.text = nil
            animate(false)
        }
        else {
            animate(true)
        }
    }
    
    @objc func confirmPasswordDidChange(_ sender: UITextField) {
        if let pw = confirmPasswordTextField.text, Validator.validPassword(pw) {
            toggleButton()
        }
    }
    
    private func toggleButton() {
        if let confirm = confirmPasswordTextField.text,
            confirm.isEmpty == false,
            let pw = passwordTextField.text,
            confirm == pw {
            createAccountButton.isEnabled = true
        }
        else {
            createAccountButton.isEnabled = false
        }
    }
    
}
