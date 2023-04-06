//
//  UIView+Image.swift
//  BookApp
//
//  Created by Андрей on 06.04.2023.
//

import UIKit
import Kingfisher

extension UIView {
    func downloadImage(
        from urlString: String?,
        withSize size: CGSize = CGSize(width: 50, height: 50),
        placeholder: UIImage = UIImage(),
        completion: @escaping (UIImage?) -> Void) {
            
        DispatchQueue.main.async {
            guard let photo = urlString, let urlImage = URL(string: photo) else { return }

            let source = ImageResource(downloadURL: urlImage, cacheKey: photo)
            let processor = DownsamplingImageProcessor(size: size)
            
            let imageView = UIImageView()
            imageView.kf.setImage(
                with: source,
                placeholder: placeholder,
                options: [
                    .processor(processor)
                ]
            )
            completion(imageView.image)
        }
    }
}
