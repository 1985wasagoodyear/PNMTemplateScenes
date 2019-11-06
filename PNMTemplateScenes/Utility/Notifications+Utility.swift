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
    
    private static let `def` = NotificationCenter.default
    
    static func registerKeyboardHandler(_ target: Any,
                                        willShow: Selector,
                                        willHide: Selector,
                                        object: Any? = nil) {
        def.addObserver(target,
                        selector: willShow,
                        name:UIResponder.keyboardWillShowNotification,
                        object: object)
        def.addObserver(target,
                        selector: willHide,
                        name:UIResponder.keyboardWillHideNotification,
                        object: object)
    }
    
    static func unregisterKeyboardHandler(_ target: Any,
                                          object: Any? = nil) {
        def.removeObserver(target,
                           name: UIResponder.keyboardWillShowNotification,
                           object: object)
        def.removeObserver(target,
                           name: UIResponder.keyboardWillHideNotification,
                           object: object)
    }
    
}


