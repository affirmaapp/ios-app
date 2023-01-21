//
//  SendLoveViewModel.swift
//  Affirma
//
//  Created by Airblack on 21/01/23.
//

import Foundation

class SendLoveViewModel: BaseViewModel {
    
    // MARK: Properties
    private var manager: SendLoveManager?
    
    var themes: [ThemeData] = []
    
    var reloadData: (() -> Void)?
    // MARK: Init
    override init() {
        super.init()
        manager = SendLoveManager()
        
    }
    
    func fetchThemes() async {
        await manager?.fetchThemeData(completion: { themes in
            self.themes = themes
            
            print("LIST: \(themes.count)")
            self.reloadData?()
        })
    }
}
