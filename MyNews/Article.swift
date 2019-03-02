//
//  Article.swift
//  MyNews
//
//  Created by Michael Cheng on 01/05/2017.
//  Copyright © 2017 Michael Cheng. All rights reserved.
//

import UIKit

class Article {
    //use let since the data was downloaded, and not subject to change
    let category: String?
    let content: String?
    let heading: String?
    let imageURL: URL?
    let publishedDate: Date
    let url: String
    
    init(jsonObject: [String: Any]){
        category = jsonObject["category"] as? String
        content = jsonObject["content"] as? String
        heading = jsonObject["heading"] as? String
        if let imageURLString =  jsonObject["imageUrl"] as? String, let imageURL = URL(string: imageURLString) {
            // since the coding uses image URL
            print("image URL ok")
            self.imageURL = imageURL
        }else{
            print("image URL nok")
            imageURL = nil
        }
        
        let publishedDateMS = jsonObject["publishedDate"] as! Double
        publishedDate = Date(timeIntervalSince1970: publishedDateMS / 1000)
        url = jsonObject["url"] as! String
        
        
    }
    
    //class function is okay since no instance is needed
    class func downloadArticle(completionHandler: @escaping ([Article]?, Error?) -> Void) {
        let session = URLSession.shared
        let url = URL(string: "https://hpd-iosdev.firebaseio.com/news/latest.json")!
        let task = session.dataTask(with: url) { data, response, error in
            guard let data = data, let jsonObject = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers), let articles = jsonObject as? [[String: Any]] else{
                print("error during downloading news")
                completionHandler (nil, error)
                return
            }
            print("download successful")
            let articleObjects = articles.map{ Article(jsonObject: $0) }
            completionHandler(articleObjects, nil)
        }
        task.resume()
    }
    
    //instance method - download image
    func downloadImage (completionhandler: @escaping (UIImage?, Error?)-> Void ) {
        if let imageURL = imageURL {
            let session = URLSession.shared
            let task = session.dataTask(with: imageURL) { data, response, error in
                guard let data = data else {
                    print ("download failure")
                    completionhandler(nil, error)
                    return
                }
                let image = UIImage(data: data)
                completionhandler (image, nil)
            }
            task.resume()
        }
    }
}
