//
//  StateCell.swift
//  Day7_FMDB
//
//  Created by Chinh Ng on 10/06/2022.
//

import UIKit

class StateCell: UITableViewCell {

    @IBOutlet weak var stateName: UILabel!
    @IBOutlet weak var stateCode: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
