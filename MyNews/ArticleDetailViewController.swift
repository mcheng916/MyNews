//
//  ArticleDetailViewController.swift
//  MyNews
//
//  Created by Michael Cheng on 30/04/2017.
//  Copyright © 2017 Michael Cheng. All rights reserved.
//

import UIKit

class ArticleDetailViewController: UIViewController {
    @IBOutlet weak var newsImageView: UIImageView!
    @IBOutlet weak var newsTitleLabel: UILabel!
    @IBOutlet weak var publishedDateLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    let dateFormatter = DateFormatter()
    
    
    var article: Article!
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        debugPrint(article)
        newsTitleLabel.text = article.heading
        dateFormatter.dateFormat = "yyyy/MM/dd HH:mm"
//        let publishedDateMS = article["publishedDate"] as! Double
//        let publishedDate = Date(timeIntervalSince1970: publishedDateMS / 1000)
        let publishedDateString = dateFormatter.string(from: article.publishedDate)
        publishedDateLabel.text = publishedDateString
        contentLabel.text = article.content
        
        //http://stackoverflow.com/questions/24991713/how-to-add-an-action-to-share-button-in-navigation-bar-with-xcode
        let shareButton: UIBarButtonItem = UIBarButtonItem.init(barButtonSystemItem:.action, target: self, action: #selector(shareButtonTapped))

        self.navigationItem.rightBarButtonItem = shareButton
        downloadImage()
    }
    
    func downloadImage (){
        article.downloadImage { image, error in
            guard let image = image else{
                print("image download failure")
                return
            }
            DispatchQueue.main.async {
                self.newsImageView.image = image
            }
        }
    }
    

    func shareButtonTapped (){
        
        print ("share button pressed")
        //http://swiftdeveloperblog.com/actionsheet-example-in-swift/
        let shareActionSheet = UIAlertController(title: "Share", message: "How would you like to share?", preferredStyle: .actionSheet)
        
        let url = self.article.url
        
        //http://stackoverflow.com/questions/38416182/swift3-add-button-with-code
        let copyLinkButton = UIAlertAction(title: "Copy link", style: .default) { action -> Void in
            print("copy")
            //http://stackoverflow.com/questions/24670290/how-to-copy-text-to-clipboard-pasteboard-with-swift
            UIPasteboard.general.string = url
        }
        
        let openInSafariButton = UIAlertAction(title: "Open in Safari", style: .default) { action -> Void in
            print("safari")
            //http://stackoverflow.com/questions/25945324/swift-open-link-in-safari
            UIApplication.shared.open( URL(string: url)!, options: ["": ""], completionHandler: nil)
        }
        
        let shareInLineButton = UIAlertAction(title: "Share via Line", style: .default, handler: { (action) -> Void in
            print("line")
            //http://adison.logdown.com/notes/161413/ios-community-share-fb-naver-line
            UIApplication.shared.open( URL(string: ("line://msg/text/" + url))!, options: ["": ""], completionHandler: nil)
        })
        
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) -> Void in
            print("cancel")
        })
        
        shareActionSheet.addAction(copyLinkButton)
        shareActionSheet.addAction(openInSafariButton)
        shareActionSheet.addAction(shareInLineButton)
        shareActionSheet.addAction(cancelButton)
        
        present(shareActionSheet, animated: false, completion: nil)
    }
//after implementation of Article class
//        if let imageURL = article.imageURL {
//            let session = URLSession.shared
//            let task = session.dataTask(with: imageURL) { data, response, error  in
//                guard let data = data else{
//                    print("image download error")
//                    return
//                }
//                //3. after downloading, convert the data to UIImage
//                let image = UIImage(data: data)
//                //4. show UIImage with ImageView
//                print("downloading image")
//                DispatchQueue.main.async {
//                    self.newsImageView.image = image
//                }
//            }
//            //2. execute data task
//            task.resume()
//        }

//before implementation of Article class
//        //0. confirm there is existing image
//        if let imageURL = article["imageUrl"] as? String{
//        //1. create data task to download from URL
//            let session = URLSession.shared
//            let url = URL(string: imageURL)!
//            let task = session.dataTask(with: url) { data, response, error  in
//                guard let data = data else{
//                    print("image download error")
//                    return
//                }
//                //3. after downloading, convert the data to UIImage
//                let image = UIImage(data: data)
//                //4. show UIImage with ImageView
//                print("downloading image")
//                DispatchQueue.main.async {
//                    self.newsImageView.image = image
//                }
//            }
//            //2. execute data task
//            task.resume()
//            }
//        }
}
