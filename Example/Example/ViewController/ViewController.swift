//
//  ViewController.swift
//  Example
//
//  Created by William.Weng on 2022/12/15.
//  ~/Library/Caches/org.swift.swiftpm/
//  file:///Users/william/Desktop/WWSignInWith3rd+Apple

import UIKit
import WWPrint
import WWSignInWith3rd_Apple

final class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func signInWithApple(_ sender: UIButton) {
        
        WWSignInWith3rd.Apple.shared.login { result in
            wwPrint(result)
        }
    }
}
