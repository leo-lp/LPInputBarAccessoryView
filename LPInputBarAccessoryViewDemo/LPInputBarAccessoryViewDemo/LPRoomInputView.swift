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
        
        //bar.setStackViewItems([textField, emoteButton, moreButton], for: .middle)
        
//        bar.middleStackViewLayout?.update(for: .top, constant: 4)
//        bar.middleStackViewLayout?.update(for: .leading, constant: 8)
//        bar.middleStackViewLayout?.update(for: .trailing, constant: -8)

//        layer.borderColor = UIColor.red.cgColor
//        layer.borderWidth = 0.5
        bar.layer.borderColor = UIColor.orange.cgColor
        bar.layer.borderWidth = 1
        
        emoteButton.layer.borderColor = UIColor.blue.cgColor
        emoteButton.layer.borderWidth = 1
        
        textField.layer.borderColor = UIColor.blue.cgColor
        textField.layer.borderWidth = 1
        
        moreButton.layer.borderColor = UIColor.blue.cgColor
        moreButton.layer.borderWidth = 1
        
        bar.addSubview(emoteButton)
        bar.addSubview(textField)
        bar.addSubview(moreButton)
        emoteButton.lp.constraints {
            $0.width.height.equal(toConstant: 50)
            $0.leading.equal(to: bar)
            $0.centerY.equal(to: textField)
        }
        textField.lp.constraints {
            $0.top.equal(to: bar, constant: 8)
            $0.bottom.equal(to: bar.lp.bottomSafe, constant: 8)
            $0.leading.equal(to: emoteButton.trailingAnchor)
            $0.trailing.equal(to: moreButton.leadingAnchor)
        }
        moreButton.lp.constraints {
            $0.width.height.equal(toConstant: 50)
            $0.trailing.equal(to: bar)
            $0.centerY.equal(to: textField)
        }
        
        emoteButton.addTarget(self, action: #selector(emoteButtonClicked), for: .touchUpInside)
        moreButton.addTarget(self, action: #selector(moreButtonClicked), for: .touchUpInside)
        
        let emoteView = LPInputAccessory(tag: 0)
        let moreView = LPInputAccessory(tag: 1)
        emoteView.layer.borderColor = UIColor.blue.cgColor
        emoteView.layer.borderWidth = 10
        moreView.layer.borderColor = UIColor.red.cgColor
        moreView.layer.borderWidth = 10
        
        emoteView.heightAnchor.constraint(equalToConstant: 200).isActive = true
//        moreView.heightAnchor.constraint(equalToConstant: 250).isActive = true
        moreView.frame.size.height = 250
        
        setAccessoryViews([emoteView, moreView])
    }
    
    @objc private func emoteButtonClicked() {
        showAccessory(tag: 0)
    }

    @objc private func moreButtonClicked() {
        showAccessory(tag: 1)
    }
}
