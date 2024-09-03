//
//  UIViewControllerExtension.swift
//  paytracker
//
//  Created by Jude Song on 8/29/24.
//

import UIKit

extension UIViewController {
    func setupBackground() {
        view.backgroundColor = .systemBackground
    }
    
    func addSubviewWithConstraints(_ subview: UIView, top: NSLayoutYAxisAnchor? = nil, left: NSLayoutXAxisAnchor? = nil, bottom: NSLayoutYAxisAnchor? = nil, right: NSLayoutXAxisAnchor? = nil, paddingTop: CGFloat = 0, paddingLeft: CGFloat = 0, paddingBottom: CGFloat = 0, paddingRight: CGFloat = 0, width: CGFloat? = nil, height: CGFloat? = nil) {
        subview.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(subview)
        
        if let top = top {
            subview.topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true
        }
        if let left = left {
            subview.leftAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true
        }
        if let bottom = bottom {
            subview.bottomAnchor.constraint(equalTo: bottom, constant: -paddingBottom).isActive = true
        }
        if let right = right {
            subview.rightAnchor.constraint(equalTo: right, constant: -paddingRight).isActive = true
        }
        if let width = width {
            subview.widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        if let height = height {
            subview.heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }
}
