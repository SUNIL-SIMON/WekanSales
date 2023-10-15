//
//  SalesHeaderCell.swift
//  Sales
//
//  Created by Sunil Simon on 14/10/23.
//

import Foundation
import UIKit
class SalesHeaderCell: UITableViewHeaderFooterView {

    let baseView = UIView()
    let divider = UIView()
    let customerEmailLabel = UILabel()
    let customerGenderLabel = UILabel()
    let customerAgeLabel = UILabel()
    let customerSatisfactionLabel = UILabel()
    let customerDateLabel = UILabel()
    let customerStoreLabel = UILabel()
    let customerCouponLabel = UILabel()
    let customerPurchaseLabel = UILabel()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setUpViews()
    }
    func setUpViews()
    {
        self.addSubview(baseView)
        baseView.translatesAutoresizingMaskIntoConstraints = false
        baseView.topAnchor.constraint(equalTo: self.topAnchor, constant: 5).isActive = true
        baseView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 5).isActive = true
        baseView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -5).isActive = true
        baseView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5).isActive = true
        
        self.addSubview(divider)
        divider.backgroundColor = .black
        divider.translatesAutoresizingMaskIntoConstraints = false
        divider.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        divider.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0).isActive = true
        divider.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0).isActive = true
        divider.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
        baseView.addSubview(customerEmailLabel)
        seupViewProperties(view: customerEmailLabel)
        baseView.addSubview(customerGenderLabel)
        seupViewProperties(view: customerGenderLabel)
        setUpConstraints(view1: customerEmailLabel, view2: customerGenderLabel, topView: nil)
    
        baseView.addSubview(customerAgeLabel)
        seupViewProperties(view: customerAgeLabel)
        baseView.addSubview(customerSatisfactionLabel)
        seupViewProperties(view: customerSatisfactionLabel)
        setUpConstraints(view1: customerAgeLabel, view2: customerSatisfactionLabel, topView: customerEmailLabel)
        
        baseView.addSubview(customerDateLabel)
        seupViewProperties(view: customerDateLabel)
        baseView.addSubview(customerStoreLabel)
        seupViewProperties(view: customerStoreLabel)
        setUpConstraints(view1: customerDateLabel, view2: customerStoreLabel, topView: customerAgeLabel)
        
        baseView.addSubview(customerCouponLabel)
        seupViewProperties(view: customerCouponLabel)
        baseView.addSubview(customerPurchaseLabel)
        seupViewProperties(view: customerPurchaseLabel)
        setUpConstraints(view1: customerCouponLabel, view2: customerPurchaseLabel, topView: customerDateLabel)
    }
    func seupViewProperties(view: UILabel)
    {
        view.textColor = .black
        view.font = UIFont.systemFont(ofSize: 15)
    }
    func setUpConstraints(view1 : UIView, view2 : UIView, topView : UIView?)
    {
        view1.translatesAutoresizingMaskIntoConstraints = false
        view1.topAnchor.constraint(equalTo: topView == nil ? baseView.topAnchor : topView!.bottomAnchor, constant: 2).isActive = true
        view1.leadingAnchor.constraint(equalTo: baseView.leadingAnchor, constant: 0).isActive = true
        view1.widthAnchor.constraint(equalTo: baseView.widthAnchor, multiplier: 0.6).isActive = true
        view1.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        view2.translatesAutoresizingMaskIntoConstraints = false
        view2.topAnchor.constraint(equalTo: topView == nil ? baseView.topAnchor : topView!.bottomAnchor, constant: 2).isActive = true
        view2.leadingAnchor.constraint(equalTo: view1.trailingAnchor, constant: 0).isActive = true
        view2.widthAnchor.constraint(equalTo: baseView.widthAnchor, multiplier: 0.4).isActive = true
        view2.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateDetails(document  : Document?)
    {
        guard document != nil else {
            resetDetails()
            return
        }
        guard document!.customer != nil else {
            resetDetails()
            return
        }
        customerEmailLabel.text = "Email : \(document!.customer.email)"
        customerGenderLabel.text = "Gender : \(document!.customer.gender)"
        customerAgeLabel.text = "Age : \(document!.customer.age)"
        customerSatisfactionLabel.text = "Satisfaction : \(document!.customer.satisfaction)"
        customerDateLabel.text = "Sale : \(document!.saleDate.getDate()?.getDate() ?? "")"
        customerStoreLabel.text = "Store : \(document!.storeLocation)"
        customerCouponLabel.text = "Coupon : \(document!.couponUsed)"
        customerPurchaseLabel.text = "Purchase : \(document!.purchaseMethod)"
    }
    func resetDetails()
    {
        customerEmailLabel.text = ""
        customerGenderLabel.text = ""
        customerAgeLabel.text = ""
        customerSatisfactionLabel.text = ""
        customerDateLabel.text = ""
        customerStoreLabel.text = ""
        customerCouponLabel.text = ""
        customerPurchaseLabel.text = ""
    }
    
}
