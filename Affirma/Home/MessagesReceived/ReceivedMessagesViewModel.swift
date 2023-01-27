//
//  ReceivedMessagesViewModel.swift
//  Affirma
//
//  Created by Airblack on 27/01/23.
//

import Foundation

class ReceivedMessagesViewModel: BaseViewModel {
    
    // MARK: Properties
    private var manager: ReceivedMessagesManager?
    
    var data: ReceivedMessagesBaseModel?
    var reloadData: (() -> Void)?
    var showEmptyScreen: (() -> Void)?
    
    // MARK: Init
    override init() {
        super.init()
        manager = ReceivedMessagesManager()
        
    }
    
    func fetchMessages() async {
        await manager?.fetchMessages(completion: { data  in
            self.data = data
            if let messages = data?.data,
                messages.count > 0 {
                print("MESSAGES CARDS LIST: \(self.data)")
                self.reloadData?()
            } else {
                self.showEmptyScreen?()
            }
        })
    }
}


