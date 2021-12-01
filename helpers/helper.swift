//
//  helper.swift
//  bookLab
//
//  Created by Josef Jakobsson on 2021-09-04.
//

import Foundation
import UIKit
import FirebaseFirestore

class Helpers {
    
    
    static func isEmailValid(_ email: String) -> Bool{
        let regEmail = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let predEmail = NSPredicate(format: "SELF MATCHES %@", regEmail)
        
        return predEmail.evaluate(with: email)
    }
    
}

