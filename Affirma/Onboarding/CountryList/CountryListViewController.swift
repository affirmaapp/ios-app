//
//  CountryListViewController.swift
//  Affirma
//
//  Created by Airblack on 15/01/23.
//

import Foundation
import UIKit

class CountryListViewControllerFactory: NSObject {
    class func produce(withList list: [String]? = nil, title: String?) -> CountryListViewController {
        
        let countryListVC = CountryListViewController(nibName: "CountryListViewController",
                                                  bundle: nil)
        countryListVC.list = list ?? []
        countryListVC.navtitle = title ?? ""
        return countryListVC
    }
}

class CountryListViewController: BaseViewController {
    @IBOutlet weak private var searchBar: UISearchBar!
    @IBOutlet weak private var tableView: UITableView!
    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet private var topView: UIView!
    
    var selectedItem: ((String?) -> Void)?
    var selectedCountry: ((CountryModel?) -> Void)?
    
    var sourceType: ListType = .country
    var navtitle: String = ""
    
    enum ListType: String {
        case custom
        case country
    }
    
    fileprivate var list: [String] = []
    // MARK: ViewModel
    private var viewModel: CountryListViewModel?

    // MARK: LifeCycle Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewModel()
        setUI()
        registerCells()
        setDelegates()
        
        self.topView.addGestureRecognizer(UITapGestureRecognizer(target: self,
                                                    action: #selector(dismissList)))
    }
    
    // MARK: Setting up ViewModel
    func setupViewModel() {
        // Add here the setup for the ViewModel
        viewModel = CountryListViewModel()

        viewModel?.reloadData = {
            self.tableView.reloadData()
        }
        
        if !(self.list.isEmpty) {
            self.sourceType = .custom
        }
        
        if sourceType == .country {
            viewModel?.fetchData()
        } else {
            viewModel?.list = list
            self.tableView.reloadData()
        }
       
    }
    
    // MARK: Actions
    @IBAction func closeButtonPressed(_ sender: Any) {
        dismissView()
    }
    
    @objc
    private func dismissList() {
        self.dismissView()
    }
}

// MARK: Helper Functions
extension CountryListViewController {
    private func setUI() {
        if #available(iOS 13.0, *) {
            searchBar.searchTextField.font = Font(.installed(.avenirLight), size: .standard(.header4)).instance
            searchBar.searchTextField.textColor = Colors.black_131415.value
        } else {
            // Fallback on earlier versions
            if let txfSearchField = searchBar.value(forKey: "_searchField") as? UITextField {
                txfSearchField.textColor = Colors.black_131415.value
                txfSearchField.font = Font(.installed(.avenirLight), size: .standard(.header4)).instance
            }
        }
        
        self.titleLabel.text = self.navtitle
    }
    
    private func registerCells() {
        tableView.register(UINib(nibName: "CountryListTableViewCell",
                                 bundle: nil), forCellReuseIdentifier: "CountryListTableViewCell")
    }
    
    private func setDelegates() {
        searchBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self 
    }
    
    private func getImage(withFlagCode flagCode: String?) -> String {
        if let flagCode = flagCode?.lowercased() {
            return "https://www.countryflags.io/\(flagCode)/flat/64.png"
        } else {
            return ""
        }
    }
    
    private func dismissView() {
        self.dismiss(animated: true, completion: nil)
    }
}

// MARK: TableVIew Delegate functions
extension CountryListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if sourceType == .country {
            if let isSearching = viewModel?.isSearching, isSearching == true {
                return viewModel?.filteredCountries?.count ?? 0
            } else {
                return viewModel?.countries?.count ?? 0
            }
        } else {
            if let isSearching = viewModel?.isSearching, isSearching == true {
                return viewModel?.filteredList?.count ?? 0
            } else {
                return viewModel?.list?.count ?? 0
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CountryListTableViewCell = tableView.dequeue(cellForRowAt: indexPath)
        if sourceType == .country {
            if let count = viewModel?.countries?.count, count > indexPath.row {
                if let isSearching = viewModel?.isSearching, isSearching == true {
                    cell.render(forCountry: viewModel?.filteredCountries?[indexPath.row])
                } else {
                    cell.render(forCountry: viewModel?.countries?[indexPath.row])
                }
            }
        } else {
            if let count = viewModel?.list?.count, count > indexPath.row {
                if let isSearching = viewModel?.isSearching, isSearching == true {
                    cell.render(withString: viewModel?.filteredList?[indexPath.row])
                } else {
                    cell.render(withString: viewModel?.list?[indexPath.row])
                }
            }
        }
        return cell
    }
        
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dismissView()
        if sourceType == .country {
            if let count = viewModel?.countries?.count, count > indexPath.row {
                if let isSearching = viewModel?.isSearching, isSearching == true {
                    self.selectedCountry?(viewModel?.filteredCountries?[indexPath.row])
                } else {
                    self.selectedCountry?(viewModel?.countries?[indexPath.row])
                }
            }
        } else {
            if let count = viewModel?.list?.count, count > indexPath.row {
                if let isSearching = viewModel?.isSearching, isSearching == true {
                    self.selectedItem?(viewModel?.filteredList?[indexPath.row])
                } else {
                    self.selectedItem?(viewModel?.list?[indexPath.row])
                }
            }
        }
    }
}

extension CountryListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if sourceType == .country {
            if searchText.hasPrefix("+") || searchText.isNumeric {
                viewModel?.filteredCountries = viewModel?.countries?.filter {
                    $0.phoneCode?.contains(searchText.replacingOccurrences(of: "+", with: "")) ?? false
                }
            } else {
                viewModel?.filteredCountries = viewModel?.countries?.filter {
                    $0.name?.localizedCaseInsensitiveContains(searchText) ?? false
                }
            }
        } else {
            if searchText.hasPrefix("+") || searchText.isNumeric {
                viewModel?.filteredList = viewModel?.list?.filter {
                    $0.contains(searchText.replacingOccurrences(of: "+", with: ""))
                }
            } else {
                viewModel?.filteredList = viewModel?.list?.filter {
                    $0.localizedCaseInsensitiveContains(searchText)
                }
            }
        }
        if searchText == "" {
            viewModel?.setIsSearching(to: false)
        } else {
            viewModel?.setIsSearching(to: true)
        }
        tableView.reloadData()
    }
}


