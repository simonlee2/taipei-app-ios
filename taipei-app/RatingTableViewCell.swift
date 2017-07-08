//
//  RatingTableViewCell.swift
//  taipei-app
//
//  Created by Shao-Ping Lee on 6/28/17.
//  Copyright © 2017 Simon Lee. All rights reserved.
//

import UIKit
import Cosmos

class RatingTableViewCell: UITableViewCell {
    
    @IBOutlet weak var wifiRating: CosmosView!
    @IBOutlet weak var availabilityRating: CosmosView!
    @IBOutlet weak var coffeeRating: CosmosView!
    @IBOutlet weak var quietnessRating: CosmosView!
    @IBOutlet weak var priceRating: CosmosView!
    
    var viewModel: CafeRatingCellViewModel? {
        didSet {
            guard let viewModel = viewModel else { return }
            configureCell(viewModel)
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(_ viewModel: CafeRatingCellViewModel) {
        [wifiRating, availabilityRating, coffeeRating, quietnessRating, priceRating].forEach { view in
            view?.settings.fillMode = .half
        }
        
        wifiRating.rating = viewModel.wifi
        availabilityRating.rating = viewModel.seat
        coffeeRating.rating = viewModel.tasty
        quietnessRating.rating = viewModel.quiet
        priceRating.rating = viewModel.cheap
    }

}

struct CafeRatingCellViewModel {
    var quiet: Double
    var seat: Double
    var wifi: Double
    var tasty: Double
    var cheap: Double
    
    init(_ annotation: CafeAnnotation) {
        quiet = annotation.quiet
        seat = annotation.seat
        wifi = annotation.wifi
        tasty = annotation.tasty
        cheap = annotation.cheap
    }
}
