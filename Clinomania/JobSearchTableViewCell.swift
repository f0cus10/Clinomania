//
//  JobSearchTableViewCell.swift
//  Clinomania
//
//  Created by Iftikhar A. Khan on 5/18/20.
//  Copyright © 2020 Iftikhar A. Khan. All rights reserved.
//

import UIKit

class JobSearchTableViewCell: UITableViewCell {
    
    @IBOutlet weak var jobTypeLabel: UILabel!
    @IBOutlet weak var compensationLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(for forSearchResult: JobSearchResult){
        // do something
        jobTypeLabel.text = forSearchResult.type
        compensationLabel.text = "$\(String(format: "%.2f", forSearchResult.compensation!))"
        distanceLabel.text = "Unknown"
    }

}
