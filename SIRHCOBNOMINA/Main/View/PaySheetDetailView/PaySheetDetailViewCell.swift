//
//  PaySheetDetailViewCell.swift
//  SIRHCOBNOMINA
//
//  Created by Roberto Alba on 24/02/21.
//

import UIKit

class PaySheetDetailViewCell: UITableViewCell {

    @IBOutlet weak var labelDesc: UILabel!
    
    @IBOutlet weak var labelValue: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func configureCellAtIndexPath(indexPath:IndexPath,viewModel:PaySheetDetailViewModel)  {
        self.labelDesc.text = viewModel.descAtIndexPath(indexPath: indexPath)
        
        self.labelValue.text = viewModel.valueAtIndexPath(indexPath: indexPath)
        
        if viewModel.isBoldAtIndexPath(indexPath: indexPath) {
            self.labelDesc.font = UIFont(name: "Araboto-Bold", size: 14.0)
        } else {
            self.labelDesc.font = UIFont(name: "Araboto-Normal", size: 14.0)
        }
    }
}
