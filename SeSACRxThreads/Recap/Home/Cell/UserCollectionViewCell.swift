//
//  UserCollectionViewCell.swift
//  iOSAcademy-RxSwift
//
//  Created by Jack on 1/30/25.
//

import UIKit
import SnapKit

class UserCollectionViewCell: BaseCollectionViewCell, ReusableIdentifier {
    let label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func configureView() {
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 13)
        layer.cornerRadius = 8
        layer.borderWidth = 1
        layer.borderColor = UIColor.black.cgColor
    }
    
    override func configureHierarchy() {
        contentView.addSubview(label)
    }
    
    override func configureLayout() {
        label.snp.makeConstraints { make in
            make.edges.equalTo(contentView)
        }
    }
    
    
}

