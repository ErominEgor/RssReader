//
//  StructJson.swift
//  TestRssReader
//
//  Created by Егор Еромин on 1.02.23.
//

import Foundation

struct StructJson {
    var title: String
    var link: String
    var description: String
    var pubDate: String
    var enclosure: String
    var category: String
    
    var isRead: Bool
    
    enum CodingKeys: CodingKey {
        case title
        case link
        case description
        case pubDate
        case enclosure
        case category
    }
}

