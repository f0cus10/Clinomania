//
//  JobTableViewCell.swift
//  Clinomania
//
//  Created by Iftikhar A. Khan on 5/16/20.
//  Copyright © 2020 Iftikhar A. Khan. All rights reserved.
//

import UIKit

class JobTableViewCell: UITableViewCell {
    
    @IBOutlet weak var jobTypeLabel: UILabel!
    @IBOutlet weak var compensationLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(for forJob: Job){
        if forJob.type.isEmpty {
            jobTypeLabel.text = "(No type provided)"
        } else {
            jobTypeLabel.text = forJob.type
        }
        
        compensationLabel.text = String(format: "%.2f", forJob.compensation)
    }
}
