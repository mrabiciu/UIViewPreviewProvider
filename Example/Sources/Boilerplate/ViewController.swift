//
//  ViewController.swift
//  Example App
//
//  Created by Max on 11/5/19.
//  Copyright © 2019 Max. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        label.text = """
        This is 2019.
        
        We don't render example apps in the simulator anymore!
        
        Open Xcode and look at the Examples folder to see previews in the canvas pane"
        """
        
        view.addSubview(label)
        label.frame = view.bounds.inset(by: UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16))
        
        view.backgroundColor = .white
    }


}

