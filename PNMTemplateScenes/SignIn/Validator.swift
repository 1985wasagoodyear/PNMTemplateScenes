//
//  Validator.swift
//  PNMTemplateScenes
//
//  Created by K Y on 7/19/19.
//  Copyright © 2019 K Y. All rights reserved.
//

import Foundation

enum Validator {
    static func validPassword(_ password: String) -> Bool {
        return !password.isEmpty
    }
    
    static func validEmail(_ email: String) -> Bool {
        return !email.isEmpty
    }
}
