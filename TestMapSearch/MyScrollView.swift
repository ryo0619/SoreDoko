//
//  MyScrollView.swift
//  TestMapSearch
//
//  Created by 荒亮祐 on 2019/01/21.
//  Copyright © 2019 sptm6759. All rights reserved.
//

import Foundation
import UIKit

class MyScrollView: UIScrollView, UIScrollViewDelegate {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        superview?.touchesBegan(touches, with: event)
    }
}
