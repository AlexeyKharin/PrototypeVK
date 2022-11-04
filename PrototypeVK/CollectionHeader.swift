
//  CollectionHeader.swift
//  PrototypeVK
//
//  Created by Alexey Kharin on 02.11.2022.
//

import Foundation
import UIKit

class CollectionHeader: UICollectionReusableView {
    
    static let identifier = "CollectionHeader"
    
    var dataTransferInt: ((Int) -> Void)?
    
    private lazy var segmentInformationOfUser: UISegmentedControl = {
        let operations = SelectedSegment.allCases.map { $0.rawValue }
        let control = UISegmentedControl(items: operations)
        control.toAutoLayout()
        control.backgroundColor = UIColor(red: 255/255, green: 250/255, blue: 255/255, alpha: 0.8)
        control.selectedSegmentTintColor =  UIColor(red: 119/255, green: 136/255, blue: 153/255, alpha: 0.8)
        control.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor(red: 233/255, green:238/255, blue: 250/255, alpha: 1),  NSAttributedString.Key.font : UIFont.systemFont(ofSize: 18, weight: .regular)], for: .selected)
        control.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1),  NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17, weight: .regular)], for: .normal)
        control.addTarget(self, action: #selector(toggleTypeInformation), for: .valueChanged)
        return control
    }()
    
    @objc func toggleTypeInformation() {
        dataTransferInt?(segmentInformationOfUser.selectedSegmentIndex)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        segmentInformationOfUser.selectedSegmentIndex = 0
        backgroundColor = #colorLiteral(red: 0.968627451, green: 0.9725490196, blue: 0.9921568627, alpha: 1)
        setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    func setUp() {
        addSubview(segmentInformationOfUser)
        let constraints = [
            
            segmentInformationOfUser.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            segmentInformationOfUser.leftAnchor.constraint(equalTo: leftAnchor, constant: 25),
            segmentInformationOfUser.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -25),
            segmentInformationOfUser.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
}

