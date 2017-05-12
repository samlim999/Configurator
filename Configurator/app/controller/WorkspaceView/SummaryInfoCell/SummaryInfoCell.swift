//
//  SummaryInfoCell.swift
//  configurator(iPad)
//
//  Created by CloudStream on 3/3/17.
//  Copyright © 2017 CloudStream. All rights reserved.
//

import UIKit

class SummaryInfoCell: UITableViewCell
{
    @IBOutlet weak var labelForOrder: UILabel!
    @IBOutlet weak var labelForDescription: UILabel!
    @IBOutlet weak var labelForSubCategory: UILabel!
    @IBOutlet weak var imageForSubCategory: UIImageView!
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)
    }
}
