//
//  SelfAffirmationTableViewCell.swift
//  Affirma
//
//  Created by Airblack on 20/01/23.
//

import Foundation
import UIKit

class SelfAffirmationTableViewCell: UITableViewCell {
    
    @IBOutlet weak var mediaView: GenericMediaView!
    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        gradientView.applyGradient(withColours: [Colors.black_2E302F.value,
                                                 Colors.black_131415.value],
                                   gradientOrientation: .topLeftBottomRight)
        
    }
    
    func render(withText text: AffirmationText?,
                withImage image: AffirmationImage?) {
        
        if let text = text {
            self.label.text = text.text
        }
        
        if let image = image {
            mediaView.render(withImage: image.image_url,
                             withVideo: nil,
                             withGif: nil)
        }
    }
}
