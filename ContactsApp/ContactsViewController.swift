//
//  ContactsController.swift
//  Contacts
//
//  Created by R355-M10-Stud on 07.12.2024.
//

import UIKit
import SnapKit
import Contacts
import Foundation

class ContactsViewController: UIViewController, UICollectionViewDelegate{
    private var collectionView: UICollectionView!
    private var dataSource: UICollectionViewDiffableDataSource<Int, ContactModel>!
    private var contacts: [ContactModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        title = "Контакты"
        setupCollectionView()
        setupDataSource()
        fetchContacts()
    }
    
    private func setupCollectionView(){
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: view.frame.width - 16, height: 60)
        layout.sectionInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(ContactCell.self, forCellWithReuseIdentifier: ContactCell.id)
        
        view.addSubview(collectionView)
        
        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(view).inset(UIEdgeInsets.zero)
        }
        collectionView.delegate = self
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let contact = dataSource.itemIdentifier(for: indexPath) else {return}
        showCallAction(for: contact)
    }
    
    private func setupDataSource(){
        dataSource = UICollectionViewDiffableDataSource<Int, ContactModel>(collectionView: collectionView) {(collectionView, indexPath, contact) -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ContactCell.id, for: indexPath) as? ContactCell
            cell?.configure(with: contact)
            return cell
        }
    }
    
    private func fetchContacts(){
        let store = CNContactStore()
        store.requestAccess(for: .contacts) { (granted, error) in
            DispatchQueue.main.async {
                if granted {
                    self.loadContacts(from: store)
                }
                else if CNContactStore.authorizationStatus(for: .contacts) == .denied {
                    self.showError()
                }
            }
        }
    }
        
        private func loadContacts(from store: CNContactStore){

            DispatchQueue.global().async {
                let keys = [CNContactGivenNameKey, CNContactPhoneNumbersKey] as [CNKeyDescriptor]
                let request = CNContactFetchRequest(keysToFetch: keys)
                
                do {
                    var loaded: [ContactModel] = []
                    
                    try store.enumerateContacts(with: request) {
                        (contacts, _) in
                        let name = contacts.givenName
                        let number = contacts.phoneNumbers.first?.value.stringValue ?? "Номера нет"
                        let contactModel = ContactModel(id: name, name: name, number: number)
                        loaded.append(contactModel)
                    }

                        self.contacts = loaded
                        self.updateSnapshot()

                } catch {
                    print("Ошибка при загрузке контактов")
                }
            }
        }
    
    private func updateSnapshot(){
        var snapshot = NSDiffableDataSourceSnapshot<Int, ContactModel>()
        snapshot.appendSections([0])
        snapshot.appendItems(contacts)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    private func showError(){
        let alert = UIAlertController(title: "Ошибка доступа", message: "Нет доступа к контактам", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Перейти в настройки", style: .default) {_ in
            guard let settings = URL(string: UIApplication.openSettingsURLString) else {return}
            UIApplication.shared.open(settings)
        })
        
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel))
        present(alert, animated: true, completion: nil)
    }
    
    private func showCallAction(for contact: ContactModel){
        let action = UIAlertController(title: "Позвонить \(contact.name)?", message: contact.number, preferredStyle: .actionSheet)
        
        action.addAction(UIAlertAction(title: "Позвонить", style: .default) { _ in
            if let phoneURL = URL(string: "tel://\(contact.number.filter {$0.isNumber})"){
                if UIApplication.shared.canOpenURL(phoneURL){
                    UIApplication.shared.open(phoneURL, options: [:])
                }
                else{
                    //при запуске на эмуляторе сработает эта часть
                    print("Совершаем звонок")
                }
            }
        })
        
        action.addAction(UIAlertAction(title: "Отмена", style: .cancel))
        present(action, animated: true, completion: nil)
    }

}
