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

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        gradientView.applyGradient(withColours: [Colors.black_2E302F.value,
                                                 Colors.black_131415.value],
                                   gradientOrientation: .topLeftBottomRight)
        
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
