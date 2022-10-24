//
//  SystemAlert.swift
//  SimpleProductList
//
//  Created by 백성우 on 2022/10/24.
//

import UIKit

class SystemAlert {
    private var presentController: UIViewController {
        return (UIApplication.shared.connectedScenes.first as! UIWindowScene).windows.first!.rootViewController!
    }
    
    func showAlertController(title: String, message: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.presentController.present(alert, animated: true)
        }
    }
}

