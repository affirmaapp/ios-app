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
        case shareApp
        case logout
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerCells()
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.reloadData()
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
    
    func logout() {
        Task {
            _ = try? await SupabaseManager.shared.logout()
            AffirmaStateManager.shared.logout()
            DispatchQueue.main.async {
                let loginVC = LoginViewControllerFactory.produce()
                let appDelegate = self.view.window?.windowScene?.delegate as! SceneDelegate
                let nav = UINavigationController(rootViewController: loginVC)
                nav.isNavigationBarHidden = true
                appDelegate.window?.rootViewController = nav
            }
        }
    }
    
    @IBAction func backPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
            case .shareApp:
                titleString = "Share App"
                iconName = UIImage(named: "upload")
            case .logout:
                iconName = UIImage(named: "logout")
                titleString = "Logout"
            }
        }
        
        let cell: ProfileItemTableViewCell = tableView.dequeue(cellForRowAt: indexPath)
        cell.render(withTitle: titleString, witIcon: iconName ?? UIImage())
        cell.selectionStyle = .none
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
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
            case .shareApp:
                print("")
                // TODO: replace app id and add a message
                if let name = URL(string: "https://itunes.apple.com/us/app/myapp/idxxxxxxxx?ls=1&mt=8"), !name.absoluteString.isEmpty {
                  let objectsToShare = [name]
                  let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
                  self.present(activityVC, animated: true, completion: nil)
                } else {
                  // show alert for not available
                }
            case .logout:
                self.askForLogout()
                
            }
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
}
