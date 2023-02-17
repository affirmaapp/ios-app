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
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var downloadButton: UIButton!
    
    var takeScreenshot: (() -> Void)?
    override func awakeFromNib() {
        super.awakeFromNib()
        
        likeButton.isHidden = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
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
    
    func render(withText text: String?,
                withImage image: AffirmationImage?) {
        
        if let text = text {
            self.label.text = text
        }
        
        if let image = image {
            mediaView.render(withImage: image.image_url,
                             withVideo: nil,
                             withGif: nil)
        }
    }
    
    func prepareForScreenshot() {
        self.downloadButton.isHidden = true
//        self.likeButton.isHidden = true
    }
    
    func handleAfterScreenshotUI() {
        self.downloadButton.isHidden = false
//        self.likeButton.isHidden = false
        
//        self.layoutIfNeeded()
    }
    
    @IBAction func downloadButtonClicked(_ sender: Any) {
        self.takeScreenshot?()
        
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }
    
    @IBAction func likeButtonClicked(_ sender: Any) {
        
    }
}
