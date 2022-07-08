//
//  UserDetailsViewModel.swift
//  user-login-test
//
//  Created by John Paulo on 7/7/22.
//

import Foundation
import RxSwift

/*
 {
   "id": 8,
   "name": "Nicholas Runolfsdottir V",
   "username": "Maxime_Nienow",
   "email": "Sherwood@rosamond.me",
   "address": {
     "street": "Ellsworth Summit",
     "suite": "Suite 729",
     "city": "Aliyaview",
     "zipcode": "45169",
     "geo": {
       "lat": "-14.3990",
       "lng": "-120.7677"
     }
   },
   "phone": "586.493.6943 x140",
   "website": "jacynthe.com",
   "company": {
     "name": "Abernathy Group",
     "catchPhrase": "Implemented secondary concept",
     "bs": "e-enable extensible e-tailers"
   }
 },
 */

class UserDetailsViewModel {
    
    enum Sections: CaseIterable {
        case main
        case address
        case company
        
        var title: String? {
            switch self {
            case .main: return nil
            case .address: return "Address"
            case .company: return "Company"
            }
        }
    }
    
    // MARK: - Params
    
    let user: User

    let showMapDetails = PublishSubject<Void>()
    
    // MARK: - Constants
    
    let sections = Sections.allCases
    
    // MARK: - init
    
    init(user: User) {
        self.user = user
    }
    
    // MARK: - Cell View Models
    
    var sectionViewModels: [[CellRepresentable]] {
        sections.map {
            switch $0 {
            case .main: return mainSectionCells
            case .address: return addressSectionCells
            case .company: return companySectionCells
            }
        }
    }
    
    private var mainSectionCells: [CellRepresentable] {
        var items = [CellRepresentable]()
        
        items.append(DetailTitleTableCellViewModel(title: "Name", value: user.name))
        items.append(DetailTitleTableCellViewModel(title: "Username", value: user.username))
        items.append(DetailTitleTableCellViewModel(title: "Email", value: user.email))
        items.append(DetailTitleTableCellViewModel(title: "Website", value: user.website))
        
        return items
    }
    
    private var addressSectionCells: [CellRepresentable] {
        var items = [CellRepresentable]()
        
        items.append(DetailTitleTableCellViewModel(title: "Street", value: user.address.street))
        items.append(DetailTitleTableCellViewModel(title: "Suite", value: user.address.suite))
        items.append(DetailTitleTableCellViewModel(title: "City", value: user.address.city))
        items.append(DetailTitleTableCellViewModel(title: "Zip", value: user.address.zipcode))
        
        let coordinates = "\(user.address.coordinates.lat), \(user.address.coordinates.lng)"
        items.append(DetailTitleTableCellViewModel(title: "Coordinates", value: coordinates, action: { [weak self] in
            self?.showMapDetails.onNext(())
        }))
        
        return items
    }
    
    private var companySectionCells: [CellRepresentable] {
        var items = [CellRepresentable]()
        
        items.append(DetailTitleTableCellViewModel(title: "Name", value: user.company.name))
        items.append(DetailTitleTableCellViewModel(title: "Catch Phrase", value: user.company.catchPhrase))
        items.append(DetailTitleTableCellViewModel(title: "BS", value: user.company.bs))
        
        return items
    }
    
}

// MARK: - Table Builder Methods

extension UserDetailsViewModel {
    func sectionTitle(at section: Int) -> String? {
        sections[section].title
    }

    func numberOfItems(for section: Int) -> Int {
        switch sections[section] {
        case .main: return mainSectionCells.count
        case .address: return addressSectionCells.count
        case .company: return companySectionCells.count
        }
    }
    
    func cellViewModelAt(index: Int, section: Int) -> CellRepresentable {
        sectionViewModels[section][index]
    }
    
    func selectItemAt(index: Int, section: Int) {
        if let detailCellViewModel = sectionViewModels[section][index] as? DetailTitleTableCellViewModel {
            detailCellViewModel.action?()
        }
    }
}
