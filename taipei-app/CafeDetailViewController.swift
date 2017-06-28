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
    var annotation: CafeAnnotation?
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        self.title = annotation?.title
    }
}

extension CafeDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let ratingCell = tableView.dequeueReusableCell(withIdentifier: "ratingCell", for: indexPath) as! RatingTableViewCell
        
        return ratingCell
    }
}
