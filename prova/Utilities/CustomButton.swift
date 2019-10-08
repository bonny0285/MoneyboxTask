//
//  CustomButton.swift
//  prova
//
//  Created by Massimiliano Bonafede on 07/10/2019.
//  Copyright © 2019 Massimiliano Bonafede. All rights reserved.
//

import UIKit

class CustomButton: UIButton {
    override func awakeFromNib() {
        self.layer.cornerRadius = 5
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowRadius = 5
        self.layer.shadowOpacity = 0.5
    }
}
