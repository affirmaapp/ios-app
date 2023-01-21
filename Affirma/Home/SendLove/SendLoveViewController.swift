//
//  SendLoveViewController.swift
//  Affirma
//
//  Created by Airblack on 20/01/23.
//

import Foundation
import UIKit
import WatchLayout

class SendLoveViewController: BaseViewController {
    @IBOutlet var gradientView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var viewModel: SendLoveViewModel?
    
//    @IBAction func logoutClicked(_ sender: Any) {
//        Task {
//            _ = try? await SupabaseManager.shared.logout()
//            
//            DispatchQueue.main.async {
//                let loginVC = LoginViewControllerFactory.produce()
//                let appDelegate = self.view.window?.windowScene?.delegate as! SceneDelegate
//                let nav = UINavigationController(rootViewController: loginVC)
//                nav.isNavigationBarHidden = true
//                appDelegate.window?.rootViewController = nav
//            }
//        }
//    }
    
    let layout = WatchLayout()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = SendLoveViewModel()
        
        collectionView.register(UINib(nibName: "ImageCollectionView", bundle: nil),
                                forCellWithReuseIdentifier: "ImageCollectionView")
        
        collectionView.delegate = self
        collectionView.dataSource = self 
        Task {
            _ = try? await handleViewModelCallbacks()
        }
        
        
        layout.itemSize = 380
        layout.spacing = -150
        layout.minScale = 0.3
        layout.nextItemScale = 0.4

        collectionView.collectionViewLayout = layout
        
    }
    
    func handleViewModelCallbacks() async {
        Task {
            _ = try? await viewModel?.fetchThemes()
        }
        
        viewModel?.reloadData = {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                self.collectionView.reloadData()
                
                DispatchQueue.main.async {
                    self.collectionView.setContentOffset(self.layout
                        .centeredOffsetForItem(indexPath: IndexPath(item: 0, section: 0)),
                                                         animated: true)
                }
            }
        }
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        gradientView.applyGradient(withColours: [Colors.black_2E302F.value,
                                                 Colors.black_131415.value],
                                   gradientOrientation: .topLeftBottomRight)
        
    }
}


extension SendLoveViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.themes.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCollectionView", for: indexPath) as! ImageCollectionView
        cell.render(withImage: viewModel?.themes[indexPath.row].theme_text_image)
        return cell
    }
}
