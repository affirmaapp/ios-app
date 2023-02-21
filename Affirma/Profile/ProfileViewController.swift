//
//  ProfileViewController.swift
//  Affirma
//
//  Created by Airblack on 31/01/23.
//

import Foundation
import UIKit

class ProfileViewControllerFactory: NSObject {
    class func produce() -> ProfileViewController {
        let profileVC = ProfileViewController(nibName: "ProfileViewController",
                                              bundle: nil)
        return profileVC
    }
}

class ProfileViewController: BaseViewController {
    
    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    enum Rows: Int {
        case meaning
        case settings
        case logout
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerCells()
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.reloadData()
        EventManager.shared.trackEvent(event: .landedOnProfileScreen)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        gradientView.applyGradient(withColours: [Colors.black_2E302F.value,
                                                 Colors.black_131415.value],
                                   gradientOrientation: .topLeftBottomRight)
        
    }
    
    private func registerCells() {
        tableView.register(UINib(nibName: "ProfileItemTableViewCell",
                                 bundle: nil),
                           forCellReuseIdentifier: "ProfileItemTableViewCell")
    }
    
    func askForLogout() {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Do you want to logout?",
                                          message: "",
                                          preferredStyle: .alert)
            
            // add the actions (buttons)
            alert.addAction(UIAlertAction(title: "Yes", style: UIAlertAction.Style.default) { _ in
                self.logout()
            })
            
            alert.addAction(UIAlertAction(title: "No", style: UIAlertAction.Style.default) { _ in
                print("dismiss")
            })
            
            // show the alert
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func askForDelete() {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Do you want to delete?",
                                          message: "You're about to delete your account - that means no more daily affirmations and motivational messages. Is that really what you want?",
                                          preferredStyle: .alert)
            
            // add the actions (buttons)
            alert.addAction(UIAlertAction(title: "Yes", style: UIAlertAction.Style.default) { _ in
                self.delete()
            })
            
            alert.addAction(UIAlertAction(title: "No", style: UIAlertAction.Style.default) { _ in
                print("dismiss")
            })
            
            // show the alert
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func logout() {
        Task {
            _ = try? await SupabaseManager.shared.logout()
            AffirmaStateManager.shared.logout()
            DispatchQueue.main.async {
                EventManager.shared.trackEvent(event: .logoutConfirmed)
                let loginVC = LoginViewControllerFactory.produce()
                let appDelegate = self.view.window?.windowScene?.delegate as! SceneDelegate
                let nav = UINavigationController(rootViewController: loginVC)
                nav.isNavigationBarHidden = true
                appDelegate.window?.rootViewController = nav
            }
        }
    }
    
    func delete() {
        Task {
            _ = try? await SupabaseManager.shared.deleteUser(completion: { _ in
                AffirmaStateManager.shared.logout()
                DispatchQueue.main.async {
                    EventManager.shared.trackEvent(event: .logoutConfirmed)
                    let loginVC = LoginViewControllerFactory.produce()
                    let appDelegate = self.view.window?.windowScene?.delegate as! SceneDelegate
                    let nav = UINavigationController(rootViewController: loginVC)
                    nav.isNavigationBarHidden = true
                    appDelegate.window?.rootViewController = nav
                }
            })
        }
    }
    
    @IBAction func backPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 3
        } else {
            return 1
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            var titleString: String?
            var iconName: UIImage?
            if let row = Rows(rawValue:  indexPath.row) {
                switch row {
                case .meaning:
                    titleString = "Meaning"
                    iconName = UIImage(named: "meaning")
                case .settings:
                    titleString = "Settings"
                    iconName = UIImage(named: "setting")
//                case .shareApp:
//                    titleString = "Share App"
//                    iconName = UIImage(named: "upload")
                case .logout:
                    iconName = UIImage(named: "logout")
                    titleString = "Logout"
                }
            }
            
            let cell: ProfileItemTableViewCell = tableView.dequeue(cellForRowAt: indexPath)
            cell.render(withTitle: titleString, witIcon: iconName ?? UIImage())
            cell.selectionStyle = .none
            return cell
        } else {
            
            let cell: ProfileItemTableViewCell = tableView.dequeue(cellForRowAt: indexPath)
            cell.render(withTitle: "Delete Account", witIcon:  UIImage(named: "delete") ?? UIImage())
            cell.selectionStyle = .none
            return cell
        }

        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            if let row = Rows(rawValue:  indexPath.row) {
                switch row {
                case .meaning:
                    print("")
                    let meaningVC = MeaningViewControllerFactory.produce()
                    self.navigationController?.pushViewController(meaningVC, animated: true)
                case .settings:
                    print("")
                    let settingsVC = SettingsViewControllerFactory.produce()
                    self.navigationController?.pushViewController(settingsVC, animated: true)
//                case .shareApp:
//                    print("")
//                    // TODO: replace app id and add a message
//                    if let name = URL(string: "https://itunes.apple.com/us/app/id1673126845?ls=1&mt=8"), !name.absoluteString.isEmpty {
//                      let objectsToShare = [name]
//                      let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
//                      self.present(activityVC, animated: true, completion: nil)
//                    } else {
//                      // show alert for not available
//                    }
//                    EventManager.shared.trackEvent(event: .sharePressed)
                case .logout:
                    self.askForLogout()
                    EventManager.shared.trackEvent(event: .logoutPressed)
                }
            }
        } else {
            self.askForDelete()
            EventManager.shared.trackEvent(event: .deleteTapped)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 1 {
            return 40
        } else {
            return 0
        }
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 1 {
            return UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 40))
        } else {
            return UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 0))
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 60
        } else {
            return 60
        }
    }
    
}
