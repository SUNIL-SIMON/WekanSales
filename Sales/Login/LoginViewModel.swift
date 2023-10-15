//
//  LoginViewModel.swift
//  Sales
//
//  Created by Sunil Simon on 14/10/23.
//

import Foundation
class LoginViewModel{
    
    let requestHandler = URLRequestHandler.shared
    let dbHandler = DBHandler.shared
    var loginState : LoginState
    {
        didSet
        {
            loginStateChangedBindingNotifier()
            if loginState == .LOGGEDIN{
                let token = "***sometoken***"
                if let _ = KeychainService.loadKeyChainData(service: KeychainService.userEnvironmentservice, account: KeychainService.account) {
                    KeychainService.updateKeyChainData(service: KeychainService.userEnvironmentservice, account: KeychainService.account, data: token)
                }
                else{
                    KeychainService.saveKeyChainData(service: KeychainService.userEnvironmentservice, account: KeychainService.account, data: token)
                }
            }
        }
    }
    var loginStateChangedBindingNotifier : (() -> ()) = {}
    
    init() {
        self.loginState = .NOTLOGGEDIN
    }
    
    func login(user : String, pwd : String)
    {
        self.loginState = .WAITING
        
        let urlString =  "https://ap-south-1.aws.data.mongodb-api.com/app/devicesync-xkltu/endpoint/data/v1/action/find"

        let parameterData : [String : Any] =
        [
            "dataSource": "Cluster0",
            "database": "sample_supplies",
            "collection": "sales"
        ]
        let jsonBody = try! JSONSerialization.data(withJSONObject: parameterData, options: .prettyPrinted)
        
        var request : URLRequest
        request = URLRequest(url: URL(string: urlString)!)
        request.httpMethod = "POST"
        request.httpBody = jsonBody
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue(user, forHTTPHeaderField: "email")
        request.addValue(pwd, forHTTPHeaderField: "password")

        self.requestHandler.sendRequest(type: Sales.self, request : request, completion: {[weak self] (sales,requestStatus)in
            DispatchQueue.main.async {
                switch(requestStatus)
                {
                case .SUCCESS:
                    self?.dbHandler.deleteDB(completion: { (_) in
                        if sales != nil{
                            self?.dbHandler.writeDB(items: sales!.documents, completion: { (_) in })
                        }
                    })
                    self?.loginState = .LOGGEDIN
                case .BADRESPONSE:
                    self?.loginState = .NOTLOGGEDIN
                case .BADREQUEST:
                    self?.loginState = .NOTLOGGEDIN
                case .DECODEFAILED:
                    self?.loginState = .NOTLOGGEDIN
                }
                
            }
        })
    }
    func chkLoginStatus()
    {
        self.loginState = .WAITING
        let user = KeychainService.getUserKeyChainCredentials(service: KeychainService.userEnvironmentservice, account: KeychainService.account)
        if user != nil{
            self.loginState = .LOGGEDIN
            self.loginState = .NOTLOGGEDIN
        }
        else{
            self.loginState = .NOTLOGGEDIN
        }
    }
}
