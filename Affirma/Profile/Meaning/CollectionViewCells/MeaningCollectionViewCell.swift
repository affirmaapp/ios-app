//
//  MeaningCollectionViewCell.swift
//  Affirma
//
//  Created by Airblack on 31/01/23.
//

import Foundation
import UIKit

class MeaningCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: GenericMediaView!
    @IBOutlet weak var label: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        reset()
    }
    
    func render(withImageUrl imageUrl: String?,
                withLabel labelString: String?) {
        reset()
        imageView.render(withImage: imageUrl,
                         withVideo: nil,
                         withGif: nil)
        
        label.text = labelString
    }
    
    func reset() {
        label.text = nil
    }
}
