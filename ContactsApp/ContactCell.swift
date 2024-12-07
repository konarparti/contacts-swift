//
//  ContactCell.swift
//  Contacts
//
//  Created by R355-M10-Stud on 07.12.2024.
//

import UIKit
import SnapKit

class ContactCell : UICollectionViewCell {
    static let id = "ContactCell"
    
    private let contactView = UIView()
    private let nameLabel = UILabel()
    private let numberLabel = UILabel()
    
    override init(frame: CGRect){
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder){
        super.init(coder: coder)
        setupViews()
    }
    
    private func setupViews(){
        contactView.backgroundColor = .white

        contentView.addSubview(contactView)
        
        nameLabel.font = .boldSystemFont(ofSize: 16)
        numberLabel.font = .systemFont(ofSize: 14)
        
        nameLabel.textColor = .gray
        
        let stackView = UIStackView(arrangedSubviews: [nameLabel, numberLabel])
        stackView.axis = .vertical
        stackView.spacing = 4
        
        contactView.addSubview(stackView)
        
        contactView.snp.makeConstraints { make in
            make.edges.equalTo(contactView).inset(UIEdgeInsets.zero)
        }
        
        stackView.snp.makeConstraints { make in
            make.edges.equalTo(contactView).inset(UIEdgeInsets.zero)
        }
        
    }
    
    func configure(with model: ContactModel){
        nameLabel.text = model.name
        numberLabel.text = model.number
    }
    
    
    
}
