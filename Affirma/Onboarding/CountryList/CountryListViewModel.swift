//
//  
//  CountryListViewModel.swift
//  Airblack
//
//  Created by Vidushi Jaiswal on 04/03/21.
//
//
import Foundation
import ObjectMapper

class CountryListViewModel: BaseViewModel {
    
    // MARK: Properties
    var countries: [CountryModel]? = []
    var filteredCountries: [CountryModel]? = []
    
    var list: [String]? = []
    var filteredList: [String]? = []
    var isSearching: Bool? = false
    var reloadData: (() -> Void)?
    // MARK: Init
    
    override init() {
        super.init()
    }
    
    func fetchData() {
        let url = Bundle.main.url(forResource: "countries", withExtension: "json")
        if let url = url {
            let data = try? Data(contentsOf: url)
            if let data = data {
                let JSON = try? JSONSerialization.jsonObject(with: data, options: [])
                if let json = JSON as? [Any] {
                    for jsonItem in json {
                        if let countryData = jsonItem as? [String: Any] {
                            let countryModel: CountryModel? = Mapper<CountryModel>().map(JSON: countryData)
                            if let countryModel = countryModel {
                                countries?.append(countryModel)
                            }
                        }
                    }
                }
            }
        }
        self.reloadData?()
    }
    
    func setIsSearching(to value: Bool?) {
        self.isSearching = value
    }
}
