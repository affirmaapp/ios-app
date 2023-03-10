//
//  ImageCollectionView.swift
//  Affirma
//
//  Created by Airblack on 21/01/23.
//

import Foundation
import UIKit

class ImageCollectionView: UICollectionViewCell {
    
    @IBOutlet weak var mediaView: GenericMediaView!
    
    
    func render(withImage image: String?) {
        mediaView.render(withImage: image, withVideo: nil, withGif: nil)
    }
}
