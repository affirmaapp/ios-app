//
//  ReceivedMessagesViewController.swift
//  Affirma
//
//  Created by Airblack on 20/01/23.
//

import Foundation
import UIKit

class ReceivedMessagesViewController: BaseViewController {
    
    @IBOutlet var gradientView: UIView!
    @IBOutlet weak var emptyMessageView: EmptyMessageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var headerLabel: UILabel!
    var viewModel: ReceivedMessagesViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = ReceivedMessagesViewModel()
        
        Task {
            _ = try? await handleViewModelCallbacks()
        }

        addObservers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        gradientView.applyGradient(withColours: [Colors.black_2E302F.value,
                                                 Colors.black_131415.value],
                                   gradientOrientation: .topLeftBottomRight)
        
    }
    
    private func addObservers() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.addMessage(notification:)),
                                               name: AffirmaNotification.addMessage,
                                               object: nil)
    }
    
    @objc
    func addMessage(notification: Notification) {
        if let userInfo = notification.userInfo as? [String: Any?] {
            if let affirmationToAdd = userInfo["affirmationToAdd"] as? ReceivedMessagesBaseModel {
                Task {
                    _ = try? await self.viewModel?.addMessage(withModel: affirmationToAdd)
                }
            }
        }
    }
    
    private func registerCells() {
        tableView.register(UINib(nibName: "SelfAffirmationTableViewCell",
                                 bundle: nil),
                           forCellReuseIdentifier: "SelfAffirmationTableViewCell")
    }
    
    func handleViewModelCallbacks() async {
        Task {
            _ = try? await viewModel?.fetchMessages()
        }
        
        viewModel?.reloadData = {
            DispatchQueue.main.async {
                self.headerLabel.text = "Wow, it seems like your positive vibes are attracting a lot of affirmations!"
                self.tableView.isHidden = false
                self.emptyMessageView.isHidden = true
                self.registerCells()
                self.tableView.reloadData()
            }
        }
        
        viewModel?.showEmptyScreen = {
            DispatchQueue.main.async {
                self.headerLabel.text = "Take the lead!\nThe more you give, the more you’ll receive"
                self.tableView.isHidden = true
                self.emptyMessageView.isHidden = false
            }
        }
        
    }
}
