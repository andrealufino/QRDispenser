//
//  URL+QRDispenser.swift
//  
//
//  Created by Andrea Mario Lufino on 16/08/22.
//

import Foundation
import UIKit


// MARK: - URL - Private

fileprivate extension URL {
    
    var isValidNetworkURL: Bool {
        
        let regex = "((http|https|ftp)://)?((\\w)*|([0-9]*)|([-|_])*)+([\\.|/]((\\w)*|([0-9]*)|([-|_])*))+"
        let url = self.absoluteString
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        
        return predicate.evaluate(with: url)
    }
}


// MARK: - URL - QR representation

public extension URL {
    
    /// The representation of the URL as a qr code (`UIImage` object).
    var qrRepresentation: UIImage {
        
        guard isValidNetworkURL else {
            fatalError("The URL \(self.absoluteString) is not a valid network url.")
        }
        
        return QRDispenser.generate(url: self)
    }
}
