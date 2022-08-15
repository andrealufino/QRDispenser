//
//  QRDispenser.swift
//  
//
//  Created by Andrea Mario Lufino on 15/08/22.
//

import Foundation


public struct QRDispenser {
    
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
    
    
}
