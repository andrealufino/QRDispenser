//
//  QRDispenser.swift
//  
//
//  Created by Andrea Mario Lufino on 15/08/22.
//

import CoreImage
import CoreImage.CIFilterBuiltins
import CoreLocation
import Foundation
import UIKit


public enum WiFiEncryption {
    case wep
    case wpa
    case none
    
    var string: String {
        switch self {
        case .wep:
            return "WEP"
        case .wpa:
            return "WPA"
        default:
            return "nopass"
        }
    }
}


public struct QRDispenser {
    
    // This code has been taken from Hacking With Swift forum.
    // https://www.hackingwithswift.com/forums/swiftui/qr-code-generator-cifilter-colours-for-light-dark-mode/13077
    public static func generate(from text: String) -> UIImage {
        
        let context = CIContext()
        
        var qrImage = UIImage(systemName: "xmark.circle") ?? UIImage()
        let data    = Data(text.utf8)
        let filter  = CIFilter.qrCodeGenerator()

        // ref : https://stackoverflow.com/questions/57704885/how-can-i-check-ios-devices-current-userinterfacestyle-programmatically
        var osTheme: UIUserInterfaceStyle { return UIScreen.main.traitCollection.userInterfaceStyle }
        filter.setValue(data, forKey: "inputMessage")

        let transform = CGAffineTransform(scaleX: 8, y: 8)
        if let outputImage = filter.outputImage?.transformed(by: transform) {
            if let _ = context.createCGImage(outputImage, from: outputImage.extent) {

                let maskFilter = CIFilter.blendWithMask()
                maskFilter.maskImage = outputImage.applyingFilter("CIColorInvert")
                maskFilter.inputImage = CIImage(color: .white)

                let darkCIImage = maskFilter.outputImage!
                maskFilter.inputImage = CIImage(color: .black)

                let lightCIImage = maskFilter.outputImage!
                let darkImage   = context.createCGImage(darkCIImage, from: darkCIImage.extent).map(UIImage.init)!
                let lightImage  = context.createCGImage(lightCIImage, from: lightCIImage.extent).map(UIImage.init)!

                qrImage = osTheme == .light ? lightImage : darkImage
            }
        }
        
        return qrImage
    }
}


public extension QRDispenser {
    
    static func generate(simpleText text: String) -> UIImage {
        
        return generate(from: text)
    }
    
    static func generate(email: String) -> UIImage {
        
        // TODO: Add email validation
        
        let dataString = "mailto:\(email)"
        
        return generate(from: dataString)
    }
    
    static func generate(phoneNumber: String) -> UIImage {
        
        // TODO: Add phone number validation
        
        let dataString = "tel:\(phoneNumber)"
        
        return generate(from: dataString)
    }
    
    static func generate(wiFiSSID ssid: String, password: String, encryption: WiFiEncryption) -> UIImage {
        
        guard !ssid.isEmpty else {
            fatalError("ssid cannot be empty.")
        }
        
        guard !password.isEmpty else {
            fatalError("password cannot be empty.")
        }
        
        let dataString = "WIFI:S:\(ssid);T:\(encryption.string);P:\(password);;"
        
        return generate(from: dataString)
    }
    
    static func generate(latitude: Double, longitude: Double, altitude: Double) -> UIImage {
        
        let dataString = "geo:\(latitude),\(longitude),\(altitude)"
        
        return generate(from: dataString)
    }
    
    static func generate(location: CLLocation) -> UIImage {
        
        return generate(
            latitude: location.coordinate.latitude,
            longitude: location.coordinate.longitude,
            altitude: location.altitude
        )
    }
}
