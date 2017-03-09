//
//  circleImage.swift
//  socialMeteor
//
//  Created by Evan on 3/9/17.
//  Copyright © 2017 Evan. All rights reserved.
//

import UIKit

class circleImage: UIImageView {

    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.shadowColor = UIColor(red: shadowGray, green: shadowGray, blue: shadowGray, alpha: 0.6).cgColor
        layer.shadowOpacity = 0.8
        layer.shadowRadius = 5.0
        layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = self.frame.width/2
    }

}
