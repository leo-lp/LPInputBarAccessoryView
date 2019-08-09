//
//  LPRoomInputView.swift
//  LPInputBarAccessoryViewDemo
//
//  Created by pengli on 2019/8/7.
//  Copyright © 2019 pengli. All rights reserved.
//

import UIKit
import LPInputBarAccessoryView

class LPRoomInputView: LPInputView {
    let textField = UITextField(frame: .zero)
    
    override func setup() {
        let emoteButton = UIButton(type: .contactAdd)
        let moreButton = UIButton(type: .infoDark)
        
        textField.placeholder = "Say..."
        textField.resignFirstResponder()
        
        bar.setStackViewItems([textField, emoteButton, moreButton], for: .middle)

//        layer.borderColor = UIColor.red.cgColor
//        layer.borderWidth = 0.1
//        bar.layer.borderColor = UIColor.blue.cgColor
//        bar.layer.borderWidth = 1
        
        emoteButton.addTarget(self, action: #selector(emoteButtonClicked), for: .touchUpInside)
        moreButton.addTarget(self, action: #selector(moreButtonClicked), for: .touchUpInside)
        
        let emoteView = LPInputAccessory(tag: 0)
        let moreView = LPInputAccessory(tag: 1)
        emoteView.layer.borderColor = UIColor.blue.cgColor
        emoteView.layer.borderWidth = 10
        moreView.layer.borderColor = UIColor.red.cgColor
        moreView.layer.borderWidth = 10
        
        emoteView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        moreView.heightAnchor.constraint(equalToConstant: 250).isActive = true
//        moreView.frame.size.height = 250
        
        setAccessoryViews([emoteView, moreView])
    }
    
    @objc private func emoteButtonClicked() {
        showAccessory(tag: 0)
    }

    @objc private func moreButtonClicked() {
        showAccessory(tag: 1)
    }
}
