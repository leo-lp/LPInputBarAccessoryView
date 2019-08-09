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
    let inputBar = LPRoomInputView(isHiddenWhenResign: false)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(inputBar)
        inputBar.lp.constraints {
            $0.leading.trailing.bottom.equal(to: view)
        }
    }
    
    @IBAction func showButtonClicked(_ sender: UIButton) {
        inputBar.textField.becomeFirstResponder()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        inputBar.hide(animated: true)
        //inputBar.textField.resignFirstResponder()
    }
}
