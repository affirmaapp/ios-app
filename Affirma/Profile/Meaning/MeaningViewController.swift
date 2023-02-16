//
//  MeaningViewController.swift
//  Affirma
//
//  Created by Airblack on 31/01/23.
//

import Foundation
import UIKit

class MeaningViewControllerFactory: NSObject {
    class func produce() -> MeaningViewController {
        let meaningVC = MeaningViewController(nibName: "MeaningViewController",
                                              bundle: nil)
        return meaningVC
    }
}


class MeaningViewController: BaseViewController {
    
    @IBOutlet var gradientView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var headerHeight: NSLayoutConstraint!
    @IBOutlet weak var topHeader: UIView!
    @IBOutlet weak var topHeaderLabel: UILabel!
    
    var viewModel: MeaningViewModel?
    var dataFetched: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = MeaningViewModel()
        
        collectionView.register(UINib(nibName: "MeaningCollectionViewCell", bundle: nil),
                                forCellWithReuseIdentifier: "MeaningCollectionViewCell")
        
        collectionView.delegate = self
        collectionView.dataSource = self
        showFullScreenLoader()
        Task {
            _ = try? await handleViewModelCallbacks()
        }
    }
    
    func handleViewModelCallbacks() async {
        Task {
            _ = try? await viewModel?.fetchSymbolMeanings()
        }
        
        viewModel?.reloadData = {
            DispatchQueue.main.async {
                self.dataFetched = true
                self.hideFullScreenLoader()
                UIView.performWithoutAnimation {
                    self.collectionView.reloadData()
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
    
    @IBAction func backPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func hideTopHeader() {
        if headerHeight.constant == 450 {
            headerHeight.constant = 0
            self.topHeaderLabel.isHidden = true
            UIView.animate(withDuration: 1, delay: 0) {
                self.view.layoutIfNeeded()
            } completion: { _ in
                self.topHeader.isHidden = true
            }
        }
    }
    
    func showTopHeader() {
        if headerHeight.constant == 0 {
            headerHeight.constant = 450
            self.topHeader.isHidden = false
            UIView.animate(withDuration: 1, delay: 0) {
                self.view.layoutIfNeeded()
            } completion: { _ in
                self.topHeaderLabel.isHidden = false
            }
        }
    }
    
}


extension MeaningViewController: UICollectionViewDelegate,
                                       UICollectionViewDataSource,
                                       UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return viewModel?.meanings.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: MeaningCollectionViewCell = collectionView.dequeue(cellForItemAt: indexPath)
        if let meanings = viewModel?.meanings, meanings.count > indexPath.item {
            let meaning = meanings[indexPath.item]
            cell.render(withImageUrl: meaning.image_url, withLabel: meaning.meaning)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (UIScreen.main.bounds.width - 60) / 2,
                      height: 220)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 100, left: 20, bottom: 0, right: 20)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if dataFetched {
            if scrollView.contentOffset.y > 200 {
                hideTopHeader()
            } else {
                showTopHeader()
            }
        }
    }
}
