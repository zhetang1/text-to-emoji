import SwiftUI
import CoreGraphics
import CoreImage
import Foundation

@MainActor
struct AppIconGenerator {
    static func generateIcon() async {
        let size: CGFloat = 1024
        let view = AppIcon()
            .frame(width: size, height: size)
        
        let renderer = ImageRenderer(content: view)
        renderer.scale = 1.0
        
        if let cgImage = renderer.cgImage {
            let outputURL = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
                .appendingPathComponent("emoji keyboard")
                .appendingPathComponent("Assets.xcassets")
                .appendingPathComponent("AppIcon.appiconset")
                .appendingPathComponent("AppIcon.png")
            
            let context = CIContext()
            let ciImage = CIImage(cgImage: cgImage)
            if let pngData = context.pngRepresentation(of: ciImage, format: .RGBA8, colorSpace: ciImage.colorSpace ?? CGColorSpaceCreateDeviceRGB()) {
                do {
                    try pngData.write(to: outputURL)
                    print("Icon generated successfully at \(outputURL.path)")
                } catch {
                    print("Error saving icon: \(error)")
                }
            }
        }
    }
}
