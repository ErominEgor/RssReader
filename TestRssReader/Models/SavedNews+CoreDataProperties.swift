//
//  SavedNews+CoreDataProperties.swift
//  TestRssReader
//
//  Created by Егор Еромин on 3.02.23.
//
//

import Foundation
import CoreData


extension SavedNews {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SavedNews> {
        return NSFetchRequest<SavedNews>(entityName: "SavedNews")
    }

    @NSManaged public var pubDateNews: String?
    @NSManaged public var image: String?
    @NSManaged public var titleNews: String?
    @NSManaged public var descriptionNews: String?
}

extension SavedNews : Identifiable {

}
