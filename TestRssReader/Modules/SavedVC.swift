//
//  SavedVC.swift
//  TestRssReader
//
//  Created by Егор Еромин on 3.02.23.
//

import UIKit

final class SavedVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    @IBOutlet private weak var savedCollection: UICollectionView!
    let date = Date()
    var arrayNews: [SavedNews] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        
        savedCollection.dataSource = self
        savedCollection.delegate = self
        let nib = UINib(nibName: "\(MainCell.self)", bundle: nil)
        savedCollection.register(nib, forCellWithReuseIdentifier: "\(MainCell.self)")
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadInfo()
        arrayNews.reverse()
    }
    private func loadInfo() {
        let request = SavedNews.fetchRequest()
        let news = try? CoreDataService.context.fetch(request)
        self.arrayNews = news ?? []
        savedCollection.reloadData()
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return  arrayNews.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(MainCell.self)", for: indexPath) as? MainCell
        let news = arrayNews[indexPath.row]
        cell?.pubDate.text = date.getFormattedDate(strDate: "\(news.pubDateNews ?? "")")
        cell?.mainTitle.text = news.titleNews
        DispatchQueue.global().async {
            
            if let imageUrlStr = news.image,
               let url = URL(string: imageUrlStr),
               let data = try? Data(contentsOf: url) {
                
                DispatchQueue.main.async {
                    let image = UIImage(data: data)
                    cell?.mainImage.image = image
                }
            }
        }
            return cell ??  UICollectionViewCell()
        }
        
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            let collectionWight = UIScreen.main.bounds.width
            return CGSize(width: collectionWight, height:  150)
        }
        
        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            let newsVC = NewsVC()
            let news = arrayNews[indexPath.item]
            newsVC.titleSaveNews = news.titleNews ?? ""
            newsVC.pubDateSaveNews = news.pubDateNews ?? ""
            newsVC.imageSaveNews = news.image ?? ""
            newsVC.descriptionSaveNews = news.descriptionNews ?? ""

            self.navigationController?.pushViewController(newsVC, animated: true)
        }
    }
    

