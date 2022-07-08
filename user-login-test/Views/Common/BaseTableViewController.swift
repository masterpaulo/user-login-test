//
//  BaseTableViewController.swift
//  user-login-test
//
//  Created by John Paulo on 7/8/22.
//

import UIKit

class BaseTableViewController: UITableViewController {
    
    var loadingAlert: UIAlertController?
    
    // MARK: - Methods
    
    /// Show an alert with title and message
    func showAlert(title: String?, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        
        self.present(alert, animated: true)
    }
    
    /// Show a loading indicator
    func showLoadingIndicator() {
        let loadinAlert = UIAlertController(title: nil, message: "Loading...", preferredStyle: .alert)
        
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.isUserInteractionEnabled = false
        
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.startAnimating()
        loadinAlert.view.addSubview(loadingIndicator)
        
        self.present(loadinAlert, animated: true, completion: nil)
        
        self.loadingAlert = loadinAlert
    }
    
    /// Hide loading indicator if present
    func hideLoadingIndicator() {
        loadingAlert?.dismiss(animated: true)
    }
    
}
