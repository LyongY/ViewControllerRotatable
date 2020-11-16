//
//  ViewController.swift
//  ViewControllerRotatable
//
//  Created by Raysharp666 on 2020/6/16.
//  Copyright © 2020 Raysharp. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.navigationItem.rightBarButtonItem = .init(title: "push", style: .done, target: self, action: #selector(push))
        
    }
    
    @objc func push() {
        let vc = storyboard!.instantiateViewController(identifier: "ViewControllerLand")
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
