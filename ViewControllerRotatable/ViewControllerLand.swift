//
//  ViewControllerLand.swift
//  ViewControllerRotatable
//
//  Created by Raysharp666 on 2020/6/16.
//  Copyright © 2020 Raysharp. All rights reserved.
//

import UIKit

//extension Rotatable where Self: ViewControllerLand {
//    var supportRotates: RotateObserver.RotatableInterfaceOrientationMask {
//        .landscape
//    }
//}

class ViewControllerLand: UIViewController, LandscapeOnly {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.navigationItem.rightBarButtonItem = .init(title: "push", style: .done, target: self, action: #selector(push))

    }
    
    
    @objc func push() {
        let vc = storyboard!.instantiateViewController(identifier: "ViewControllerAll")
        self.navigationController?.pushViewController(vc, animated: true)
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
