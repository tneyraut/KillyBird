//
//  ImageViewWithLabel.swift
//  KillyBird
//
//  Created by Thomas Mac on 30/06/2016.
//  Copyright © 2016 ThomasNeyraut. All rights reserved.
//

import UIKit

class ImageViewWithLabel: UIImageView {

    internal let label = UILabel()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.label.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)
        
        self.label.backgroundColor = UIColor.clearColor()
        
        self.label.textColor = UIColor.blackColor()
        
        self.label.textAlignment = .Center

        var size = self.label.frame.size.width
        if (size > self.label.frame.size.height)
        {
            size = self.label.frame.size.height
        }
        self.label.font = UIFont(name:"HelveticaNeue-CondensedBlack", size:size / 3)
        
        self.label.hidden = false
        
        self.addSubview(self.label)
    }

}
