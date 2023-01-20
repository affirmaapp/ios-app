//
//  ExploreViewModel.swift
//  Affirma
//
//  Created by Airblack on 20/01/23.
//

import Foundation

class ExploreViewModel: BaseViewModel {
    
    // MARK: Properties
    private var manager: ExploreManager?
    
    var affirmationImagesList: [AffirmationImage] = []
    var affirmationTextList: [AffirmationText] = []
    
    var reloadData: (() -> Void)?
    // MARK: Init
    override init() {
        super.init()
        manager = ExploreManager()
        
    }
    
    
    func fetchImageList() async {
        await manager?.fetchAffirmationImages(completion: { imagesList in
            self.affirmationImagesList = imagesList
            
            print("LIST: \(imagesList.count)")
            self.reloadData?()
        })
    }
    
    func fetchTextList() async {
        await manager?.fetchAffirmationText(completion: { textList in
            self.affirmationTextList = textList
            
            print("TEXT LIST: \(textList.count)")
            self.reloadData?() 
            
        })
    }
    
    func chooseAffirmationText() -> AffirmationText? {
        return self.affirmationTextList.randomElement()
    }
    
    func chooseAffirmationImage() -> AffirmationImage? {
        return self.affirmationImagesList.randomElement()
    }
    
}
