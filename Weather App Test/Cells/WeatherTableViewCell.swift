//
//  WeatherTableViewCell.swift
//  Weather App Test
//
//  Created by Debashish Chakraborty on 22/03/22.
//

import UIKit

class WeatherTableViewCell: UITableViewCell {
    
    @IBOutlet weak var locationNameLabel: UILabel!
    @IBOutlet weak var minMaxTemparatureLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
