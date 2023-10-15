//
//  Router.swift
//  Sales
//
//  Created by Sunil Simon on 14/10/23.
//

import Foundation
import UIKit
class Router
{
    var rootViewController : UIViewController?
    var loginViewController : LoginViewController?
    {
        didSet
        {
            rootViewController = loginViewController
        }
    }
    init()
    {
        print("Instances : Router +")
    }
    deinit
    {
        print("Instances : Router -")
    }
    func getRootController()->UIViewController
    {
        if rootViewController != nil{
            return rootViewController!
        }
        loginViewController = LoginViewController(loginViewModel: LoginViewModel())
        loginViewController!.routerDelegate = self
        return loginViewController!
    }
}
extension Router : LoginRouterDelegate
{
    func presentSalesPage() {
        let salesViewController = SalesViewController(salesViewModel: SalesViewModel())
        salesViewController.routerDelegate = self
        salesViewController.navigationItem.hidesBackButton = true
        rootViewController?.navigationController?.pushViewController(salesViewController, animated: true)
    }
}
extension Router : SalesRouterDelegate
{
    func popSalesPage() {
        loginViewController?.loginViewModel.loginState = .NOTLOGGEDIN
        rootViewController?.navigationController?.popViewController(animated: true)
    }
}
