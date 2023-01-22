//
//  AffirmationCardCollectionViewCell.swift
//  Affirma
//
//  Created by Airblack on 22/01/23.
//

import Foundation
import UIKit

class AffirmationCardCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var cardView: AffirmationCardView!
    
    var sharePressed: ((SelectedThemeModel?) -> Void)?
    
    func render(withModel model: SelectedThemeModel?) {
        guard let model = model else {
            return
        }
        
        cardView.render(withModel: model)
        cardView.sharePressed = { model in
            self.sharePressed?(model)
        }
    }
    
}
