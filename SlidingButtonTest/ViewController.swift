//
//  ViewController.swift
//  SlidingButtonTest
//
//  Created by a.vaysberg on 10/22/22.
//

import UIKit
import SlidingButton

class ViewController: UIViewController {
    let slidingButton = SlidingButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(slidingButton)
        
        slidingButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            slidingButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            slidingButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            slidingButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -32),
        ])
    }
}

