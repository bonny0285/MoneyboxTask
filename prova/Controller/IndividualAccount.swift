//
//  IndividualAccount.swift
//  prova
//
//  Created by Massimiliano Bonafede on 08/10/2019.
//  Copyright © 2019 Massimiliano Bonafede. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class IndividualAccount: UIViewController {
    
    
    
    //Outlet
    @IBOutlet weak var friendlyNameLbl: UILabel!
    @IBOutlet weak var planValueLbl: UILabel!
    @IBOutlet weak var moneyboxLbl: UILabel!
    
    
    //Variables
    public private(set) var account : User!
    var position = 0
    var urlPOSTPayment = "https://api-test01.moneyboxapp.com/oneoffpayments"
    var encoder = JSONParameterEncoder()
    var headerInvestor : HTTPHeaders = ["":""]
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        friendlyNameLbl.text = "\(account.friendlyName[position]!)"
               planValueLbl.text = "Plan Value: £\(account.planValue[position]!)"
               moneyboxLbl.text = "Moneybox: £\(account.moneyBox[position]!)"
    }
    
    
    
    //Functions
    func setupData(forAccount account: User, forPosition position: Int){
        self.account = account
        self.position = position
    }
    
    
    
    func addMoney(){
        let id = Int(account.id[position]!) as! Int

        AF.request(urlPOSTPayment, method: .post, parameters: ["Amount":10,"InvestorProductId": id], encoder: encoder, headers: getHeader(), interceptor: nil).responseJSON { (response) in
            let response = response
            switch response.result{
            case .success(let value):
              
                let myJSON : JSON = JSON(arrayLiteral: value)
                print(myJSON)
            case .failure(let error):
                print(error)
            }
        }
        
        getReloadUserAccount()
    }
    


    
    func getHeader() -> HTTPHeaders{
        headerInvestor = ["Authorization":"Bearer \(account.token)","AppId":"3a97b932a9d449c981b595","Content-Type":"application/json","appVersion":"5.10.0","apiVersion":"3.0.0"]
        return headerInvestor
    }
    
    //Actions
    @IBAction func addBtnWasPressed(_ sender: Any) {
        addMoney()
        dismiss(animated: true, completion: nil)
    }
    
    
    func getReloadUserAccount(){
    print(#function)
    var header : HTTPHeaders = ["Authorization":"Bearer \(account.token)","AppId":"3a97b932a9d449c981b595","Content-Type":"application/json","appVersion":"5.10.0","apiVersion":"3.0.0"]
    AF.request("https://api-test01.moneyboxapp.com/investorproducts", method: .get ,headers: getHeader()).responseJSON { (response) in
        let response = response
        switch response.result{
        case .success(let value):
           
            let myJSON : JSON = JSON(arrayLiteral: value)
            
            var counter = 0
            var moneyBox = [Int : String]()
            
            let jsonTotalPlanValue = myJSON[0]["TotalPlanValue"]
            self.account.totalPlanValue = Double("\(jsonTotalPlanValue)") as! Double
            
            for i in myJSON[0]["ProductResponses"] {
                counter += 1
            }
            
            for i in 0...counter - 1 {
                moneyBox[i] = "\(myJSON[0]["ProductResponses"][i]["Moneybox"])"
            }
            self.account.moneyBox = moneyBox
            self.getData(user: self.account)
            
        case .failure(let errror):
            print("error")
        }
    }
    }
    
    func getData(user: User) -> User{
        self.account = user
        self.performSegue(withIdentifier: "segueToAccount", sender: nil)
        return account
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let userAccountVC = segue.destination as? UserAccountVC{
            userAccountVC.updateInfo(forUser: account)
        }
    }
}
