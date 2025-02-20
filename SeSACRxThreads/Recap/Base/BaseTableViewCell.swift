//
//  BaseTableViewCell.swift
//  UIKit_Week9_A2
//
//  Created by 정성윤 on 2/19/25.
//

import UIKit
protocol ReusableIdentifier {}
extension ReusableIdentifier {
    static var id: String {
        String(describing: self)
    }
}

class BaseTableViewCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureView()
        configureHierarchy()
        configureLayout()
        setBinding()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureView() { }
    func configureHierarchy() { }
    func configureLayout() { }
    func setBinding() { }
}
