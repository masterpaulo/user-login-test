//
//  UserListViewController.swift
//  user-login-test
//
//  Created by John Paulo on 7/6/22.
//

import UIKit
import RxSwift

class UserListViewController: BaseTableViewController {

    var vm: UserListViewModel!
    
    var bag = DisposeBag()
    
    // MARK: - Outlets
    @IBOutlet weak var noDataView: UIView!
    @IBOutlet weak var loadingIndicatorView: UIView!
    
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        bindViewModel()
        
        vm.load()
    }
    
    // MARK: - Setup
    
    func setup() {
        self.title = "User List"
    }

    // MARK: - Actions
    
    @IBAction func reloadButtonAction(_ sender: Any) {
        vm.load()
    }
    
    
}

// MARK: Bind View Model

extension UserListViewController {
    func bindViewModel() {
        bindDidLoadUserList()
        bindLoading()
    }
    
    func bindDidLoadUserList() {
        vm.didLoadUserList.subscribe(onNext: {
            self.tableView.reloadData()
        }).disposed(by: bag)
    }
    
    func bindLoading() {
        vm.isLoading.subscribe(onNext: { [weak self] loading in
            if loading {
                self?.showLoadingIndicator()
            } else {
                self?.hideLoadingIndicator()
            }
        })
        .disposed(by: bag)
    }
}

// MARK: UITableViewDataSource & UITableViewDelegate

extension UserListViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = vm.userList.count
        tableView.backgroundView = count == 0 ? noDataView : nil
        return count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let user = vm.userList[indexPath.item]
        let cell = UITableViewCell()
        cell.textLabel?.text = user.name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        vm.selectUser(at: indexPath.item)
    }
}
