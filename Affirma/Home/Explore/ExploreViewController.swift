//
//  ExploreViewController.swift
//  Affirma
//
//  Created by Airblack on 19/01/23.
//

import CoreMotion
import Foundation
import SwiftToast
import UIKit

class ExploreViewController: BaseViewController {

    var viewModel: ExploreViewModel?
    
    @IBOutlet var gradientView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var userButton: UIButton!
    @IBOutlet weak var watermarkImage: UIImageView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showFullScreenLoader()
        viewModel = ExploreViewModel()
        
        Task {
            _ = try? await handleViewModelCallbacks()
        }
        
        addObservers()

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        registerCells()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        gradientView.applyGradient(withColours: [Colors.black_2E302F.value,
                                                 Colors.black_131415.value],
                                   gradientOrientation: .topLeftBottomRight)
        
    }
    

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
        self.tableView.reloadData()
    }
    
    func addObservers() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.reloadExplore(notification:)),
                                               name: AffirmaNotification.reloadExplore,
                                               object: nil)
    }
    
    @objc
    func reloadExplore(notification: Notification) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.tableView.reloadData()
        }
    }
    
    private func registerCells() {
        tableView.rowHeight = self.tableView.frame.size.height
        tableView.estimatedRowHeight = self.tableView.frame.size.height
        tableView.separatorStyle = .none
        tableView.isPagingEnabled = true
        tableView.bounces = false
        tableView.estimatedSectionHeaderHeight = 1
        tableView.sectionHeaderHeight = 1
        tableView.estimatedSectionFooterHeight = 1
        tableView.sectionFooterHeight = 1
        tableView.delegate = self
        tableView.dataSource = self
        tableView.autoresizesSubviews = false 
        tableView.register(UINib(nibName: "SelfAffirmationTableViewCell",
                                 bundle: nil),
                           forCellReuseIdentifier: "SelfAffirmationTableViewCell")
    }
    
    func handleViewModelCallbacks() async {
        viewModel?.fetchData()
        
        
        viewModel?.reloadData = {
            //            DispatchQueue.main.async {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                self.hideFullScreenLoader()
                self.registerCells()
                self.tableView.reloadData()
            }
            
            //            }
        }
    }
    
    func takeScreenshot(completion: @escaping ((Bool) -> Void)) {
        
        if let keywindow = UIApplication.shared.keyWindow {
            let layer = keywindow.layer
            let scale = UIScreen.main.scale
            UIGraphicsBeginImageContextWithOptions(layer.frame.size, false, scale);
            
            layer.render(in: UIGraphicsGetCurrentContext()!)
            
            let screenshot = UIGraphicsGetImageFromCurrentImageContext()
            
            UIGraphicsEndImageContext()
            
            if let screenshot = screenshot {
                UIImageWriteToSavedPhotosAlbum(screenshot, nil, nil, nil)
                completion(true)
                
            }
        }
    }
    
    func prepareForScreenshot() {
        userButton.isHidden = true
        self.tabBarController?.tabBar.alpha = 0
        watermarkImage.alpha = 1
    }
    
    func showToast() {
        let toast =  SwiftToast(
                            text: "Saved!",
                            textAlignment: .center,
                            backgroundColor: Colors.purple_7D5FFF.withAlpha(0.6),
                            textColor: .white,
                            font: Font(.installed(.avenirLight),
                                       size: .custom(20.0)).instance,
                            duration: 2.0,
                            minimumHeight: CGFloat(80.0),
                            statusBarStyle: .darkContent,
                            aboveStatusBar: false,
                            target: nil,
                            style: .navigationBar)
        present(toast, animated: true)
    }
    
    
    func handleAfterScreenshotUI() {
        userButton.isHidden = false
        self.tabBarController?.tabBar.alpha = 1
        watermarkImage.alpha = 0
    }
    
    @IBAction func profileTapped(_ sender: Any) {
        let profileVC = ProfileViewControllerFactory.produce()
        self.navigationController?.pushViewController(profileVC, animated: true)
    }
}


extension ExploreViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel?.affirmationTextList.count ?? 0
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        NotificationManager.shared.resetNotificationData()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: SelfAffirmationTableViewCell = tableView.dequeue(cellForRowAt: indexPath)
        if NotificationManager.shared.affirmationText != nil
            && !(NotificationManager.shared.affirmationText?.isEmpty ?? true) {
            cell.render(withText: NotificationManager.shared.affirmationText,
                        withImage: NotificationManager.shared.affirmationImage)
        } else {
            cell.render(withText: viewModel?.chooseAffirmationText(),
                        withImage: viewModel?.chooseAffirmationImage())
        }
        cell.selectionStyle = .none
        cell.takeScreenshot = {
            self.prepareForScreenshot()
            cell.prepareForScreenshot()
            self.takeScreenshot { _ in
                self.showToast()
                cell.handleAfterScreenshotUI()
                self.handleAfterScreenshotUI()
                cell.layoutIfNeeded()
                self.view.layoutIfNeeded()
            }
        }
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.tableView.frame.size.height
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.tableView.frame.size.height
    }
    
}
