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
    
    func fetchData() {
        let myGroup = DispatchGroup()
        
        myGroup.enter()
        myGroup.enter()
        
        Task {
            let _ = try? await fetchImageList(completion: { dataFetched in
                myGroup.leave()
            })
            
            let _ = try? await fetchTextList(completion: { dataFetched in
                myGroup.leave()
            })
        }
        
        myGroup.notify(queue: DispatchQueue.main) {
            self.reloadData?()
        }
    }
    
    func fetchImageList(completion: @escaping ((Bool) -> Void)) async {
        await manager?.fetchAffirmationImages(completion: { imagesList in
            self.affirmationImagesList = imagesList
            
            print("LIST: \(imagesList.count)")
            completion(true)
        })
    }
    
    func fetchTextList(completion: @escaping ((Bool) -> Void)) async {
        await manager?.fetchAffirmationText(completion: { textList in
            self.affirmationTextList = textList
            
            print("TEXT LIST: \(textList.count)")
            completion(true)
            
        })
    }
    
    func chooseAffirmationText() -> AffirmationText? {
        return self.affirmationTextList.randomElement()
    }
    
    func chooseAffirmationImage() -> AffirmationImage? {
        return self.affirmationImagesList.randomElement()
    }
    
}
