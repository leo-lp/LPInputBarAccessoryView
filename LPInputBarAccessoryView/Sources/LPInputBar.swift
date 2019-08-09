//
//  LPInputBar.swift
//  LPInputBarAccessoryView
//
//  Created by pengli on 2019/8/7.
//  Copyright © 2019 pengli. All rights reserved.
//

import UIKit

public struct LPLayoutSet {
    public let constraints: [NSLayoutConstraint]
    public func update(for attr: NSLayoutConstraint.Attribute, constant: CGFloat) {
        if let index = constraints.firstIndex(where: { $0.firstAttribute == attr }) {
            constraints[index].constant = constant
        } else {
            assert(false, "constraint(\(attr.rawValue)) not found.")
        }
    }
}
public class LPInputBar: UIView {
    public let topStackView = LPInputStackView(axis: .horizontal, spacing: 6)
    public let middleStackView = LPInputStackView(axis: .horizontal, spacing: 6)
    public let bottomStackView = LPInputStackView(axis: .horizontal, spacing: 6)
    public private(set) var topStackViewLayout: LPLayoutSet?
    public private(set) var middleStackViewLayout: LPLayoutSet?
    public private(set) var bottomStackViewLayout: LPLayoutSet?
    
    // MARK: - init / deinit
    
    deinit {
        #if DEBUG
        print("\(self) release memory.")
        #endif
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(topStackView)
        addSubview(middleStackView)
        addSubview(bottomStackView)
        topStackView.lp.constraints {
            topStackViewLayout = LPLayoutSet(constraints: $0.top.leading.trailing.equal(to: self, constant: 6))
        }
        middleStackView.lp.constraints {
            var constraints = $0.top.equal(to: topStackView.lp.bottom)
            constraints.append(contentsOf: $0.leading.trailing.equal(to: self, constant: 6))
            middleStackViewLayout = LPLayoutSet(constraints: constraints)
        }
        bottomStackView.lp.constraints {
            var constraints = $0.top.equal(to: middleStackView.lp.bottom)
            constraints.append(contentsOf: $0.leading.trailing.equal(to: self, constant: 6))
            constraints.append(contentsOf: $0.bottom.equal(to: self.lp.bottomSafe, constant: 6))
            bottomStackViewLayout = LPLayoutSet(constraints: constraints)
        }
    }
    
    public func setStackViewItems(_ items: [UIView], for position: LPInputStackView.Position) {
        func setItems(for stackView: UIStackView) {
            stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
            items.forEach { stackView.addArrangedSubview($0) }
        }
        switch position {
        case .top: setItems(for: topStackView)
        case .middle: setItems(for: middleStackView)
        case .bottom: setItems(for: bottomStackView)
        }
    }
}
