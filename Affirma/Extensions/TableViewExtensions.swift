//
//  TableViewExtensions.swift
//  Affirma
//
//  Created by Airblack on 15/01/23.
//

import Foundation
import UIKit

extension UITableView {
    func dequeue<T: UITableViewCell>(cellForRowAt indexPath: IndexPath) -> T {
        return dequeueReusableCell(withIdentifier: "\(T.self)", for: indexPath) as! T
    }
}
