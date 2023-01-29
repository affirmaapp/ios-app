//
//  AffirmationCardView.swift
//  Affirma
//
//  Created by Airblack on 22/01/23.
//

import Foundation
import UIKit

class AffirmationCardView: UIView {
    
    @IBOutlet var affirmationCardView: UIView!
    @IBOutlet weak var imageView: GenericMediaView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var sentStackView: UIStackView!
    
    var sharePressed: ((SelectedThemeModel?) -> Void)?
    var model: SelectedThemeModel?
    var messageModel: ReceivedMessagesDataModel?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("AffirmationCardView", owner: self, options: nil)
        addSubview(affirmationCardView)
        affirmationCardView.frame = self.bounds
    }
    
    func render(withModel model: SelectedThemeModel?) {
        guard let model = model else {
            return
        }
        
        self.model = model
        imageView.render(withImage: model.affirmation_image,
                         withVideo: nil, withGif: nil)
        shareButton.isHidden = false
        sentStackView.isHidden = true
        
        label.text = model.affirmation
    }
    
    func render(withModel model: ReceivedMessagesDataModel?) {
        guard let model = model else {
            return
        }
        
        self.messageModel = model
        imageView.render(withImage: model.affirmation_image,
                         withVideo: nil, withGif: nil)
        shareButton.isHidden = true
        sentStackView.isHidden = false
        
        label.text = model.affirmation
    }
    
    @IBAction func shareButtonPressed(_ sender: Any) {
        self.sharePressed?(self.model)
    }
    
}
