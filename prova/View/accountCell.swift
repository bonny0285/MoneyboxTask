//
//  accountCell.swift
//  prova
//
//  Created by Massimiliano Bonafede on 07/10/2019.
//  Copyright © 2019 Massimiliano Bonafede. All rights reserved.
//

import UIKit

class accountCell: UITableViewCell {

    
    
    //Outlet
    @IBOutlet weak var accountView: UIView!
    
    @IBOutlet weak var friendlyLbl: UILabel!
    @IBOutlet weak var planValueLbl: UILabel!
    
    @IBOutlet weak var moneyBoxLbl: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    func setTableCell(friendly : String, plan : String, moneyBox : String){
        friendlyLbl.text = "\(friendly)"
        planValueLbl.text = "Plan Value: £\(plan)"
        moneyBoxLbl.text = "Moneybox: £\(moneyBox)"
    }

}
