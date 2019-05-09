//
//  HitsResultTableViewCell.swift
//  AssignmentTest
//

import UIKit

class HitsResultTableViewCell: UITableViewCell {

    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var toggle: UISwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
