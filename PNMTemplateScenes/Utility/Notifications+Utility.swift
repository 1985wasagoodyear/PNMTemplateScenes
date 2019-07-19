//
//  Notifications+Utility.swift
//  PNMTemplateScenes
//
//  Created by K Y on 7/19/19.
//  Copyright © 2019 K Y. All rights reserved.
//

import UIKit

extension UITextField {
    
    func handleTextChange(_ target: Any,
                          _ selector: Selector) {
        self.addTarget(target, action: selector, for: .editingChanged)
        if let del = target as? UITextFieldDelegate {
            delegate = del
        }
    }
    
}

extension NotificationCenter {
    
    static func registerKeyboardHandler(_ target: Any,
                                        willShow: Selector,
                                        willHide: Selector,
                                        object: Any? = nil) {
        NotificationCenter.default.addObserver(target,
                                               selector: willShow,
                                               name:UIResponder.keyboardWillShowNotification,
                                               object: object)
        NotificationCenter.default.addObserver(target,
                                               selector: willHide,
                                               name:UIResponder.keyboardWillHideNotification,
                                               object: object)
    }
    
    static func unregisterKeyboardHandler(_ target: Any,
                                          object: Any? = nil) {
        NotificationCenter.default.removeObserver(target,
                                                  name: UIResponder.keyboardWillShowNotification,
                                                  object: object)
        NotificationCenter.default.removeObserver(target,
                                                  name: UIResponder.keyboardWillHideNotification,
                                                  object: object)
    }
    
}
