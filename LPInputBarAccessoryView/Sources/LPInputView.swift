//
//  LPInputView.swift
//  LPInputBarAccessoryView
//
//  Created by pengli on 2019/8/7.
//  Copyright © 2019 pengli. All rights reserved.
//

import UIKit

open class LPInputView: UIView {
    private var accessoryViews: [(view: LPInputAccessory, bottom: NSLayoutConstraint, height: CGFloat)]?
    private let keyboard = LPKeyboardManager()
    public let bar = LPInputBar()
    private var barBottomConstraint: NSLayoutConstraint?
    private var isHiddenWhenResign: Bool = true
    public var isShowing: Bool { return barBottomConstraint?.constant != 0.0 }
    
    // MARK: - init / deinit
    
    deinit {
        #if DEBUG
        print("\(self) release memory.")
        #endif
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public init(isHiddenWhenResign: Bool) {
        self.isHiddenWhenResign = isHiddenWhenResign
        super.init(frame: .zero)
        addSubview(bar)
        backgroundColor = UIColor.white
        bar.lp.constraints {
            $0.top.leading.trailing.equal(to: self)
            barBottomConstraint = $0.bottom.lessOrEqual(to: self.lp.bottom).first
        }
        
        keyboard.on(event: .willChangeFrame) { [weak self](notification) in
            guard let `self` = self else { return }
            if !notification.isHidden && self.isHiddenWhenResign {
                self.alpha = 1
                self.isHidden = false
            } else if self.isHiddenWhenResign {
                self.alpha = 0
                self.isHidden = true
            }
            self.linearAnimate({
                if notification.isHidden {
                    self.barBottomConstraint?.constant = 0
                } else {
                    self.barBottomConstraint?.constant = -notification.endFrame.height
                    self.accessoryViews?.forEach { $0.bottom.constant = $0.height }
                }
                self.superview?.layoutIfNeeded()
            }, duration: notification.timeInterval, options: notification.animationOptions)
        }
        setup()
        if isHiddenWhenResign {
            alpha = 0
            isHidden = true
        }
    }
    
    open func setup() {
        assert(false, "override this function.")
    }
    
    public func setAccessoryViews(_ views: [LPInputAccessory]) {
        accessoryViews = views.map {
            addSubview($0)
            var bottom: NSLayoutConstraint?
            var hight: CGFloat = $0.frame.height
            $0.constraints.forEach({ if $0.firstAttribute == .height { return hight = $0.constant } })
            $0.lp.constraints({
                $0.top.greaterOrEqual(to: bar.lp.bottom)
                bottom = $0.bottom.equal(to: self, constant: -hight).first
                $0.leading.trailing.equal(to: self)
            })
            guard let bottomConstraint = bottom else { fatalError("bottom constraint can't is nil.") }
            return ($0, bottomConstraint, hight)
        }
    }
    
    public func showAccessory(tag: Int) {
        if isHiddenWhenResign { isHidden = false }
        linearAnimate({
            if !LPKeyboardManager.isKeyboardHidden { self.endEditing(true) }
            self.accessoryViews?.forEach { $0.bottom.constant = $0.view.tag == tag ? 0 : $0.height }
            self.superview?.layoutIfNeeded()
            if self.isHiddenWhenResign {
                self.isHidden = false
                self.alpha = 1
            }
        })
    }
    
    /// 隐藏键盘/MoreView
    public func hide(animated: Bool) {
        if animated {
            linearAnimate({
                if !LPKeyboardManager.isKeyboardHidden { self.endEditing(true) }
                self.accessoryViews?.forEach({ $0.bottom.constant = $0.height })
                self.superview?.layoutIfNeeded()
                if self.isHiddenWhenResign { self.alpha = 0 }
            }, completion: { [weak self] in
                guard let `self` = self else { return }
                if self.isHiddenWhenResign { self.isHidden = true }
            })
        } else {
            if !LPKeyboardManager.isKeyboardHidden { endEditing(true) }
            accessoryViews?.forEach { $0.bottom.constant = $0.height }
            if self.isHiddenWhenResign {
                self.alpha = 0
                self.isHidden = true
            }
        }
    }
    
    private func linearAnimate(_ animations: @escaping () -> Void,
                               duration: TimeInterval = 0.25,
                               options: UIView.AnimationOptions = .curveLinear,
                               completion: (() -> Void)? = nil) {
        UIView.animate(withDuration: duration,
                       delay: 0,
                       options: [options, .allowAnimatedContent, .beginFromCurrentState],
                       animations: animations,
                       completion: { (_) in completion?() })
    }
}
