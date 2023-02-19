//
//  MainCell.swift
//  TestRssReader
//
//  Created by Егор Еромин on 1.02.23.
//

import UIKit

final class MainCell: UICollectionViewCell {
    
    @IBOutlet  weak var mainImage: UIImageView!
    @IBOutlet  weak var mainTitle: UILabel!
    @IBOutlet  weak var pubDate: UILabel!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.contentView.layer.cornerRadius =  10
        self.contentView.clipsToBounds = true
    }
    
        override func prepareForReuse() {
            super.prepareForReuse()
            self.mainTitle.textColor = nil
        }
}
