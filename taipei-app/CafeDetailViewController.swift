//
//  CafeDetailViewController.swift
//  taipei-app
//
//  Created by Shao-Ping Lee on 6/17/17.
//  Copyright © 2017 Simon Lee. All rights reserved.
//

import UIKit
import Mapbox

class CafeDetailViewController: UIViewController {
    var annotation: MGLAnnotation? {
        didSet {
//            nameLabel.text = annotation?.title!
        }
    }

    @IBOutlet weak var nameLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
