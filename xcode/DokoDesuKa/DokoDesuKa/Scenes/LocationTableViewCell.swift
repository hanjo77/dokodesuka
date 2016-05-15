//
//  LocationTableViewCell.swift
//  DokoDesuKa
//
//  Created by Hansjürg Jaggi on 13.05.16.
//  Copyright © 2016 Hansjürg Jaggi. All rights reserved.
//

import UIKit

class LocationTableViewCell: UITableViewCell {

    @IBOutlet var imgLocation: UIImageView!
    @IBOutlet var labelTitle: UILabel!
    @IBOutlet var labelDescription: UILabel!
    
    let webservice:DokoDesuKaAPI = DokoDesuKaAPI(connector: APIConnector())
    // let store: DokoDesuKaStore = DokoDesuKaCoreDataStore()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
}
