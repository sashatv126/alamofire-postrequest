//
//  AlertController.swift
//  PracticeWithAlomofire
//
//  Created by Владимир on 06.03.2022.
//

import UIKit

extension UIViewController {
    
    func aleartController (title : String, message : String){
        let alert  = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default)
        alert.addAction(ok)
        present(alert,animated: true, completion: nil)
   }
}
