//
//  BusInfoTableViewCell.swift
//  BuNal
//
//  Created by kpugame on 2020/06/11.
//  Copyright © 2020 minjoooo. All rights reserved.
//

import UIKit

class BusInfoTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var locationNo1: UILabel!
    @IBOutlet weak var locationNo2: UILabel!
    @IBOutlet weak var predictTime1: UILabel!
    @IBOutlet weak var predictTime2: UILabel!
    @IBOutlet weak var remainSeatCnt: UILabel!
    @IBOutlet weak var busImage: UIImageView!
    @IBOutlet weak var plateNo: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
