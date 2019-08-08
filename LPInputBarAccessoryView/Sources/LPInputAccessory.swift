//
//  LPInputAccessory.swift
//  LPInputBarAccessoryView
//
//  Created by pengli on 2019/8/7.
//  Copyright © 2019 pengli. All rights reserved.
//

import UIKit

public class LPInputAccessory: UIView {
    deinit {
        #if DEBUG
        print("\(self) release memory.")
        #endif
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public init(tag: Int) {
        super.init(frame: .zero)
        self.tag = tag
    }
}
//{
//    private let topStackView = LPInputStackView(axis: .horizontal, spacing: 6)
//    private let middleStackView = LPInputStackView(axis: .horizontal, spacing: 6)
//    private let bottomStackView = LPInputStackView(axis: .horizontal, spacing: 6)
//
//    // MARK: - init / deinit
//
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        commonInit()
//    }
//
//    required public init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//        commonInit()
//    }
//
//    private func commonInit() {
//        addSubview(topStackView)
//        addSubview(middleStackView)
//        addSubview(bottomStackView)
//        topStackView.lp.constraints {
//            $0.top.leading.trailing.equal(to: self)
//        }
//        middleStackView.lp.constraints {
//            $0.top.equal(to: topStackView.lp.bottom)
//            $0.leading.trailing.equal(to: self)
//        }
//        bottomStackView.lp.constraints {
//            $0.top.equal(to: middleStackView.lp.bottom)
//            $0.leading.trailing.bottom.equal(to: self)
//        }
//    }
//
//    func setStackViewItems(_ items: [UIView], for position: LPInputStackView.Position) {
//        func setItems(for stackView: UIStackView) {
//            stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
//            items.forEach { stackView.addArrangedSubview($0) }
//            guard superview != nil else { return }
//            stackView.layoutIfNeeded()
//        }
//        switch position {
//        case .top: setItems(for: topStackView)
//        case .middle: setItems(for: middleStackView)
//        case .bottom: setItems(for: bottomStackView)
//        }
//    }
//}
