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
        
        get throws {
            try QRDispenser.generate(url: self)
        }
    }
}
