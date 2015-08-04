/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2015. All Rights Reserved.
*/

import UIKit

class CreateNewListTableViewCell: UITableViewCell {

    
    @IBOutlet weak var addButton: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        Utils.setUpAddButton(addButton)
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
