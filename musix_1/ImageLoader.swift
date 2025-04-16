//
//  ImageLoader.swift
//  musix
//
//  Created by WPackham on 4/15/25.
//
import UIKit

extension UIImageView {
    private static var imageCache = NSCache<NSString, UIImage>()
    
    func setImage(from url: String, placeholder: UIImage?) {
        // Set placeholder immediately
        self.image = placeholder
        
        // Clear image if URL is empty
        guard !url.isEmpty, let imageURL = URL(string: url) else {
            return
        }
        
        // Check cache
        let urlKey = url as NSString
        if let cachedImage = UIImageView.imageCache.object(forKey: urlKey) {
            self.image = cachedImage
            return
        }
        
        // Async load
        DispatchQueue.global(qos: .userInitiated).async {
            if let data = try? Data(contentsOf: imageURL),
               let image = UIImage(data: data) {
                UIImageView.imageCache.setObject(image, forKey: urlKey)
                DispatchQueue.main.async {
                    self.image = image
                }
            }
        }
    }
}
