//
//  LPViewController.swift
//  LPInputBarAccessoryViewDemo
//
//  Created by pengli on 2019/8/7.
//  Copyright © 2019 pengli. All rights reserved.
//

import UIKit
import LPInputBarAccessoryView

class LPViewController: UIViewController {
    let inputBar = LPRoomInputView(isHiddenWhenResign: true)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(inputBar)
        
        inputBar.lp.constraints {
            $0.leading.trailing.bottom.equal(to: view)
        }
        
//        let lbl = UILabel()
//        lbl.text = "LPInputView"
//        view.addSubview(lbl)
//        lbl.layer.borderColor = UIColor.red.cgColor
//        lbl.layer.borderWidth = 1
//        lbl.lp.constraints {
//            $0.top.leading.trailing.equal(to: view).forEach({
//                print($0.constant, $0.firstAttribute.yl_des, $0.secondAttribute.yl_des, $0.firstItem, $0.secondItem)
//            })
//            $0.bottom.equal(to: inputBar.topAnchor)
//            $0.height.equal(to: inputBar)
//            print("++++++++++++++")
//        }
//
//        lbl.lp.constraints {
//            $0.top.leading.bottom.trailing.update(constant: 20)
//        }
//        print("===============")
//        view.constraints.forEach {
//            print($0.constant, $0.firstAttribute.yl_des, $0.secondAttribute.yl_des, $0.firstItem, $0.secondItem)
//        }
    }
    
    @IBAction func showButtonClicked(_ sender: UIButton) {
        inputBar.textField.becomeFirstResponder()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        if !inputBar.frame.contains(touch.location(in: view)) {
            inputBar.hide(animated: true)
        }
        
        
        //inputBar.textField.resignFirstResponder()
    }
}

extension NSLayoutConstraint.Attribute {
    var yl_des: String {
        switch self {
        case .top:
            return "top"
        case .left:
            return "left"
        case .right:
            return "right"
        case .bottom:
            return "bottom"
        case .leading:
            return "leading"
        case .trailing:
            return "trailing"
        case .width:
            return "width"
        case .height:
            return "height"
        case .centerX:
            return "centerX"
        case .centerY:
            return "centerY"
        case .lastBaseline:
            return "lastBaseline"
        case .firstBaseline:
            return "firstBaseline"
        case .leftMargin:
            return "leftMargin"
        case .rightMargin:
            return "rightMargin"
        case .topMargin:
            return "topMargin"
        case .bottomMargin:
            return "bottomMargin"
        case .leadingMargin:
            return "leadingMargin"
        case .trailingMargin:
            return "trailingMargin"
        case .centerXWithinMargins:
            return "centerXWithinMargins"
        case .centerYWithinMargins:
            return "centerYWithinMargins"
        case .notAnAttribute:
            return "notAnAttribute"
        @unknown default:
            return "unknown"
        }
    }
}
