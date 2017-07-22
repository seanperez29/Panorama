//
//  ShowAlert.swift
//  Panorama
//
//  Created by Sean Perez on 7/22/17.
//  Copyright © 2017 SeanPerez. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    func showAlert(_ errorString: String) {
        let alert = UIAlertController(title: "", message: errorString, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}
