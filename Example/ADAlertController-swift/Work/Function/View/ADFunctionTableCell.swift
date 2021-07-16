//
//  ADFunctionTableCell.swift
//  ADAlertController-swift
//
//  Created by apple on 2021/6/24.
//

import UIKit

class ADFunctionTableCell: ADBaseTableCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        cellConfigUI()
    }
    
    lazy var titleLab: UILabel = {
        let tlab = UILabel()
        tlab.text = "cellTitle"
        return tlab
    }()

    func cellConfigUI() {
        
        contentView.addSubview(titleLab)
        titleLab.frame = CGRect(x: 0, y: 0, width: 300, height: contentView.frame.size.height)
        
        let moreTitle = UILabel()
        moreTitle.frame = CGRect(x: contentView.frame.size.width - 75, y: 0, width: 75, height: contentView.frame.size.height)
        moreTitle.text = "更多"

    }
    
    public var model: ADFunctionModel? {
        
        didSet {
            guard let model = model else {return}
            titleLab.text = model.title
        }
    }
    
}
