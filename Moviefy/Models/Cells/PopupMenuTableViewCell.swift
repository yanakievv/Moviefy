//
//  PopupMenuTableViewCell.swift
//  Moviefy
//
//  Created by Vladimir Yanakiev on 18.03.21.
//  Copyright © 2021 Vladimir Yanakiev. All rights reserved.
//

import UIKit

class PopupMenuTableViewCell: UITableViewCell {
    
    private let label : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false // enable auto-layout
        label.textAlignment = .center // text alignment in center
        label.text = "op"
        return label
    }()
    
    func setData(labelText: String) {
        self.label.text = labelText
    }
    
    private func addLabel() {
        addSubview(label)
        NSLayoutConstraint.activate([
            label.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.7),
            label.centerXAnchor.constraint(equalTo: centerXAnchor),
            label.centerYAnchor.constraint(equalTo: centerYAnchor)
            ])
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addLabel()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
