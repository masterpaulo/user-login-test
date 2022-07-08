//
//  DetailTitleTableViewCell.swift
//  user-login-test
//
//  Created by John Paulo on 7/8/22.
//

import Foundation
import UIKit

class DetailTitleTableViewCell: BaseTableViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // MARK: - Setup
    
    override func configure(representable: CellRepresentable) {
        guard let viewModel = representable as? DetailTitleTableCellViewModel else { return }
        self.textLabel?.text = viewModel.title
        self.detailTextLabel?.text = viewModel.value
        self.detailTextLabel?.textColor = viewModel.hasAction ? .systemBlue : .darkText
    }
    
}

class DetailTitleTableCellViewModel: CellRepresentable {
    var cellIdentifier: String { "DetailTitleTableViewCell" }
    
    let title: String
    let value: String
    var action: (() -> Void)?
    
    // MARK: - Computed Properties
    
    var hasAction: Bool { action != nil }
    
    // MARK: - init
    
    init(title: String, value: String, action: (() -> Void)? = nil) {
        self.title = title
        self.value = value
        self.action = action
    }
    
}
