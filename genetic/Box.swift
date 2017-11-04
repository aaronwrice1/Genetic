//
//  Box.swift
//  genetic
//
//  Created by Aaron Rice on 8/4/17.
//  Copyright © 2017 Aaron Rice. All rights reserved.
//

import Foundation
import UIKit

struct Box {
    // UIImageView already has size and pos
    var imageView: UIImageView!
    var velocity: Velocity
    
    
    init(imageView: UIImageView = UIImageView(frame: CGRect(x: 0, y:0, width: 50, height: 50)),
         velocity: Velocity = Velocity(x: 0, y: 0),
         view: UIView) {
        
        self.imageView = imageView
        self.imageView.backgroundColor = .black
        
        self.velocity = velocity
        
        view.addSubview(self.imageView)
    }
}

struct Velocity {
    var x: CGFloat
    var y: CGFloat
    
    // default speed is 0,0
    init(x: CGFloat = 0, y: CGFloat = 0) {
        self.x = x
        self.y = y
    }
}
