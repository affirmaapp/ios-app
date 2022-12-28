//
//  ImageDownloadManager.swift
//  Affirma
//
//  Created by Airblack on 28/12/22.
//

import Kingfisher
import Foundation
import UIKit

public typealias ImageDownloadCompletionBlock = ((_ image: UIImage?, _ error: NSError?, _ imageURL: URL?) -> Void)
public typealias ImageDownloadProgressBlock = ((_ receivedSize: Int64, _ totalSize: Int64) -> Void)

class ImageDownloadManager {
    static let shared = ImageDownloadManager()
   
    private func determineFinalUrl(fromUrlString urlString: String?, withImageView imageView: UIImageView?) -> String? {
        guard let urlString = removingPercentEncoding(witUrlString: urlString), let imageView = imageView else {
            return nil
        }
        
        return urlString
    }
    
    private func removingPercentEncoding(witUrlString urlString: String?) -> String? {
        guard let urlString = urlString else {
            return nil
        }
        let stringToRemoveEncoding = NSString(string: urlString)
        let finalString = stringToRemoveEncoding.removingPercentEncoding
        return finalString
    }
    
    func retrieveImage(withURL urlString: String, imageCompletionHandler: @escaping (UIImage?) -> Void) {
        guard let url = URL.init(string: urlString) else {
            return  imageCompletionHandler(nil)
        }
        let resource = ImageResource(downloadURL: url)
        
        KingfisherManager.shared.retrieveImage(with: resource, options: nil, progressBlock: nil) { result in
            switch result {
            case .success(let value):
                imageCompletionHandler(value.image)
            case .failure:
                imageCompletionHandler(nil)
            }
        }
    }
    
    func setImage(withUrlString urlString: String?,
                  withPlaceholderImage placeholder: UIImage? = nil,
                  withImageView imageView: UIImageView?,
                  withProgressBlock progressBlock: ImageDownloadProgressBlock?,
                  withCompletionBlock completionBlock: ImageDownloadCompletionBlock?) {
        if let urlString = urlString, let imageView = imageView {
            if let finalUrlString = determineFinalUrl(fromUrlString: urlString,
                                                      withImageView: imageView),
               let finalUrl = URL(string: finalUrlString) {
                imageView.kf.setImage(
                    with: finalUrl,
                    placeholder: placeholder,
                    options: [
                        .scaleFactor(UIScreen.main.scale),
                        .transition(.fade(0.3)),
                        .cacheOriginalImage
                    ],
                    progressBlock: { receivedSize, totalSize in
                        // Progress updated
                        if let progressBlock = progressBlock {
                            progressBlock(receivedSize, totalSize)
                        }
                    }) { result in
                    switch result {
                    case .success(let value):
                        if let completionBlock = completionBlock {
                            completionBlock(value.image, nil, value.source.url)
                        }
                        _ = "\(String(describing: value.source.url?.absoluteString))"
                    case .failure(let error):
                        print("error: \(error)")
                    }
                }
            }
        }
    }
}

