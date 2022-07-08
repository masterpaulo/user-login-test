//
//  BaseTableViewCell.swift
//  user-login-test
//
//  Created by John Paulo on 7/7/22.
//

import UIKit

protocol CellRepresentable {
    var cellIdentifier: String { get }
}

class BaseTableViewCell: UITableViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }
    
    func configure(representable: CellRepresentable) {
        preconditionFailure("This method must be overridden")
    }
}
