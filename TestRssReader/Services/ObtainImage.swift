//
//  ObtainImage.swift
//  TestRssReader
//
//  Created by Егор Еромин on 2.02.23.
//

import Foundation
import UIKit

final class ObtainImage {
    func obtainImage(imageURL: String, completion: @escaping (UIImage?) -> Void) {
        if let imageURL = URL(string: imageURL) {
            URLSession.shared.dataTask(with: imageURL) { data, response, error in
                if let imageData = data {
                    let imageFromData = UIImage(data: imageData)
                    completion(imageFromData)
                }
            }.resume()
        }
    }
}
