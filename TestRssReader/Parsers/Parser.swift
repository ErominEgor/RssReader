//
//  Parser.swift
//  TestRssReader
//
//  Created by Егор Еромин on 2.02.23.
//

import Foundation

class Parser: NSObject, XMLParserDelegate {
     var rssItems: [StructJson] = []

    private var currentElement = ""
    private var currentTitle: String = "" {
        didSet {
            currentTitle = currentTitle.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
    }
    private var currentLink: String = "" {
        didSet {
            currentLink = currentLink.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
    }
    
    private var currentDescription: String = "" {
        didSet {
            currentDescription = currentDescription.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
    }
    private var currentPubDate: String = "" {
        didSet {
            currentPubDate = currentPubDate.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
    }
    private var currentEnclosure: String = "" {
        didSet {
            currentEnclosure = currentEnclosure.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
    }
    private var currentCategory: String = "" {
        didSet {
            currentCategory = currentCategory.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
    }
    
    private var parserCompletionHandler: (([StructJson]) -> Void)?
    
    func parseFeed(url: String, completionHandler: (([StructJson]) -> Void)?) -> Void {
        self.parserCompletionHandler = completionHandler
        if let url = URL(string: url) {
            let request = URLRequest(url: url)
            let urlSession = URLSession.shared
            
            let task = urlSession.dataTask(with: request) { (data, response, error) in
                guard let data = data else {
                    if let error = error {
                        print(error)
                    }
                    return
                }
                let parser = XMLParser(data: data)
                parser.delegate = self
                parser.parse()
            }
            task.resume()
        }
    }
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:])
    {
        currentElement = elementName
        if currentElement == "enclosure" {
            currentEnclosure = attributeDict["url"] ?? ""
        }
        if currentElement == "item" {
            currentTitle = ""
            currentLink = ""
            currentDescription = ""
            currentPubDate = ""
            currentEnclosure = ""
            currentCategory = ""
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String)
    {
        switch currentElement {
        case "title": currentTitle += string
        case "link": currentLink += string
        case "description" : currentDescription += string
        case "pubDate": currentPubDate += string
        case "category": currentCategory += string
        default: break
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?)
    {
        if elementName == "item" {
            let rssItem = StructJson(title: currentTitle, link: currentLink, description: currentDescription, pubDate: currentPubDate, enclosure: currentEnclosure, category: currentCategory, isRead: false)
            rssItems += [rssItem]
        }
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        parserCompletionHandler?(rssItems)
    }
    
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        print(parseError.localizedDescription)
    }
}
