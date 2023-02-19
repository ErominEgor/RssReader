//
//  NewsVC.swift
//  TestRssReader
//
//  Created by Егор Еромин on 1.02.23.
//

import UIKit
import WebKit

final class NewsVC:UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet private weak var workCollection: UICollectionView!
    private var obtainImage = ObtainImage()
//    private var rssItems: [StructJson]?
    var item: StructJson?
    let date = Date()
    var cacheData: NSCache<NSString, UIImage> = {
        let cache = NSCache<NSString, UIImage>()
        return cache
    }()
    var titleSaveNews: String = ""
    var pubDateSaveNews: String = ""
    var imageSaveNews: String = ""
    var descriptionSaveNews: String = ""

    
    override func viewDidLoad() {
        super.viewDidLoad()
        workCollection.dataSource = self
        workCollection.delegate = self
        let nib1 = UINib(nibName: "\(NewsCell.self)", bundle: nil)
        workCollection.register(nib1, forCellWithReuseIdentifier: "\(NewsCell.self)")
    }
    
    @objc private func Go() {
        if let urlStr = item?.link,
           let url = URL(string: urlStr) {
            UIApplication.shared.open(url)
        }
    }
    @objc func createDidTap() {
        
        let context = CoreDataService.context
            context.perform {
                let newSavedNews = SavedNews(context: context)
                newSavedNews.pubDateNews = self.item?.pubDate
                newSavedNews.image = self.item?.enclosure
                newSavedNews.titleNews = self.item?.title
                newSavedNews.descriptionNews = self.item?.description
//                print(self.item?.description)
                CoreDataService.saveContext()
        }
    }
    //MARK: - UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(NewsCell.self)", for: indexPath) as? NewsCell
        cell?.titleNews.text = titleSaveNews
        if titleSaveNews == "" {
            cell?.titleNews.text = item?.title
        }
        
        cell?.buttonReadNews.addTarget(self, action: #selector(Go), for: .touchUpInside)
        cell?.saveNews.addTarget(self, action: #selector(createDidTap), for: .touchUpInside)
        
        cell?.descriptionNews.text = descriptionSaveNews
        if descriptionSaveNews == "" {
            cell?.descriptionNews.text = item?.description
        }
        
        let dateString = date.getFormattedDate(strDate: "\(item?.pubDate ?? "")")
        cell?.pubDateNews.text = dateString
        
        DispatchQueue.global().async {
            if let url = URL(string: self.imageSaveNews),
               let data = try? Data(contentsOf: url) {
                
                DispatchQueue.main.async {
                    let image = UIImage(data: data)
                    cell?.image.image = image
                }
            }
        }
        if imageSaveNews == "" {
            if let imageLink = item?.enclosure {
                if let cachedImage = cacheData.object(forKey: imageLink as NSString) {
                    cell?.image.image = cachedImage
                } else {
                    let _: () = obtainImage.obtainImage(imageURL: imageLink ) { [weak self] image in
                        self?.cacheData.setObject(image ?? UIImage() , forKey: imageLink  as NSString )
                        
                        DispatchQueue.main.async {
                            self?.workCollection.reloadItems(at: [indexPath])
                        }
                    }
                }
            }
        }
        
        return cell ??  UICollectionViewCell()
    }
    //MARK: - UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionWight = UIScreen.main.bounds.width
        _ = UIScreen.main.bounds.height
        return CGSize(width: collectionWight  , height:  view.window?.windowScene?.screen.bounds.height ?? CGFloat())
    }
}
