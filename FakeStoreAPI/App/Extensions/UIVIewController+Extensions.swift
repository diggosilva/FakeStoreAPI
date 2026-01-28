//
//  UIVIewController+Extensions.swift
//  FakeStoreAPI
//
//  Created by Diggo Silva on 27/01/26.
//

import UIKit

extension UIViewController {
    
    func showAlert(title: String, message: String, buttonTitle: String = "OK", completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: buttonTitle, style: .default) { _ in
            completion?()
        }
        
        alert.addAction(action)
        present(alert, animated: true)
    }
    
    func showErrorAlert(message: String) {
        showAlert(title: "Erro ❌", message: message, buttonTitle: "Tentar novamente")
    }
}
