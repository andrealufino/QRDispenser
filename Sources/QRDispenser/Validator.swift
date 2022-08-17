//
//  Validator.swift
//  
//
//  Created by Andrea Mario Lufino on 16/08/22.
//

import Foundation


internal enum DataType {
    case url
    case email
    case phoneNumber
}

internal struct Validator {
    
    static func validate(_ string: String, type: DataType) -> Bool {
        
        switch type {
        case .url:
            return validateURL(string)
        case .email:
            return validateEmail(string)
        case .phoneNumber:
            return validatePhoneNumber(string)
        }
    }
}


fileprivate extension Validator {
    
    static func validateURL(_ url: String) -> Bool {
        
        let regex = "((http|https|ftp)://)?((\\w)*|([0-9]*)|([-|_])*)+([\\.|/]((\\w)*|([0-9]*)|([-|_])*))+"
        let url = url
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        
        return predicate.evaluate(with: url)
    }
    
    static func validateURL(_ url: URL) -> Bool {
        
        let regex = "((http|https|ftp)://)?((\\w)*|([0-9]*)|([-|_])*)+([\\.|/]((\\w)*|([0-9]*)|([-|_])*))+"
        let url = url.absoluteString
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        
        return predicate.evaluate(with: url)
    }
    
    static func validateEmail(_ email: String) -> Bool {
        
        let regex = "(?:[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}" +
            "~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\" +
            "x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[\\p{L}0-9](?:[a-" +
            "z0-9-]*[\\p{L}0-9])?\\.)+[\\p{L}0-9](?:[\\p{L}0-9-]*[\\p{L}0-9])?|\\[(?:(?:25[0-5" +
            "]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-" +
            "9][0-9]?|[\\p{L}0-9-]*[\\p{L}0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21" +
            "-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        
        return predicate.evaluate(with: email)
    }
    
    static func validatePhoneNumber(_ phoneNumber: String) -> Bool {
        
        do {
            let detector = try NSDataDetector(types: NSTextCheckingResult.CheckingType.phoneNumber.rawValue)
            let matches = detector.matches(in: phoneNumber, options: [], range: NSRange(location: 0, length: phoneNumber.count))
            if let res = matches.first {
                return res.resultType == .phoneNumber && res.range.location == 0 && res.range.length == phoneNumber.count
            } else {
                return false
            }
        } catch {
            return false
        }
    }
}
