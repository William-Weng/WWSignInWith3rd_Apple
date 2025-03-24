//
//  ViewController.swift
//  Example
//
//  Created by William.Weng on 2022/12/15.
//
//

import UIKit
import WWSignInWith3rd_Apple

final class ViewController: UIViewController {

    @IBAction func signInWithApple(_ sender: UIButton) {
        
        WWSignInWith3rd.Apple.shared.login { result in
            print(result)
        }
    }
}
