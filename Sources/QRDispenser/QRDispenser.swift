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


// MARK: - WiFi Encryption

/// Enumeration used to indicate which type of encryption is present in
/// the wifi network that is going to be represented with a QR code.
public enum WiFiEncryption: String, CaseIterable {
    case wep    = "wep"
    case wpa    = "wpa"
    case none   = "none"
    
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


// MARK: - QRDispenser


/// `QRDispenser` is the structure that generate the QR code returning it as `UIImage`.
///
/// This structure provides static methods to generate qr codes. It does not need to be instantiated.
///
public struct QRDispenser {
    
    static var isDebugPrintingActive = true
    
    private init() {  }
    
    // MARK: - QRDispenserError

    /// Enumeration representing an error that can occur during qr code creation.
    public enum QRDispenserError: Error, LocalizedError {
        case invalidURL
        case invalidEmail
        case invalidPhoneNumber
        case emptySSID
        case emptyPassword
        case cgiImageCreationFailure
        case filterOutputImageNil
        case generic(String)
    }
    
    // This code has been taken from Hacking With Swift forum.
    // https://www.hackingwithswift.com/forums/swiftui/qr-code-generator-cifilter-colours-for-light-dark-mode/13077
    
    /// Generate a qr code containing the `text` as data.
    ///
    /// This method generates a qr code containing the passed `text` parameter as internal data.
    /// The format of the text is assumed to be correct, so no checks are made on that.
    ///
    /// - Parameters:
    ///   - text: The text to represent as qr code.
    ///   - tint: The tint color to apply to the image. Normally, no tint is applied.
    /// - Returns: An `UIImage` object representing the qr code.
    /// - Throws: An error of type `QRDispenserError` that can be `cgiImageCreationFailure`
    /// or `filterOutputImageNil`.
    static func generate(from text: String, tint: UIColor? = nil) throws -> UIImage {
        
        let context = CIContext()
        
        var qrImage = UIImage()
        let data    = Data(text.utf8)
        let filter  = CIFilter.qrCodeGenerator()

        // ref : https://stackoverflow.com/questions/57704885/how-can-i-check-ios-devices-current-userinterfacestyle-programmatically
        var osTheme: UIUserInterfaceStyle { return UIScreen.main.traitCollection.userInterfaceStyle }
        filter.setValue(data, forKey: "inputMessage")

        let transform = CGAffineTransform(scaleX: 10, y: 10)
        if let outputImage = filter.outputImage?.transformed(by: transform) {
            if let _ = context.createCGImage(outputImage, from: outputImage.extent) {
                
                if let tint = tint {
                    
                    let tintedImage  = outputImage.tinted(using: tint)!
                    qrImage = context.createCGImage(tintedImage, from: tintedImage.extent).map(UIImage.init)!
                    
                } else {
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
                
                return qrImage
            } else {
                throw QRDispenserError.cgiImageCreationFailure
            }
        } else {
            throw QRDispenserError.filterOutputImageNil
        }
    }
}


// MARK: - QRDispenser - Specific methods

public extension QRDispenser {
    
    /// Generate a qr code containing a simple text.
    /// - Parameter text: The text to represent.
    /// - Returns: An `UIImage` object representing the qr code or a template image in case something went wrong.
    /// - Throws: An error of type `QRDispenserError` that can be `cgiImageCreationFailure`
    /// or `filterOutputImageNil`.
    static func generate(simpleText text: String) throws -> UIImage {
        
        return try generate(from: text)
    }
    
    /// Generate a qr code representing a url.
    /// The format of the url is validated before trying to generate the code.
    /// - Parameter url: The url to represent.
    /// - Returns: An `UIImage` object representing the qr code or a template image in case something went wrong.
    /// - Throws: An error of type `QRDispenserError` that can be `cgiImageCreationFailure`,
    /// `filterOutputImageNil` or `invalidURL`.
    static func generate(url: URL, tint: UIColor? = nil) throws -> UIImage {
        
        guard Validator.validate(url.absoluteString, type: .url) else {
            if isDebugPrintingActive {
                print("QRDispenser | Url \(url) is not a valid url.")
            }
            throw QRDispenserError.invalidURL
        }
        
        return try generate(from: url.absoluteString, tint: tint)
    }
    
    /// Generate a qr code representing an email.
    /// The format of the email is validate before trying to generate the code.
    /// - Parameter email: The email address to represent in the qr code.
    /// - Returns: An `UIImage` object representing the qr code or a template image in case something went wrong.
    /// - Throws: An error of type `QRDispenserError` that can be `cgiImageCreationFailure`,
    /// `filterOutputImageNil` or `invalidEmail`.
    static func generate(email: String) throws -> UIImage {
        
        guard Validator.validate(email, type: .email) else {
            if isDebugPrintingActive {
                print("QRDispenser | The email \(email) is not a valid email address.")
            }
            throw QRDispenserError.invalidEmail
        }
        
        let dataString = "mailto:\(email)"
        
        return try generate(from: dataString)
    }
    
    /// Generate a qr code representing a phone number.
    /// The format of the phone number is validated before trying to generate the code.
    /// - Parameter phoneNumber: The phone number to represent in the qr code.
    /// - Returns: An `UIImage` object representing the qr code or a template image in case something went wrong.
    /// - Throws: An error of type `QRDispenserError` that can be `cgiImageCreationFailure`,
    /// `filterOutputImageNil` or `invalidPhoneNumber`.
    static func generate(phoneNumber: String) throws -> UIImage {
        
        guard Validator.validate(phoneNumber, type: .phoneNumber) else {
            if isDebugPrintingActive {
                print("QRDispenser | The phone number \(phoneNumber) is not a valid phone number.")
            }
            throw QRDispenserError.invalidPhoneNumber
        }
        
        let dataString = "tel:\(phoneNumber)"
        
        return try generate(from: dataString)
    }
    
    /// Generate a qr code representing a WiFi network.
    /// - Parameters:
    ///   - ssid: The SSID of the network (network name).
    ///   - password: The password of the network.
    ///   - encryption: The encryption of the network.
    /// - Returns: An `UIImage` object representing the qr code or a template image in case something went wrong.
    /// - Throws: An error of type `QRDispenserError` that can be `cgiImageCreationFailure`,
    /// `filterOutputImageNil`,`emptySSID` or `emptyPassword`.
    static func generate(wiFiSSID ssid: String, password: String, encryption: WiFiEncryption) throws -> UIImage {
        
        guard !ssid.isEmpty else {
            if isDebugPrintingActive {
                print("QRDispenser | ssid cannot be empty.")
            }
            throw QRDispenserError.emptySSID
        }
        
        guard !password.isEmpty else {
            if isDebugPrintingActive {
                print("QRDispenser | password cannot be empty.")
            }
            throw QRDispenserError.emptyPassword
        }
        
        let dataString = "WIFI:S:\(ssid);T:\(encryption.string);P:\(password);;"
        
        return try generate(from: dataString)
    }
    
    /// Generate a qr code representing a location.
    /// - Parameters:
    ///   - latitude: The latitude as `Double`.
    ///   - longitude: The longitude as `Double`.
    ///   - altitude: The altitude as `Double`.
    /// - Returns: An `UIImage` object representing the qr code or a template image in case something went wrong.
    /// - Throws: An error of type `QRDispenserError` that can be `cgiImageCreationFailure`
    /// or `filterOutputImageNil`.
    static func generate(latitude: Double, longitude: Double, altitude: Double) throws -> UIImage {
        
        let dataString = "geo:\(latitude),\(longitude),\(altitude)"
        
        return try generate(from: dataString)
    }
    
    /// Generate a qr code representing a location.
    /// - Parameter location: The location as `CLLocation` object.
    /// - Returns: An `UIImage` object representing the qr code or a template image in case something went wrong.
    /// - Throws: An error of type `QRDispenserError` that can be `cgiImageCreationFailure`
    /// or `filterOutputImageNil`.
    static func generate(location: CLLocation) throws -> UIImage {
        
        return try generate(
            latitude: location.coordinate.latitude,
            longitude: location.coordinate.longitude,
            altitude: location.altitude
        )
    }
}
