//
//  SelectedThemeViewModel.swift
//  Affirma
//
//  Created by Airblack on 21/01/23.
//

import Foundation

class SelectedThemeViewModel: BaseViewModel {
    
    // MARK: Properties
    private var manager: SelectedThemeManager?
    
    var themes: [SelectedThemeModel] = []
    var selectedThemeCards: [SelectedThemeModel] = []
    var selectedTheme: String?
    var reloadData: (() -> Void)?
    var count: Int = 1
    var generatedCards: [SelectedThemeModel] = []
    
    var showChancesOverPopup: (() -> Void)?
    var showLessOptionsPopup: (() -> Void)?
    var scrollToItem: ((Int) -> Void)?
    
    // MARK: Init
    override init() {
        super.init()
        manager = SelectedThemeManager()
        
    }
    
    func fetchCards() async {
        self.generatedCards = []
        await manager?.fetchSelectedThemeData(forTheme: selectedTheme, completion: { themes in
            self.themes = themes
            for theme in themes {
                if let themeArray = theme.theme {
                    if themeArray.contains(self.selectedTheme ?? "") {
                        self.selectedThemeCards.append(theme)
                    }
                }
            }
            self.generatedCards.append(self.pickAnElement())
            
            print("SELECTED CARDS LIST: \(self.selectedThemeCards)")
            self.reloadData?()
        })
    }
    
    func pickAnElement() ->  SelectedThemeModel {
        if let card = selectedThemeCards.randomElement() {
            return card
        }
        return SelectedThemeModel()
    }
    
    func addToGeneratedCards() {
        
        if generatedCards.count == 3 {
            self.showChancesOverPopup?()
            return 
        }
        
        if selectedThemeCards.count < 3 {
            self.showLessOptionsPopup?()
            return
        }
        
        var card = pickAnElement()
        while generatedCards.contains(card) {
            card = pickAnElement()
        }
        
        generatedCards.append(card)
        self.reloadData?()
        
        self.scrollToItem?(generatedCards.count - 1)
    }
    
    func addMessage(forUser userId: String?,
                    withModel model: ReceivedMessagesBaseModel?) async {
        await manager?.addMessage(forUser: userId,
                                  withModel: model, addcompletion: { isAddedSuccessfully in
        })
    }
}
