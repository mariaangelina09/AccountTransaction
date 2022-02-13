//
//  UIExtension.swift
//  AccountTransaction
//
//  Created by Maria Angelina on 19/01/22.
//

import Foundation
import UIKit

// MARK: - UIView Extension(s)
protocol NibLoadableView: class {}
extension NibLoadableView where Self: UIView {
    static var nibName: String {
        return String(describing: self)
    }
}

protocol ReusableView: class {}
extension ReusableView where Self: UIView {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}

extension UIView {
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.frame = self.bounds
        mask.path = path.cgPath
        layer.mask = mask
    }
}

// MARK: - UIColor Extension(s)
extension UIColor {
    static let darkGreen = UIColor(red: 60/255, green: 120/255, blue: 60/255, alpha: 1)
    static let lightGreen = UIColor(red: 120/255, green: 252/255, blue: 120/255, alpha: 1)
    static let lightRed = UIColor(red: 252/255, green: 120/255, blue: 120/255, alpha: 1)
    static let lightGray = UIColor(red: 200/255, green: 200/255, blue: 200/255, alpha: 1)
}

// MARK: - UITableView Extension(s)
extension UITableView {
    func register<T: UITableViewCell>(_: T.Type) where T: ReusableView, T: NibLoadableView {
        let nib = UINib(nibName: T.nibName, bundle: nil)
        register(nib, forCellReuseIdentifier: T.reuseIdentifier)
    }
    
    func dequeueReusableCell<T: UITableViewCell>(forIndexPath indexPath: IndexPath) -> T where T: ReusableView {
        guard let cell = dequeueReusableCell(withIdentifier: T.reuseIdentifier, for: indexPath as IndexPath) as? T else {
            fatalError("could not dequeue cell with identifier: \(T.reuseIdentifier)")
        }
        return cell
    }
}
