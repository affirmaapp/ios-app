//
//  ImageCollectionViewCell.swift
//  Affirma
//
//  Created by Airblack on 18/02/23.
//

import Foundation
import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    func render(withImageName name: String) {
        imageView.image = UIImage(named: name)
    }
}
