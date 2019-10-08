//
//  ViewController.swift
//  prova
//
//  Created by Massimiliano Bonafede on 26/09/2019.
//  Copyright © 2019 Massimiliano Bonafede. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class LoginVC: UIViewController {
    
    
    
    
    // Outlet
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var nameTxt: UITextField!
    
    
    
    // Variables
    var encoder = JSONParameterEncoder()
    var urlPOST = "https://api-test01.moneyboxapp.com/users/login"
    var urlGET = "https://api-test01.moneyboxapp.com/"
    var urlGETInvestor = "https://api-test01.moneyboxapp.com/investorproducts"
    var header : HTTPHeaders = ["AppId":"3a97b932a9d449c981b595","Content-Type":"application/json","appVersion":"5.10.0","apiVersion":"3.0.0"]
    var headerInvestor : HTTPHeaders = ["":""]
    var parameters = ["Email":"androidtest@moneyboxapp.com","Password":"P455word12","Idfa":"ANYTHING"]
    var parameterInvestor = ["":""]
    var myUser = User()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }
    
    
    @IBAction func loginBtnWasPressed(_ sender: Any) {
        AF.request(urlPOST, method: .post, parameters: self.parameters, encoder: encoder, headers: header, interceptor: nil).responseJSON { (response) in
            
            switch response.result{
            case .success(let value):
              
                let myJSON : JSON = JSON(arrayLiteral: value)
                let token = myJSON[0]["Session"]["BearerToken"]
                let lastNameJSON = myJSON[0]["User"]["LastName"]
                let nameJSON = myJSON[0]["User"]["FirstName"]
                let inv = myJSON[0]["User"]["InvestorProduct"]
                
                
                self.myUser.token = "\(token)"
                self.myUser.name = "\(nameJSON)"
                self.myUser.surname = "\(lastNameJSON)"

                
                AF.request(self.urlGETInvestor, method: .get,headers: self.getHeader()).responseJSON { (response) in
                    let response = response
                    switch response.result{
                    case .success(let value):
                        
                        let investorJSON : JSON = JSON(arrayLiteral: value)
                        
                        let jsonTotalPlanValue = investorJSON[0]["TotalPlanValue"]
                        self.myUser.totalPlanValue = Double("\(jsonTotalPlanValue)") as! Double
                        
                        var counterFriendlyName = 0
                        var friendly = [Int : String]()
                        var planValue = [Int : String]()
                        var moneyBox = [Int : String]()
                        var id = [Int : String]()
                       
                        for i in investorJSON[0]["ProductResponses"] {
                            counterFriendlyName += 1
                        }
                        
                        // Get all Friendly Account Name
                        for i in 0...counterFriendlyName - 1 {
                            friendly[i] = "\(investorJSON[0]["ProductResponses"][i]["Product"]["FriendlyName"])"
                        }
                        
                        // Get all Plan Value
                        for i in 0...counterFriendlyName - 1{
                            planValue[i] = "\(investorJSON[0]["ProductResponses"][i]["PlanValue"])"
                        }
                        
                        // Get all MoneyBox
                        for i in 0...counterFriendlyName - 1 {
                            moneyBox[i] = "\(investorJSON[0]["ProductResponses"][i]["Moneybox"])"
                        }
                        
                        // Get all Id
                        for i in 0...counterFriendlyName - 1 {
                            id[i] = "\(investorJSON[0]["ProductResponses"][i]["Id"])"
                        }
                       
                        self.myUser.friendlyName = friendly
                        self.myUser.planValue = planValue
                        self.myUser.moneyBox = moneyBox
                        self.myUser.id = id
                        self.getData(user: self.myUser)
                    case .failure(let error):
                        print(error)
                    }
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    
    func getData(user: User) -> User{
        self.myUser = user
        self.performSegue(withIdentifier: "segueToUserAccount", sender: nil)
        return myUser
    }
    

    
    func getHeader() -> HTTPHeaders{
        headerInvestor = ["Authorization":"Bearer \(myUser.token)","AppId":"3a97b932a9d449c981b595","Content-Type":"application/json","appVersion":"5.10.0","apiVersion":"3.0.0"]
        return headerInvestor
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let userAccountVC = segue.destination as? UserAccountVC{
            userAccountVC.getUserInfo(forUser: myUser)
        }
    }
    


}

