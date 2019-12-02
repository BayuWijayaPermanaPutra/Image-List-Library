//
//  ImageTableViewCell.swift
//  Image Library
//
//  Created by PayTren on 11/26/19.
//  Copyright © 2019 PayTren. All rights reserved.
//

import UIKit
import SDWebImage

class ImagePixabayItemModel {
    var urlImage: String
    var userName : String
    var viewsCount : Double
    
    init(urlImage: String, username: String, viewsCount: Double) {
        self.urlImage = urlImage
        self.userName = username
        self.viewsCount = viewsCount
    }
}

class ImageTableViewCell: UITableViewCell {

    @IBOutlet weak var imgOfHead: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var viewsCount: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func buildCell(model: ImagePixabayItemModel) {
        self.imgOfHead.sd_setImage(with: URL.init(string: model.urlImage), placeholderImage: UIImage.init(named: "defaultImage"), options: .refreshCached) { (image, error, cacheType, url) in
        }
        userName.text = model.userName
        viewsCount.text = String(model.viewsCount)
    }
}
