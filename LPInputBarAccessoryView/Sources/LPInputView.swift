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
    private var barBottomConstraint: NSLayoutConstraint?
    private var isHiddenWhenResign: Bool
    public var isShowing: Bool { return barBottomConstraint?.constant != 0.0 }
    public let bar = UIView()
    public private(set) var barLayoutSet: LPLayoutSet?
    public private(set) var accesoryContainer: UIView?
    
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
            barLayoutSet = LPLayoutSet(constraints: $0.top.leading.trailing.equal(to: self))
            barBottomConstraint = $0.bottom.lessOrEqual(to: self.lp.bottom).first
        }
        setup()
        if isHiddenWhenResign {
            alpha = 0.3
            isHidden = true
        }
        
        keyboard.on(event: .willChangeFrame) { [weak self](notification) in
            self?.keyboardFrameWillChange(notification)
        }
    }
    
    open func setup() {
        assert(false, "override this function.")
    }
    
    public func setAccessoryViews(_ views: [LPInputAccessory]) {
        var container: UIView {
            if let container = accesoryContainer { return container }
            let container = UIView()
            addSubview(container)
            container.lp.constraints {
                $0.top.equal(to: bar.bottomAnchor)
                $0.leading.trailing.bottom.equal(to: self)
            }
            accesoryContainer = container
            return container
        }
        accessoryViews = views.map {
            container.addSubview($0)
            var bottom: NSLayoutConstraint?
            var height: CGFloat = $0.frame.height
            if let index = $0.constraints.firstIndex(where: { $0.firstAttribute == .height }) {
                height = $0.constraints[index].constant
            } else {
                $0.lp.constraints({ $0.height.equal(toConstant: height) })
            }
            if #available(iOS 11.0, *) { height += 40 }
            $0.lp.constraints({
                $0.top.greaterOrEqual(to: container.topAnchor)
                bottom = $0.bottom.equal(to: container.lp.bottomSafe, constant: -height).first
                $0.leading.trailing.equal(to: container)
            })
            guard let bottomConstraint = bottom else { fatalError("bottom constraint can't is nil.") }
            return ($0, bottomConstraint, height)
        }
    }
    
    open func showAccessory(tag: Int) {
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
    open func hide(animated: Bool) {
        if animated {
            linearAnimate({
                if !LPKeyboardManager.isKeyboardHidden { self.endEditing(true) }
                self.accessoryViews?.forEach({ $0.bottom.constant = $0.height })
                self.superview?.layoutIfNeeded()
                if self.isHiddenWhenResign { self.alpha = 0.3 }
            }, completion: { [weak self] in
                guard let `self` = self else { return }
                if self.isHiddenWhenResign { self.isHidden = true }
            })
        } else {
            if !LPKeyboardManager.isKeyboardHidden { endEditing(true) }
            accessoryViews?.forEach { $0.bottom.constant = $0.height }
            if self.isHiddenWhenResign {
                self.alpha = 0.3
                self.isHidden = true
            }
        }
    }
    
    open func keyboardFrameWillChange(_ notification: LPKeyboardNotification) {
        if !notification.isHidden && isHiddenWhenResign {
            alpha = 1
            isHidden = false
        } else if isHiddenWhenResign {
            alpha = 0.3
            isHidden = true
        }
        linearAnimate({
            if notification.isHidden {
                self.barBottomConstraint?.constant = 0
            } else {
                self.barBottomConstraint?.constant = -notification.endFrame.height
                self.accessoryViews?.forEach { $0.bottom.constant = $0.height }
            }
            self.superview?.layoutIfNeeded()
        }, duration: notification.timeInterval, options: notification.animationOptions)
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
