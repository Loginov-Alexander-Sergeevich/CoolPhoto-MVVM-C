//
//  Extension + UIStackView.swift
//  CoolPhotos
//
//  Created by Александр Александров on 26.05.2022.
//

import Foundation
import UIKit

extension UIStackView {
    
    func addArrangedSubviews(_ items: [UIView]) {
        
        for item in items {
            addArrangedSubview(item)
        }
    }
}
