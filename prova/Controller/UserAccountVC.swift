//
//  UserAccountVC.swift
//  prova
//
//  Created by Massimiliano Bonafede on 07/10/2019.
//  Copyright © 2019 Massimiliano Bonafede. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class UserAccountVC: UIViewController {

    //Outlet
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var planLbl: UILabel!
    @IBOutlet weak var accountTableView: UITableView!
    
    
    //Variables
    var myUserAccount = User()
    var encoder = JSONParameterEncoder()
    var urlPOST = "https://api-test01.moneyboxapp.com/users/login"
    var urlGETInvestor = "https://api-test01.moneyboxapp.com/investorproducts"
    
//    var header : HTTPHeaders = ["AppId":"3a97b932a9d449c981b595","Content-Type":"application/json","appVersion":"5.10.0","apiVersion":"3.0.0","Authorization":""]
    var parameters = ["Email":"androidtest@moneyboxapp.com","Password":"P455word12","Idfa":"ANYTHING"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        accountTableView.delegate = self
        accountTableView.dataSource = self
        nameLbl.text = "Hello \(myUserAccount.name) !"
        planLbl.text = "Total Plan Value: £\(myUserAccount.totalPlanValue)"
       // getUserAccount()
        
    }

    
    //Funtions
    
    func getUserInfo(forUser user: User) -> User{
        self.myUserAccount = user
       // self.myUserAccount = user
      // nameLbl.text = user.name
        return myUserAccount
    }
    
    
    func getReloadUserAccount(){
        var header : HTTPHeaders = ["Authorization":"Bearer \(myUserAccount.token)","AppId":"3a97b932a9d449c981b595","Content-Type":"application/json","appVersion":"5.10.0","apiVersion":"3.0.0"]
        AF.request(urlGETInvestor, method: .get, parameters: ["Authorization":"Bearer \(myUserAccount.token)"], encoder: encoder, headers: header, interceptor: nil).responseJSON { (response) in
            let response = response
            switch response.result{
            case .success(let value):
                //print(value)
                let myJSON : JSON = JSON(arrayLiteral: value)
                print(myJSON)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    // Actions
    @IBAction func logoutBtnWasPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}


extension UserAccountVC:UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("NUMERO",myUserAccount.friendlyName.count)
        return myUserAccount.friendlyName.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "accountCell", for: indexPath) as? accountCell else { return UITableViewCell()}
        let myfriendlyName = myUserAccount.friendlyName[indexPath.row]
        let myPlan = myUserAccount.planValue[indexPath.row]
        let myMoneyBox = myUserAccount.moneyBox[indexPath.row]
        print("MYUSERACCOUNT",myUserAccount.friendlyName[indexPath.row])
        cell.setTableCell(friendly: myfriendlyName!, plan: myPlan!, moneyBox: myMoneyBox!)
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let individualAccount = storyboard?.instantiateViewController(identifier: "individualAccountVC") as? IndividualAccount else { return }
        individualAccount.setupData(forAccount: myUserAccount, forPosition: indexPath.row)
        present(individualAccount, animated: true, completion: nil)
    }
    
    
}
