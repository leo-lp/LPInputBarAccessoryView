//
//  LPInputAccessory.swift
//  LPInputBarAccessoryView
//
//  Created by pengli on 2019/8/7.
//  Copyright © 2019 pengli. All rights reserved.
//

import UIKit

public class LPInputAccessory: UIView {
    public let contentView = UIView()
    
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
        addSubview(contentView)
        contentView.lp.constraints { $0.edges.equal(to: self) }
    }
}
