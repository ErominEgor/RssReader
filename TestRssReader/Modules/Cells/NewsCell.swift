//
//  NewsCell.swift
//  TestRssReader
//
//  Created by Егор Еромин on 1.02.23.
//

import UIKit

final class NewsCell: UICollectionViewCell {
    
    @IBOutlet  weak var image: UIImageView!
    @IBOutlet  weak var titleNews: UILabel!
    @IBOutlet  weak var pubDateNews: UILabel!
    @IBOutlet  weak var descriptionNews: UILabel!
    @IBOutlet  weak var buttonReadNews: UIButton! {
        didSet {
            buttonReadNews.tintColor = .white
            buttonReadNews.backgroundColor = .systemBlue
            buttonReadNews.layer.cornerRadius = 20
            buttonReadNews.layer.masksToBounds = true
        }
    }
    
    @IBOutlet  weak var saveNews: UIButton! {
        didSet {
            if saveNews.isSelected == false {
                saveNews.tintColor = .white
                saveNews.backgroundColor = .systemBlue
                saveNews.layer.cornerRadius = 20
                saveNews.layer.masksToBounds = true
            }
            
        }
    }
   
    @IBAction  func buttonDidTap(){
        saveNews.isSelected = !saveNews.isSelected
            saveNews.backgroundColor = .red
            saveNews.setTitle("News saved", for: .normal)
            saveNews.titleLabel?.textColor = .white
            saveNews.isEnabled = false
    }
}
