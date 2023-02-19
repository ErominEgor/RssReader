//
//  MainVC.swift
//  TestRssReader
//
//  Created by Егор Еромин on 1.02.23.
//

import UIKit

final class MainVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var mainCollection: UICollectionView!
    private var ViewModel: RssItensProtocol = MainVM()
    private var obtainImage = ObtainImage()
    var refreshControl = UIRefreshControl()
    let date = Date()
    var cacheData: NSCache<NSString, UIImage> = {
        let cache = NSCache<NSString, UIImage>()
        return cache
    }()
    //MARK: - Life cucle
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        ViewModel.fetchData()

        refreshControl.addTarget(self, action: #selector(bind), for: UIControl.Event.valueChanged)
        mainCollection.refreshControl = refreshControl
        mainCollection.dataSource = self
        mainCollection.delegate = self
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Saved news", style: .plain, target: self, action: #selector(addTapped))
        navigationItem.rightBarButtonItem?.tintColor = UIColor.brown
        
        let nib = UINib(nibName: "\(MainCell.self)", bundle: nil)
        mainCollection.register(nib, forCellWithReuseIdentifier: "\(MainCell.self)")
    }
    @objc func bind() {
        ViewModel.contentDidUpdate =  {
            self.mainCollection.reloadData()
        }
        OperationQueue.main.addOperation {
            self.mainCollection.refreshControl?.endRefreshing()
            self.mainCollection.reloadSections(IndexSet(integer: 0))
        }
    }
    @objc func addTapped() {
        let savedVC = SavedVC(nibName: "SavedVC", bundle: nil)
        let nc = UINavigationController(rootViewController: savedVC)
    
        self.present(nc, animated: true, completion: nil)
    }
    //MARK: - UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ViewModel.rssItems.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(MainCell.self)", for: indexPath) as? MainCell
        
        let item = ViewModel.rssItems[indexPath.item]
            cell?.mainTitle.text = item.title
            
            let dateString = date.getFormattedDate(strDate: "\(item.pubDate)")
        cell?.pubDate.text = dateString
     
        cell?.mainTitle.textColor = item.isRead ? .orange : .black
            
            let imageLink = item.enclosure
            if let cachedImage = cacheData.object(forKey: imageLink as NSString) {
                cell?.mainImage.image = cachedImage
            } else {
                let _: () = obtainImage.obtainImage(imageURL: imageLink ) { [weak self] image in
                    self?.cacheData.setObject(image ?? UIImage() , forKey: imageLink  as NSString )

                    DispatchQueue.main.async {
                        self?.mainCollection.reloadItems(at: [indexPath])
                    }
                }
            }
        return cell ??  UICollectionViewCell()
    }
    //MARK: - UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionWight = UIScreen.main.bounds.width
        return CGSize(width: collectionWight, height:  150)
    }
    //MARK: - UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let newsVC = NewsVC()
         let item = ViewModel.rssItems[indexPath.item]
         ViewModel.rssItems[indexPath.item].isRead = true
            newsVC.item = item
        
        if let cell = mainCollection.cellForItem(at: indexPath) as? MainCell {
            _ = ViewModel.rssItems[indexPath.item]
                cell.mainTitle.textColor = UIColor.orange
        }
        self.navigationController?.pushViewController(newsVC, animated: true)
    }
}
