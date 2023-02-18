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
    
    enum Rows: Int {
        case image
        case meaning
    }
    
    var viewModel: MeaningViewModel?
    var dataFetched: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = MeaningViewModel()
        
        collectionView.register(UINib(nibName: "MeaningCollectionViewCell", bundle: nil),
                                forCellWithReuseIdentifier: "MeaningCollectionViewCell")

        collectionView.register(UINib(nibName: "ImageCollectionViewCell", bundle: nil),
                                forCellWithReuseIdentifier: "ImageCollectionViewCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        showFullScreenLoader()
        Task {
            _ = try? await handleViewModelCallbacks()
        }
        
        EventManager.shared.trackEvent(event: .landedOnMeaningScreen)
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
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        if let row = Rows(rawValue:  section) {
            switch row {
            case .image:
                return 1
            case .meaning:
                return viewModel?.meanings.count ?? 0
            }
        }
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let row = Rows(rawValue:  indexPath.section) {
            switch row {
            case .image:
                let cell: ImageCollectionViewCell = collectionView.dequeue(cellForItemAt: indexPath)
                cell.render(withImageName: "silence")
                return cell
            case .meaning:
                let cell: MeaningCollectionViewCell = collectionView.dequeue(cellForItemAt: indexPath)
                if let meanings = viewModel?.meanings, meanings.count > indexPath.item {
                    let meaning = meanings[indexPath.item]
                    cell.render(withImageUrl: meaning.image_url, withLabel: meaning.meaning)
                }
                return cell
            }
        }
        
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        if let row = Rows(rawValue:  indexPath.section) {
            switch row {
            case .image:
                return CGSize(width: UIScreen.main.bounds.width, height: 250)
            case .meaning:
                return CGSize(width: (UIScreen.main.bounds.width - 60) / 2,
                              height: 220)
            }
        }
        
        return CGSize(width: 0, height: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        if let row = Rows(rawValue:  section) {
            switch row {
            case .image:
                return UIEdgeInsets(top: 100, left: 0, bottom: 0, right: 0)
            case .meaning:
                return UIEdgeInsets(top: 10, left: 20, bottom: 0, right: 20)

            }
        }
        
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if dataFetched {
            if scrollView.contentOffset.y > 250 {
                hideTopHeader()
            } else {
                showTopHeader()
            }
        }
    }
}
