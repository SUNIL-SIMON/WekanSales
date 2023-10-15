//
//  SalesView.swift
//  Sales
//
//  Created by Sunil Simon on 14/10/23.
//

import Foundation
import Foundation
import UIKit
public protocol SalesRouterDelegate: AnyObject{
    func popSalesPage()
}
class SalesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate
{
    var salesViewModel : SalesViewModel!
    public weak var routerDelegate : SalesRouterDelegate?
    
    var salesListView = UITableView()
    var searchBar = UISearchBar()
    let logOutButton = UIButton()
    
    init(salesViewModel : SalesViewModel)
    {
        print("Instances : SalesViewController +")
        super.init(nibName: nil, bundle: nil)
        self.salesViewModel = salesViewModel
        self.salesViewModel.salesModelViewDelegate = self
        setUpViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit
    {
        print("Instances : SalesViewController -")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
    }
    
    func setUpViews()
    {
        self.view.addSubview(salesListView)
        salesListView.backgroundColor = .white
        salesListView.delegate = self
        salesListView.dataSource = self
        
        self.view.addSubview(searchBar)
        searchBar.searchTextField.attributedPlaceholder = NSAttributedString(string: "Search by email", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
        searchBar.barTintColor = .white
        searchBar.backgroundColor = .white
        searchBar.searchTextField.backgroundColor = .white
        searchBar.searchTextField.textColor = .black
        searchBar.searchTextField.font = UIFont.systemFont(ofSize: 18)
        searchBar.delegate = self
        
        self.view.addSubview(logOutButton)
        logOutButton.backgroundColor = .red.withAlphaComponent(0.7)
        logOutButton.setTitleColor(.white, for: .normal)
        logOutButton.setTitle("Logout", for: .normal)
        logOutButton.addTarget(self, action:#selector(logOut), for: UIControl.Event.touchUpInside)
        
        setUpContraints()
        setUpListModifiedObserver()
    }
    
    func setUpContraints()
    {
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 100).isActive = true
        searchBar.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 5).isActive = true
        searchBar.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -5).isActive = true
        searchBar.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        salesListView.translatesAutoresizingMaskIntoConstraints = false
        salesListView.topAnchor.constraint(equalTo: self.searchBar.bottomAnchor, constant: 0).isActive = true
        salesListView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 5).isActive = true
        salesListView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -5).isActive = true
        salesListView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -70).isActive = true
        
        logOutButton.translatesAutoresizingMaskIntoConstraints = false
        logOutButton.topAnchor.constraint(equalTo: self.salesListView.bottomAnchor, constant: 5).isActive = true
        logOutButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true
        logOutButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20).isActive = true
        logOutButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
    func setUpListModifiedObserver()
    {
        self.salesViewModel.listModifiedBindingNotifier = { [weak self] in
            self?.salesListView.reloadData()
        }
        self.salesViewModel.loginStateChangedBindingNotifier = { [weak self] in
            if self?.salesViewModel.loginState == .NOTLOGGEDIN{
                self?.routerDelegate?.popSalesPage()
            }
        }
    }
    
    @objc func logOut()
    {
        self.salesViewModel.logMeOut()
    }
}
extension SalesViewController
{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return salesViewModel.filteredSales?.documents[section].items.count ?? 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return salesViewModel.filteredSales?.documents.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var headerView = salesListView.dequeueReusableHeaderFooterView(withIdentifier: "SECTIONVIEW") as! SalesHeaderCell?
        if(headerView == nil)
        {
            headerView = SalesHeaderCell.init(reuseIdentifier: "SECTIONVIEW")
        }
        headerView?.updateDetails(document : salesViewModel.filteredSales?.documents[section])
        return headerView!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = salesListView.dequeueReusableCell(withIdentifier: "DEFAULT") as! SalesItemListCell?
        if(cell == nil)
        {
            cell = SalesItemListCell.init(style: UITableViewCell.CellStyle.default, reuseIdentifier: "DEFAULT")
        }
        cell?.updateDetails(item: salesViewModel.filteredSales?.documents[indexPath.section].items[indexPath.row])
        return cell!
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) ->CGFloat
    {
        return 40
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        return 145
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat
    {
        return 0
    }
    
}
extension SalesViewController : SalesModelViewDelegate
{
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        salesViewModel.applyFilter()
    }
    func getSearcText() -> String? {
        return searchBar.text
    }
    
}
