//
//  GenericMediaView.swift
//  Affirma
//
//  Created by Airblack on 29/12/22.
//

import Foundation
import UIKit

class GenericMediaView: UIView {
    @IBOutlet var genericMediaView: UIView!
    @IBOutlet weak var genericGifView: GenericGifView!
    @IBOutlet weak var genericVideoView: GenericVideoView!
    @IBOutlet weak var genericImageView: GenericImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("GenericMediaView", owner: self, options: nil)
        genericMediaView.fixInView(self)
    }
    
    func render(withImage image: String?,
                withVideo video: String?,
                withGif gif: String?,
                withPlaceholder placeholder: UIImage? = nil,
                isAspectFit: Bool? = false) {
        if let image = image, !image.isEmpty {
            genericGifView.alpha = 0
            genericVideoView.alpha = 0
            genericImageView.alpha = 1
            genericImageView.render(withImage: image,
                                    isAspectFit: isAspectFit,
                                    withPlaceholderImage: placeholder)
        } else if let video = video, !video.isEmpty {
            genericGifView.alpha = 0
            genericVideoView.alpha = 1
            genericImageView.alpha = 0
            genericVideoView.render(withVideo: video,
                                    withPlaceholderImage: placeholder,
                                    isAspectFit: isAspectFit)
        } else if let gif = gif {
            genericGifView.alpha = 1
            genericVideoView.alpha = 0
            genericImageView.alpha = 0
            genericGifView.render(withGifUrl: gif, isLoop: true)
        }
    }
}
