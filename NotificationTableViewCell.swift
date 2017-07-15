//
//  NotificationTableViewCell.swift
//  vKclub
//
//  Created by Machintos-HD on 7/14/17.
//  Copyright © 2017 WiAdvance. All rights reserved.
//

import UIKit

class NotificationTableViewCell: UITableViewCell {
    
    @IBOutlet weak var notitfication_body: UILabel!

    @IBOutlet weak var notification_title: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
