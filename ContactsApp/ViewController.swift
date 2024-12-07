//
//  ViewController.swift
//  Contacts
//
//  Created by R355-M10-Stud on 07.12.2024.
//

import UIKit
import SnapKit

class ViewController: UIViewController {

    private var buttonShowContacts = {
        let button = UIButton(type: .system)
        button.setTitle("Список контактов", for: .normal)
        button.setTitleColor(.gray, for: .normal)
        button.addTarget(self, action: #selector(showContacts), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func setup(){
        view.backgroundColor = .white
        
        view.addSubview(buttonShowContacts)
        
        buttonShowContacts.snp.makeConstraints { make in
            make.height.equalTo(200)
            make.width.equalTo(200)
            make.top.equalTo(view.snp.top).offset(100)
            make.left.equalTo(view.snp.left).offset(100)
        }
    }
    
    @objc
    private func showContacts(){
        let contactController = ContactsViewController()
        navigationController?.pushViewController(contactController, animated: true)
    }

}

