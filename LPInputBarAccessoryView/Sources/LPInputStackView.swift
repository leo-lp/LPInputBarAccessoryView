//
//  LPInputStackView.swift
//  LPInputBarAccessoryView
//
//  Created by pengli on 2019/8/7.
//  Copyright © 2019 pengli. All rights reserved.
//

import UIKit

public class LPInputStackView: UIStackView {
    public enum Position {
        case top, middle, bottom
    }
    
    public convenience init(axis: NSLayoutConstraint.Axis, spacing: CGFloat) {
        self.init(frame: .zero)
        self.axis = axis
        self.spacing = spacing
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        distribution = .fill
        alignment = .fill
        backgroundColor = UIColor.clear
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
    }
}
