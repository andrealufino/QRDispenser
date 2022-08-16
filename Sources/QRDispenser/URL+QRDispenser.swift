//
//  URL+QRDispenser.swift
//  
//
//  Created by Andrea Mario Lufino on 16/08/22.
//

import Foundation
import UIKit


// MARK: - URL - QR representation

public extension URL {
    
    /// The representation of the URL as a qr code (`UIImage` object).
    var qrRepresentation: UIImage {
        
        guard Validator.validate(self.absoluteString, type: .url) else {
            fatalError("The URL \(self.absoluteString) is not a valid network url.")
        }
        
        return QRDispenser.generate(url: self)
    }
}
