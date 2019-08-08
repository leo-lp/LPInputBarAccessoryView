//
//  LPKeyboardManager.swift
//  LPInputBarAccessoryView
//
//  Created by pengli on 2019/8/7.
//  Copyright © 2019 pengli. All rights reserved.
//

import UIKit

public enum LPKeyboardEvent {
    case willShow        // .UIKeyboardWillShow
    case didShow         // .UIKeyboardDidShow
    case willHide        // .UIKeyboardWillShow
    case didHide         // .UIKeyboardDidHide
    case willChangeFrame // .UIKeyboardWillChangeFrame
}

public struct LPKeyboardNotification {
    let event: LPKeyboardEvent // 触发转换的事件
    let timeInterval: TimeInterval // 键盘过渡的动画时长
    let animationOptions: UIView.AnimationOptions // 键盘转换的动画属性
    var startFrame: CGRect // 键盘在过渡开始时的frame
    var endFrame: CGRect // 键盘在过渡结束时的frame
    var isHidden: Bool { return startFrame.minY < endFrame.minY } // 键盘是否隐藏
    
    init?(from notification: Notification) {
        guard let event = notification.lp_event else { return nil }
        self.event = event
        self.timeInterval = notification.lp_timeInterval ?? 0.25
        self.animationOptions = notification.lp_animationOptions
        self.startFrame = notification.lp_startFrame ?? .zero
        self.endFrame = notification.lp_endFrame ?? .zero
    }
}

public class LPKeyboardManager {
    public private(set) static var isKeyboardHidden: Bool = true
    
    public typealias LPEventCallback = (LPKeyboardNotification) -> Void
    private var callbacks: [LPKeyboardEvent: LPEventCallback] = [:]
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        #if DEBUG
        print("\(self) release memory.")
        #endif
    }
    
    public init() {
        let center = NotificationCenter.default
        center.addObserver(self,
                           selector: #selector(keyboardWillShow),
                           name: UIResponder.keyboardWillShowNotification,
                           object: nil)
        center.addObserver(self,
                           selector: #selector(keyboardDidShow),
                           name: UIResponder.keyboardDidShowNotification,
                           object: nil)
        center.addObserver(self,
                           selector: #selector(keyboardWillHide),
                           name: UIResponder.keyboardWillHideNotification,
                           object: nil)
        center.addObserver(self,
                           selector: #selector(keyboardDidHide),
                           name: UIResponder.keyboardDidHideNotification,
                           object: nil)
        center.addObserver(self,
                           selector: #selector(keyboardWillChangeFrame),
                           name: UIResponder.keyboardWillChangeFrameNotification,
                           object: nil)
    }
    
    @discardableResult
    public func on(event: LPKeyboardEvent, do callback: LPEventCallback?) -> Self {
        callbacks[event] = callback
        return self
    }
    
    // MARK: - Keyboard Notifications
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        LPKeyboardManager.isKeyboardHidden = false
        guard let kbNotification = LPKeyboardNotification(from: notification) else { return }
        callbacks[.willShow]?(kbNotification)
    }
    
    @objc private func keyboardDidShow(_ notification: Notification) {
        LPKeyboardManager.isKeyboardHidden = false
        guard let kbNotification = LPKeyboardNotification(from: notification) else { return }
        callbacks[.didShow]?(kbNotification)
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        LPKeyboardManager.isKeyboardHidden = true
        guard let kbNotification = LPKeyboardNotification(from: notification) else { return }
        callbacks[.willHide]?(kbNotification)
    }
    
    @objc private func keyboardDidHide(_ notification: Notification) {
        LPKeyboardManager.isKeyboardHidden = true
        guard let kbNotification = LPKeyboardNotification(from: notification) else { return }
        callbacks[.didHide]?(kbNotification)
    }
    
    @objc private func keyboardWillChangeFrame(_ notification: Notification) {
        guard let kbNotification = LPKeyboardNotification(from: notification) else { return }
        LPKeyboardManager.isKeyboardHidden = kbNotification.isHidden
        callbacks[.willChangeFrame]?(kbNotification)
    }
}

fileprivate extension Notification {
    var lp_event: LPKeyboardEvent? {
        switch name {
        case UIResponder.keyboardWillShowNotification:        return .willShow
        case UIResponder.keyboardDidShowNotification:         return .didShow
        case UIResponder.keyboardWillHideNotification:        return .willHide
        case UIResponder.keyboardDidHideNotification:         return .didHide
        case UIResponder.keyboardWillChangeFrameNotification: return .willChangeFrame
        default: return nil
        }
    }
    var lp_timeInterval: TimeInterval? {
        guard let value = userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber else { return nil }
        return TimeInterval(truncating: value)
    }
    var lp_animationCurve: UIView.AnimationCurve? {
        guard let index = (userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber)?.intValue else { return nil }
        guard index >= 0 && index <= 3 else { return .linear }
        return UIView.AnimationCurve(rawValue: index) ?? .linear
    }
    var lp_animationOptions: UIView.AnimationOptions {
        guard let curve = lp_animationCurve else { return [] }
        switch curve {
        case .easeIn:     return .curveEaseIn
        case .easeOut:    return .curveEaseOut
        case .easeInOut:  return .curveEaseInOut
        case .linear:     return .curveLinear
        @unknown default: return .curveLinear
        }
    }
    var lp_startFrame: CGRect? {
        return (userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue
    }
    var lp_endFrame: CGRect? {
        return (userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
    }
}
