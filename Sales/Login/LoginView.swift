//
//  LoginView.swift
//  Sales
//
//  Created by Sunil Simon on 14/10/23.
//

import Foundation
import UIKit
public protocol LoginRouterDelegate: AnyObject{
    func presentSalesPage()
}
class LoginViewController: UIViewController {
    
    var loginViewModel : LoginViewModel!
    public weak var routerDelegate : LoginRouterDelegate?
    
    let userLabel = UITextField()
    let pwdLabel = UITextField()
    let loginButton = UIButton()
    let activityIndicator = UIActivityIndicatorView()
    
    public init(loginViewModel : LoginViewModel){
        super.init(nibName: nil, bundle: nil)
        print("Instances : LoginViewController +")
        self.loginViewModel = loginViewModel
        setUpViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit
    {
        print("Instances : LoginViewController -")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
    }
    
    override func viewDidAppear(_ animated: Bool) {
        loginViewModel.chkLoginStatus()
    }
    
    func setUpViews()
    {
        self.view.addSubview(userLabel)
        userLabel.layer.borderWidth = 0.5
        userLabel.layer.borderColor = UIColor.black.cgColor
        userLabel.textColor = .black
        
        self.view.addSubview(pwdLabel)
        pwdLabel.layer.borderWidth = 0.5
        pwdLabel.layer.borderColor = UIColor.black.cgColor
        pwdLabel.textColor = .black
        
        self.view.addSubview(loginButton)
        loginButton.backgroundColor = .blue.withAlphaComponent(0.5)
        loginButton.setTitleColor(.white, for: .normal)
        loginButton.setTitle("Login", for: .normal)
        loginButton.addTarget(self, action:#selector(login), for: UIControl.Event.touchUpInside)
        
        self.view.addSubview(activityIndicator)
        
        setUpContraints()
        setUploginStateObserver()
    }
    func setUpContraints()
    {
        userLabel.translatesAutoresizingMaskIntoConstraints = false
        userLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 100).isActive = true
        setupCommonConstrains(view: userLabel)
        userLabel.placeholder = "Email"
        userLabel.text = "apptester@wekan.com"
        
        pwdLabel.translatesAutoresizingMaskIntoConstraints = false
        pwdLabel.topAnchor.constraint(equalTo: self.userLabel.bottomAnchor, constant: 10).isActive = true
        setupCommonConstrains(view: pwdLabel)
        pwdLabel.placeholder = "Password"
        pwdLabel.text = "Qwe@123"
        
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        loginButton.topAnchor.constraint(equalTo: self.pwdLabel.bottomAnchor, constant: 10).isActive = true
        setupCommonConstrains(view: loginButton)
        
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: 0).isActive = true
        activityIndicator.widthAnchor.constraint(equalToConstant: 40).isActive = true
        activityIndicator.heightAnchor.constraint(equalToConstant: 40).isActive = true
        activityIndicator.isHidden = true
    }
    func setupCommonConstrains(view : UIView)
    {
        view.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true
        view.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20).isActive = true
        view.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    func setUploginStateObserver()
    {
        self.loginViewModel.loginStateChangedBindingNotifier = { [weak self] in
            self?.activityIndicator.isHidden = true
            self?.activityIndicator.stopAnimating()
            if self?.loginViewModel.loginState == .WAITING{
                self?.activityIndicator.isHidden = false
                self?.activityIndicator.startAnimating()
            }
            else if self?.loginViewModel.loginState == .LOGGEDIN{
                self?.routerDelegate?.presentSalesPage()
            }
            else if self?.loginViewModel.loginState == .NOTLOGGEDIN{
                //SHOW FAILURE ALERT
            }
        }
    }
    @objc func login()
    {
        guard userLabel.text != nil && pwdLabel.text != nil else{ return }
        loginViewModel.login(user: userLabel.text!, pwd: pwdLabel.text!)
    }
    
}
