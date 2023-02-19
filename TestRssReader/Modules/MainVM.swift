//
//  MainVM.swift
//  TestRssReader
//
//  Created by Егор Еромин on 3.02.23.
//

import Foundation

protocol RssItensProtocol {
    var rssItems: [StructJson] { get set }
    var contentDidUpdate: (() -> Void)? { get set }
    func fetchData()
}

final class MainVM: RssItensProtocol {
    var rssItems: [StructJson] = []
    var contentDidUpdate: (() -> Void)?
    private var parser = Parser()
    
     func fetchData() {
        parser.parseFeed(url: "https://lenta.ru/rss/news") { [weak self] (rssItems) in
            self?.rssItems = rssItems
            DispatchQueue.main.async {
                self?.contentDidUpdate?()
            }
        }
    }
}
