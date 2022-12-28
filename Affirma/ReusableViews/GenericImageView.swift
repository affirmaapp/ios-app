//
//  GenericImageView.swift
//  Affirma
//
//  Created by Airblack on 28/12/22.
//

import Foundation
import UIKit

class GenericImageView: UIView {
    
    @IBOutlet var genericImageView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("GenericImageView", owner: self, options: nil)
        addSubview(genericImageView)
        genericImageView.frame = self.bounds
    }
    
    // MARK: Setting Up UI
    func render(withImage image: String?,
                isAspectFit: Bool?,
                withPlaceholderImage placeholder: UIImage?) {
        resetUI()
        

        self.imageView.layoutIfNeeded()
        let imageWidth = round(imageView.frame.width)
        
        if let image = image {
            
            if let isAspectFit = isAspectFit, isAspectFit == true {
                imageView.contentMode = .scaleAspectFit
            } else {
                imageView.contentMode = .scaleAspectFill
            }
            
            ImageDownloadManager.shared.setImage(withUrlString: image,
                                                 withPlaceholderImage: placeholder,
                                                 withImageView: imageView) { _, _ in
                print("progress")
            } withCompletionBlock: { _, _, _ in
                self.imageView.image = self.imageView.image?.withRenderingMode(.alwaysOriginal)
            }
        }
    }
    
    func resetUI() {
       imageView.image = nil
   }
    
}
