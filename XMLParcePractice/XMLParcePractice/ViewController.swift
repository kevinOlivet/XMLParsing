//
//  ViewController.swift
//  XMLParcePractice
//
//  Created by Jon Olivet on 5/30/17.
//  Copyright © 2017 Jon Olivet. All rights reserved.
//

import UIKit

class Item {
    var author = "";
    var desc = "";
    var tag = [Tag]();
}

class Tag {
    var name = "";
    var count: Int?;
}

class ViewController: UIViewController, XMLParserDelegate {
 
    var items = [Item]();
    var item = Item();
    var foundCharacters = "";
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let path = Bundle.main.url(forResource: "newPractice", withExtension: "xml") {
            if let parser = XMLParser(contentsOf: path) {
                parser.delegate = self
                parser.parse()
            }
        }
        
//        let xmlData = xmlString.dataUsingEncoding(NSUTF8StringEncoding)!
//        let parser = XMLParser(data: xmlData)
//        
//        parser.delegate = self;
//        
//        parser.parse()
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        if elementName == "tag" {
            let tempTag = Tag();
            if let name = attributeDict["name"] {
                tempTag.name = name;
            }
            if let c = attributeDict["count"] {
                if let count = Int(c) {
                    tempTag.count = count;
                }
            }
            self.item.tag.append(tempTag);
        }
    }

    func parser(_ parser: XMLParser, foundCharacters string: String) {
        self.foundCharacters += string;
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "author" {
            self.item.author = self.foundCharacters;
        }
        
        if elementName == "description" {
            self.item.desc = self.foundCharacters;
        }
        
        if elementName == "item" {
            let tempItem = Item();
            tempItem.author = self.item.author;
            tempItem.desc = self.item.desc;
            tempItem.tag = self.item.tag;
            self.items.append(tempItem);
            self.item.tag.removeAll();
        }
        self.foundCharacters = ""
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        for item in self.items {
            print("\(item.author)\n\(item.desc)");
            for tags in item.tag {
                if let count = tags.count {
                    print("\(tags.name), \(count)")
                } else {
                    print("\(tags.name)")
                }
            }
            print("\n")
        }
    }

}

