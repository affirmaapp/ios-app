//
//  SelectedThemeViewController.swift
//  Affirma
//
//  Created by Airblack on 21/01/23.
//

import AnimatedCollectionViewLayout
import Foundation
import UIKit

class SelectedThemeViewControllerFactory: NSObject {
    class func produce(withThemeData themeData: ThemeData?) -> SelectedThemeViewController {
        let selectedThemeVC = SelectedThemeViewController(nibName: "SelectedThemeViewController",
                                                bundle: nil)
        selectedThemeVC.themeData = themeData
        return selectedThemeVC
    }
}
class SelectedThemeViewController: BaseViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var themeImageView: GenericMediaView!
    @IBOutlet weak var themeText: UILabel!
    @IBOutlet var gradientView: UIView!
    
    var viewModel: SelectedThemeViewModel?
    var themeData: ThemeData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = SelectedThemeViewModel()
        viewModel?.selectedTheme = self.themeData?.theme_text
        Task {
            _ = try? await handleViewModelCallbacks()
        }
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let layout = AnimatedCollectionViewLayout()
        layout.scrollDirection = .horizontal
        layout.animator = LinearCardAttributesAnimator(minAlpha: 0.5, itemSpacing: 0.1, scaleRate: 0.95)
       
        collectionView.collectionViewLayout = layout
        registerCells()
        setUI()
    }
    
    func registerCells() {
        collectionView.register(UINib(nibName: "AffirmationCardCollectionViewCell", bundle: nil),
                                forCellWithReuseIdentifier: "AffirmationCardCollectionViewCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        gradientView.applyGradient(withColours: [Colors.black_2E302F.value,
                                                 Colors.black_131415.value],
                                   gradientOrientation: .topLeftBottomRight)
        
    }
    
    func handleViewModelCallbacks() async {
        Task {
            _ = try? await viewModel?.fetchCards()
        }
        
        viewModel?.reloadData = {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
        
        viewModel?.scrollToItem = { count in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                self.collectionView.scrollToItem(at: IndexPath(item: count, section: 0),
                                                 at: .centeredHorizontally, animated: true)
            }
        }
    }
    
    @IBAction func pickAnotherPressed(_ sender: Any) {
        viewModel?.addToGeneratedCards()
    }
    
    private func setUI() {
        themeImageView.render(withImage: themeData?.theme_symbol_image,
                              withVideo: nil,
                              withGif: nil)
        
        themeText.text = themeData?.theme_text?.uppercased()
    }
}


extension SelectedThemeViewController: UICollectionViewDelegate,
                                       UICollectionViewDataSource,
                                       UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return viewModel?.generatedCards.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: AffirmationCardCollectionViewCell = collectionView.dequeue(cellForItemAt: indexPath)
        if let cards = viewModel?.generatedCards, cards.count > indexPath.item {
            let card = cards[indexPath.item]
            
            cell.render(withModel: card)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width * 0.85,
                      height: UIScreen.main.bounds.height * 0.65)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 25, bottom: 0, right: 25)
    }
}
