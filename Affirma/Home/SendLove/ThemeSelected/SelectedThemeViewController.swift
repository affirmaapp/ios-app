//
//  SelectedThemeViewController.swift
//  Affirma
//
//  Created by Airblack on 21/01/23.
//

import Anchorage
import AnimatedCollectionViewLayout
import ContactsUI
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
    @IBOutlet weak var anotherOptionButton: UIButton!
    
    
    var viewModel: SelectedThemeViewModel?
    var themeData: ThemeData?
    let contactPicker = CNContactPickerViewController()
    var modelToShare: SelectedThemeModel?
    
    private var choicePopup: ChoicesOverPopup = Bundle.main
        .loadNibNamed("ChoicesOverPopup",
                      owner: self,
                      options: nil)?.first as! ChoicesOverPopup
    
    private var sendAffirmationPopup: SendAffirmationPopup = Bundle.main
        .loadNibNamed("SendAffirmationPopup",
                      owner: self,
                      options: nil)?.first as! SendAffirmationPopup
    
    
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
        
        sendAffirmationPopup.pickFromContactsPressed = {
            self.contactPicker.delegate = self
            self.contactPicker.displayedPropertyKeys =
            [CNContactGivenNameKey
             , CNContactPhoneNumbersKey]
            self.present(self.contactPicker, animated: true, completion: nil)
        }
        
        sendAffirmationPopup.sendPressed = { number in
            if let number = number {
                BranchLinkManager.shared.createLink(forModel: self.modelToShare) { link in
                    if let supportUrl = URL(string: "https://api.whatsapp.com/send/?phone=\(number)&text=\(link ?? "")") {
                        UIApplication.shared.open(supportUrl)
                        
                        self.sendAffirmationPopup.dismiss()
                    }
                }
            }
        }
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
        
        viewModel?.showChancesOverPopup = {
            self.addChoicePopup() 
        }
    }
    
    @IBAction func backPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func pickAnotherPressed(_ sender: Any) {
        
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
        
        viewModel?.addToGeneratedCards()
        
        anotherOptionButton
        .setTitle("Give me another option (\(viewModel?.generatedCards.count ?? 1)/3)",
                      for: .normal)
    }
    
    private func setUI() {
        themeImageView.render(withImage: themeData?.theme_symbol_image,
                              withVideo: nil,
                              withGif: nil)
        
        themeText.text = themeData?.theme_text?.uppercased()
    }
    
    func addChoicePopup() {
        self.choicePopup.alpha = 0
        self.view.addSubview(choicePopup)
        choicePopup.verticalAnchors == self.view.verticalAnchors
        choicePopup.horizontalAnchors == self.view.horizontalAnchors
        UIView.animate(withDuration: 0.5) {
            self.choicePopup.alpha = 1
        }
    }
    
    func addSendAffirmationPopup() {
        self.sendAffirmationPopup.alpha = 0
        self.view.addSubview(sendAffirmationPopup)
        sendAffirmationPopup.verticalAnchors == self.view.verticalAnchors
        sendAffirmationPopup.horizontalAnchors == self.view.horizontalAnchors
        UIView.animate(withDuration: 0.5) {
            self.sendAffirmationPopup.alpha = 1
        }
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
            
            cell.sharePressed = { model in
                self.modelToShare = model
                self.addSendAffirmationPopup()
            }
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

extension SelectedThemeViewController: CNContactPickerDelegate {
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact) {
        // You can fetch selected name and number in the following way

        // user name
        let userName:String = contact.givenName

        // user phone number
        let userPhoneNumbers:[CNLabeledValue<CNPhoneNumber>] = contact.phoneNumbers
        let firstPhoneNumber:CNPhoneNumber = userPhoneNumbers[0].value


        // user phone number string
        let primaryPhoneNumberStr:String = firstPhoneNumber.stringValue

        print(primaryPhoneNumberStr.filter("+0123456789.".contains))
        sendAffirmationPopup.render(withNumber: primaryPhoneNumberStr.filter("+0123456789.".contains))

    }
}
