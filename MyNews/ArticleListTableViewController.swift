//
//  ArticleListTableViewController.swift
//  MyNews
//
//  Created by Michael Cheng on 27/04/2017.
//  Copyright © 2017 Michael Cheng. All rights reserved.
//

import UIKit

class ArticleListTableViewController: UITableViewController {
    
    
    var articles: [Article] = []
    //either of the following can be used to declare before refracture
    //var articles: [[String: Any]] = []
    //var articles = [[String: Any]]()
    
    let dateFormatter = DateFormatter()
    
    
    override func viewDidLoad() {
        print("viewDidLoad starts")
        super.viewDidLoad()
        downloadArticles()
    }

    func downloadArticles(){
        Article.downloadArticle { articles, error in
            guard let articles = articles else{
                print("download failure")
                return
            }
            self.articles = articles
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
        }
//        let session = URLSession.shared
//        //in swift, the URL is a class
//        let url = URL(string: "https://hpd-iosdev.firebaseio.com/news/latest.json")!
//        let task = session.dataTask(with: url) { data, response, error in
////            debugPrint(data)
//            guard let data = data, let jsonObject = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers), let articles = jsonObject as? [[String: Any]] else{
//                print("error during downloading news")
//                return
//            }
//            print("download successful")
//            //downloaded data after jsonSerialisation is [[String : Any]]
//            self.articles = articles.map { Article(jsonObject: $0) }
//            DispatchQueue.main.async {
//                self.tableView.reloadData()
//            }
////            for article in articles {
////                let heading = article["heading"] as? String
////                let content = article["content"] as? String
////                debugPrint (article["heading"])
////            }
////debugPrint(jsonObject)
//        }
//        //only if the task is resumed that the completion handler is carried out
//        task.resume()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("how many are there")
        debugPrint(articles.count)
        return articles.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ArticleCell", for: indexPath)
        let article = articles[indexPath.row]
        cell.textLabel?.text = article.heading
        
//        let publishedDateMS = article["publishedDate"] as! Double
//        let publishedDate = Date(timeIntervalSince1970: publishedDateMS / 1000)
//        //debugPrint(publishedDate)
        dateFormatter.dateFormat = "yyyy/MM/dd HH:mm"
        let publishedDateString = dateFormatter.string(from: article.publishedDate)
        cell.detailTextLabel?.text = publishedDateString
        return cell
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail"{
            //get ArticleDetailViewController object
            let detailVC = segue.destination as! ArticleDetailViewController
            //get the transfer article dictionary
            let cell = sender as! UITableViewCell
            let indexPath = tableView.indexPath(for: cell)!
            let article = articles [indexPath.row]
            //transfer article dictionary to ArticleDetailViewController
            detailVC.article = article
        }
    }
    
}
