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
    
    @IBOutlet var gradientView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var userButton: UIButton!
    @IBOutlet weak var watermarkImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = ExploreViewModel()
        
//        registerCells()
        Task {
            _ = try? await handleViewModelCallbacks()
        }
        
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
        Task {
            _ = try? await viewModel?.fetchImageList()
            _ = try? await viewModel?.fetchTextList()
        }
        
        viewModel?.reloadData = {
//            DispatchQueue.main.async {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
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
                let image = cropImage(screenshot: screenshot)
                UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
                completion(true)
                
            }
        }
    }
    
    func cropImage(screenshot: UIImage) -> UIImage {
        let scale = screenshot.scale
        let imgSize = screenshot.size
        let screenHeight = UIScreen.main.bounds.height
        let bound = self.view.bounds.height
        let navHeight = self.navigationController!.navigationBar.frame.height
        let bottomBarHeight = screenHeight - navHeight - bound
        let crop = CGRectMake(0, 200, //"start" at the upper-left corner
            (imgSize.width - 1) * scale, //include half the width of the whole screen
            (imgSize.height - bottomBarHeight - 300) * scale) //include the height of the navigationBar and the height of view

        if let cgImage = screenshot.cgImage,
           let imageInRect = cgImage.cropping(to: crop) {
            let image: UIImage = UIImage(cgImage: cgImage)
            return image
        }
        
        return UIImage()
    }
    
    func prepareForScreenshot() {
        userButton.isHidden = true
        self.tabBarController?.tabBar.alpha = 0
        watermarkImage.alpha = 1
    }
    
    
    func handleAfterScreenshotUI() {
        userButton.isHidden = false
        self.tabBarController?.tabBar.alpha = 1
        watermarkImage.alpha = 0
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
        cell.selectionStyle = .none
        cell.takeScreenshot = {
            self.prepareForScreenshot()
            cell.prepareForScreenshot()
            self.takeScreenshot { _ in
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
