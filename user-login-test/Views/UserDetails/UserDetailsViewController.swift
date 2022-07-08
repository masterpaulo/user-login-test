//
//  UserDetailsViewController.swift
//  user-login-test
//
//  Created by John Paulo on 7/7/22.
//

import UIKit
import RxSwift

class UserDetailsViewController: UITableViewController {

    var vm: UserDetailsViewModel!
    
    var bag = DisposeBag()
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
        
        bindViewModel()
    }
    
    // MARK: - Setup
    
    func setup() {
        tableView.register(UINib(nibName: "DetailTitleTableViewCell", bundle: nil), forCellReuseIdentifier: "DetailTitleTableViewCell")
    }

}

// MARK: Bind View Model

extension UserDetailsViewController {
    func bindViewModel() {
        vm.showMapDetails.subscribe(onNext: { [weak self] in
            self?.presentMapDetails()
        })
        .disposed(by: bag)
    }
}


// MARK: UITableViewDataSource & UITableViewDelegate

extension UserDetailsViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return vm.sections.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return vm.sectionTitle(at: section)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vm.numberOfItems(for: section)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellViewModel = vm.cellViewModelAt(index: indexPath.item, section: indexPath.section)
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellViewModel.cellIdentifier, for: indexPath) as? BaseTableViewCell
        
        
        cell?.configure(representable: cellViewModel)
        return cell ?? UITableViewCell()
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        vm.selectItemAt(index: indexPath.item, section: indexPath.section)
    }
}

// MARK: Presentation Functions

extension UserDetailsViewController {
    func presentMapDetails() {
        let vc = MapViewController.instantiate(fromAppStoryboard: .user)
        
        
        vc.vm = MapViewModel(user: vm.user)
        self.present(vc, animated: true)
    }
}
