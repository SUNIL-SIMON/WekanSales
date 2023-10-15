//
//  SalesItemListCell.swift
//  Sales
//
//  Created by Sunil Simon on 14/10/23.
//

import Foundation
import UIKit
public class SalesItemListCell: UITableViewCell {
    let baseView = UIView()
    let itemNameLabel = UILabel()
    let itemQuantityLabel = UILabel()
    let itemPriceLabel = UILabel()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = UIColor.lightGray.withAlphaComponent(0.2)
        setUpViews()
    }
    func setUpViews()
    {
        self.addSubview(baseView)
        
        baseView.addSubview(itemNameLabel)
        seupViewProperties(view: itemNameLabel)
        baseView.addSubview(itemQuantityLabel)
        seupViewProperties(view: itemQuantityLabel)
        itemQuantityLabel.textAlignment = .right
        baseView.addSubview(itemPriceLabel)
        seupViewProperties(view: itemPriceLabel)
        itemPriceLabel.textAlignment = .right
        
        setUpConstraints()
    }
    func seupViewProperties(view: UILabel)
    {
        view.textColor = .black
        view.font = UIFont.systemFont(ofSize: 15)
    }
    func setUpConstraints()
    {
        baseView.translatesAutoresizingMaskIntoConstraints = false
        baseView.topAnchor.constraint(equalTo: self.topAnchor, constant: 5).isActive = true
        baseView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 5).isActive = true
        baseView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -5).isActive = true
        baseView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5).isActive = true
        
        itemNameLabel.translatesAutoresizingMaskIntoConstraints = false
        itemNameLabel.topAnchor.constraint(equalTo: baseView.topAnchor, constant: 5).isActive = true
        itemNameLabel.leadingAnchor.constraint(equalTo: baseView.leadingAnchor, constant: 0).isActive = true
        itemNameLabel.widthAnchor.constraint(equalTo: baseView.widthAnchor, multiplier: 0.3).isActive = true
        itemNameLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        itemQuantityLabel.translatesAutoresizingMaskIntoConstraints = false
        itemQuantityLabel.topAnchor.constraint(equalTo: baseView.topAnchor, constant: 5).isActive = true
        itemQuantityLabel.leadingAnchor.constraint(equalTo: itemNameLabel.trailingAnchor, constant: 0).isActive = true
        itemQuantityLabel.widthAnchor.constraint(equalTo: baseView.widthAnchor, multiplier: 0.3).isActive = true
        itemQuantityLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        itemPriceLabel.translatesAutoresizingMaskIntoConstraints = false
        itemPriceLabel.topAnchor.constraint(equalTo: baseView.topAnchor, constant: 5).isActive = true
        itemPriceLabel.leadingAnchor.constraint(equalTo: itemQuantityLabel.trailingAnchor, constant: 0).isActive = true
        itemPriceLabel.widthAnchor.constraint(equalTo: baseView.widthAnchor, multiplier: 0.3).isActive = true
        itemPriceLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateDetails(item  : Item?)
    {
        guard item != nil else {
            resetDetails()
            return
        }
        itemNameLabel.text = item!.name
        itemQuantityLabel.text = "\(item!.quantity)"
        itemPriceLabel.text = "\(item!.price)"
    }
    func resetDetails()
    {
        itemNameLabel.text = ""
        itemQuantityLabel.text = ""
        itemPriceLabel.text = ""
    }
}
