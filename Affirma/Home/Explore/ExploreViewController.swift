//
//  ExploreViewController.swift
//  Affirma
//
//  Created by Airblack on 19/01/23.
//

import Foundation
import UIKit

class ExploreViewController: BaseViewController {

    var viewModel: ExploreViewModel?
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = ExploreViewModel()
        
        registerCells()
        Task {
            _ = try? await handleViewModelCallbacks()
        }
        
    }
    
    private func registerCells() {
        tableView.rowHeight = UIScreen.main.bounds.height
        tableView.estimatedRowHeight = UIScreen.main.bounds.height
        tableView.separatorStyle = .none
        tableView.isPagingEnabled = true
        tableView.bounces = false
        tableView.estimatedSectionHeaderHeight = CGFloat.leastNormalMagnitude
        tableView.sectionHeaderHeight = CGFloat.leastNormalMagnitude
        tableView.estimatedSectionFooterHeight = CGFloat.leastNormalMagnitude
        tableView.sectionFooterHeight = CGFloat.leastNormalMagnitude
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "SelfAffirmationTableViewCell",
                                 bundle: nil),
                           forCellReuseIdentifier: "SelfAffirmationTableViewCell")
    }
    
    func handleViewModelCallbacks() async {
        Task {
            _ = try? await viewModel?.fetchImageList()
            _ = try? await viewModel?.fetchTextList()
        }
        
        viewModel?.reloadData = {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
}


extension ExploreViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel?.affirmationTextList.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: SelfAffirmationTableViewCell = tableView.dequeue(cellForRowAt: indexPath)
        cell.render(withText: viewModel?.chooseAffirmationText(),
                    withImage: viewModel?.chooseAffirmationImage())
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.tableView.frame.size.height
    }
    
    
    
}
