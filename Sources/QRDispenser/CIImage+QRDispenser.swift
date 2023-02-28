//
//  CIImage+QRDispenser.swift
//  
//
//  Created by Andrea Mario Lufino on 19/08/22.
//

import CoreImage
import Foundation
import UIKit


internal extension CIImage {
    
    /// Inverts the colors and creates a transparent image by converting the mask to alpha.
    /// Input image should be black and white.
    var transparent: CIImage? {
        return inverted?.blackTransparent
    }

    /// Inverts the colors.
    var inverted: CIImage? {
        
        let invertedColorFilter = CIFilter.colorInvert()
        invertedColorFilter.setValue(self, forKey: "inputImage")
        return invertedColorFilter.outputImage
    }

    /// Converts all black to transparent.
    var blackTransparent: CIImage? {
        
        let blackTransparentFilter = CIFilter.maskToAlpha()
        blackTransparentFilter.setValue(self, forKey: "inputImage")
        return blackTransparentFilter.outputImage
    }

    /// Applies the given color as a tint color.
    func tinted(using color: UIColor) -> CIImage? {
        
        guard
            let transparentQRImage = transparent,
            let colorFilter = CIFilter(name: "CIConstantColorGenerator") else {
            return nil
        }
        
        let filter = CIFilter.multiplyCompositing()

        let ciColor = CIColor(color: color)
        colorFilter.setValue(ciColor, forKey: kCIInputColorKey)
        let colorImage = colorFilter.outputImage

        filter.setValue(colorImage, forKey: kCIInputImageKey)
        filter.setValue(transparentQRImage, forKey: kCIInputBackgroundImageKey)

        return filter.outputImage!
    }
    
    /// Combines the current image with the given image centered.
    func combined(with image: CIImage) -> CIImage? {
        
        let combinedFilter = CIFilter.sourceOverCompositing()
        let centerTransform = CGAffineTransform(translationX: extent.midX - (image.extent.size.width / 2), y: extent.midY - (image.extent.size.height / 2))
        combinedFilter.setValue(image.transformed(by: centerTransform), forKey: "inputImage")
        combinedFilter.setValue(self, forKey: "inputBackgroundImage")
        
        return combinedFilter.outputImage!
    }
}
