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
     var headerInvestor : HTTPHeaders = ["":""]
    var parameters = ["Email":"androidtest@moneyboxapp.com","Password":"P455word12","Idfa":"ANYTHING"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        accountTableView.delegate = self
        accountTableView.dataSource = self
        nameLbl.text = "Hello \(myUserAccount.name) !"
        planLbl.text = "Total Plan Value: £\(myUserAccount.totalPlanValue)"
        accountTableView.reloadData()
        
    }
    

    //Funtions
    
    func getUserInfo(forUser user: User) -> User{
        self.myUserAccount = user
        return myUserAccount
    }
    
    
    func updateInfo(forUser user: User)-> User{
        self.myUserAccount = user
        return myUserAccount
    }
    

    
    func getHeader() -> HTTPHeaders{
        headerInvestor = ["Authorization":"Bearer \(myUserAccount.token)","AppId":"3a97b932a9d449c981b595","Content-Type":"application/json","appVersion":"5.10.0","apiVersion":"3.0.0"]
        return headerInvestor
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
        accountTableView.reloadData()
        present(individualAccount, animated: true, completion: nil)
    }
    
    
}
