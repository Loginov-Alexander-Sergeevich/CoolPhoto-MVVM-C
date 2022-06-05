//
//  Extension + UIView.swift
//  CoolPhotos
//
//  Created by Александр Александров on 26.05.2022.
//

import Foundation
import UIKit

extension UIView {
    
    func addSubviews(_ items: [UIView]) {
        for item in items {
            addSubview(item)
        }
    }
}
