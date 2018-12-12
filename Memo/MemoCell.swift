//
//  MemoCell.swift
//  Memo
//
//  Created by 503-03 on 29/11/2018.
//  Copyright © 2018 shenah. All rights reserved.
//

import UIKit

class MemoCell: UITableViewCell {

    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var subject: UILabel!
    @IBOutlet weak var contents: UILabel!
    @IBOutlet weak var date: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
