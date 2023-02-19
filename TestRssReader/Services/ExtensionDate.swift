//
//  ExtensionDate.swift
//  TestRssReader
//
//  Created by Егор Еромин on 3.02.23.
//

import Foundation
//MARK: - Bad dateFormatter
extension Date {
    func getFormattedDate(strDate: String) -> String {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "E, dd MMM yyyy HH:mm:ss z"

        let date : Date = dateFormatterGet.date(from: strDate) ?? Date()
        print(strDate)
        dateFormatterGet.dateFormat = "dd.MMM.yyyy HH:mm"
        return dateFormatterGet.string(from: date)
    }
}
