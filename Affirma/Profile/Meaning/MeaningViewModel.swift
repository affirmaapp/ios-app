//
//  MeaningViewModel.swift
//  Affirma
//
//  Created by Airblack on 31/01/23.
//

import Foundation

class MeaningViewModel: BaseViewModel {
    
    // MARK: Properties
    private var manager: MeaningManager?
    
    var meanings: [MeaningModel] = []
    
    var reloadData: (() -> Void)?
    // MARK: Init
    override init() {
        super.init()
        manager = MeaningManager()
        
    }
    
    func fetchSymbolMeanings() async {
        await manager?.fetchSymbolMeanings(completion: { meanings in
            self.meanings = meanings
            
            print("SYMBOL LIST: \(meanings.count)")
            self.reloadData?()
        })
    }
}
