// gif图片转成图片数组

import Foundation
import UIKit

public extension UIImage {
    func startGifWithImageName(name: String) -> [UIImage] {
        guard let path = Bundle.main.path(forResource: name, ofType: "gif") else {
            print("SwiftGif: Source for the image does not exist")

            return []
        }

        return startGifWithFilePath(filePath: path)
    }

    // MARK: 实现动图效果

    func startGifWithFilePath(filePath: String) -> [UIImage] {
        // 1.加载GIF图片，并转化为data类型

        guard let data = NSData(contentsOfFile: filePath) else { return [] }

        // 2.从data中读取数据，转换为CGImageSource

        guard let imageSource = CGImageSourceCreateWithData(data, nil) else { return [] }

        let imageCount = CGImageSourceGetCount(imageSource)

        // 3.遍历所有图片

        var images = [UIImage]()

        var totalDuration: TimeInterval = 0

        for i in 0 ..< imageCount {
            // 3.1取出图片

            guard let cgImage = CGImageSourceCreateImageAtIndex(imageSource, i, nil) else { continue }

            let image = UIImage(cgImage: cgImage)
            UIGraphicsBeginImageContextWithOptions(CGSize(width: 28, height: 28), 0 != 0, UIScreen.main.scale)
            // UIGraphicsBeginImageContext(newSize);
            image.draw(in: CGRect(x: 0, y: 0, width: 28, height: 28))

            let newImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            images.append(newImage!)

            // 3.2取出持续时间

            guard let properties = CGImageSourceCopyPropertiesAtIndex(imageSource, i, nil) as? NSDictionary else { continue }

            guard let gifDict = properties[kCGImagePropertyGIFDictionary] as? NSDictionary else { continue }

            guard let frameDuration = gifDict[kCGImagePropertyGIFDelayTime] as? NSNumber else { continue }

            totalDuration += frameDuration.doubleValue
        }

        return images
    }
}
