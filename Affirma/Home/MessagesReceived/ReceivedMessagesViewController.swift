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
    @IBOutlet weak var topHeaderHeight: NSLayoutConstraint!
    @IBOutlet weak var topHeader: UIView!
    
    var viewModel: ReceivedMessagesViewModel?
    var dataFetched: Bool = false

    let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = ReceivedMessagesViewModel()
        
        self.showFullScreenLoader()
        
        Task {
            _ = try? await handleViewModelCallbacks()
        }
        
        self.tableView.isHidden = true
        self.emptyMessageView.isHidden = true
        
        addObservers()
        self.registerCells()
        tableView.delegate = self
        tableView.dataSource = self
        
        self.tableView.contentInset = UIEdgeInsets(top: 30, left: 0, bottom: 100, right: 0)
        
        let properties: [String: Any] = ["source":  AffirmaStateManager.shared.source]
        EventManager.shared.trackEvent(event: .landedOnMessageReceived, properties: properties)
        
        AffirmaStateManager.shared.source = "tab"
        
        refreshControl.tintColor = Colors.white_E5E5E5.value
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        tableView.addSubview(refreshControl) // not required when using UITableViewController
    }
    
    @objc func refresh(_ sender: AnyObject) {
       // Code to refresh table view
        Task {
            _ = try? await viewModel?.fetchMessages()
        }
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
                if let shouldAdd = userInfo["shouldAddToList"] as? Bool,
                    shouldAdd == true {
                    Task {
                        _ = try? await self.viewModel?.addMessage(withModel: affirmationToAdd)
                    }
                }
            }
        }
    }
    
    private func registerCells() {
        tableView.register(UINib(nibName: "AffirmationMessageTableViewCell",
                                 bundle: nil),
                           forCellReuseIdentifier: "AffirmationMessageTableViewCell")
    }
    
    func handleViewModelCallbacks() async {
        Task {
            _ = try? await viewModel?.fetchMessages()
        }
        
        emptyMessageView.sendLoveClicked = {
            self.tabBarController?.selectedIndex = 1
        }
        
        viewModel?.refreshData = {
            Task {
                _ = try? await self.viewModel?.fetchMessages()
            }
        }
        
        viewModel?.reloadData = {
            DispatchQueue.main.async {
                self.refreshControl.endRefreshing()
                self.dataFetched = true 
                self.hideFullScreenLoader()
                self.headerLabel.text = "Wow, it seems like your positive vibes are attracting a lot of affirmations!"
                self.tableView.isHidden = false
                self.emptyMessageView.isHidden = true
                self.tableView.reloadData()
            }
        }
        
        viewModel?.showEmptyScreen = {
            DispatchQueue.main.async {
                self.dataFetched = true
                self.hideFullScreenLoader()
                self.headerLabel.text = "Take the lead!\nThe more you give, the more you’ll receive"
                self.tableView.isHidden = true
                self.emptyMessageView.isHidden = false
            }
        }
    }
    
    func hideTopHeader() {
        topHeaderHeight.constant = 0
        UIView.animate(withDuration: 0.8, delay: 0) {
            self.view.layoutIfNeeded()
        } completion: { _ in
            self.topHeader.alpha = 0
        }
    }
    
    func showTopHeader() {
        topHeaderHeight.constant = 180
        UIView.animate(withDuration: 0.5, delay: 0) {
            self.view.layoutIfNeeded()
        } completion: { _ in
            self.topHeader.alpha = 1
        }
    }
}

extension ReceivedMessagesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel?.data?.messages?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: AffirmationMessageTableViewCell = tableView.dequeue(cellForRowAt: indexPath)
        if let list = viewModel?.data?.messages, list.count > indexPath.row {
            cell.render(withModel: list[indexPath.row])
        }
        cell.selectionStyle = .none
        return cell
        
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIScreen.main.bounds.height * 0.7
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if dataFetched {
            if scrollView.contentOffset.y > 100 {
                hideTopHeader()
            } else {
                showTopHeader()
            }
        }
    }
    
}
