//
//  LPButton.swift
//  LPInputBarAccessoryView
//
//  Created by pengli on 2019/8/9.
//  Copyright © 2019 pengli. All rights reserved.
//

import UIKit

class LPButton: UIButton {
    deinit {
        #if DEBUG
        print("\(self) release memory.")
        #endif
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(_ image: UIImage?, _ selImage: UIImage? = nil, target: Any?, action: Selector) {
        super.init(frame: .zero)
        self.setImage(image, for: .normal)
        self.addTarget(target, action: action, for: .touchUpInside)
    }
}
