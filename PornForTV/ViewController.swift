//
//  ViewController.swift
//  PornForTV
//
//  Created by Tomoya_Hirano on H28/01/12.
//  Copyright © 平成28年 noppefoxwolf. All rights reserved.
//

import UIKit
import Ji
import AlamofireImage

class ViewController: UIViewController {
  @IBOutlet weak var collectionView: UICollectionView!
  
  let url = "http://jp.xvideos.com"
  var contents:[Content] = []
  
  override func viewDidLoad() {
    super.viewDidLoad()
    collectionView.delegate = self
    collectionView.dataSource = self
    
    let jiDoc = Ji(htmlURL: NSURL(string: url)!)
    let thumbBlocks = jiDoc?.xPath("//div[@class='thumbBlock']")
    for thumbBlock in thumbBlocks! {
      let thumbInside = thumbBlock.xPath("div[@class='thumbInside']").first
      let thumb = thumbInside?.xPath("div[@class='thumb']").first
      let title = thumbInside?.xPath("p/a").first?.content
      let image = thumb?.xPath("a/img").first?["src"]
      guard let link  = thumbInside?.xPath("p/a").first?["href"] else {continue}
    
      let content = Content()
      content.title = title
      content.image = image
      content.link = url + link
      contents.append(content)
    }
    
    collectionView.reloadData()
  }
  
  func getDetails(content:Content){
    print(content.link)
    let jiDoc = Ji(htmlURL: NSURL(string: content.link)!)
    let scripts = jiDoc?.xPath("//script")
    for script in scripts! {
      let pattern = "new HTML5Player\\((.+?)\\)+"
      let str:String = script.content!
      if Regexp(pattern).isMatch(str) {
        if let js = Regexp(pattern).matches(str)?.first {
          let alert = UIAlertController(title: content.title,
            message: "select source",
            preferredStyle: .Alert)
          
          for data in js.componentsSeparatedByString(",") {
            let raw = data.stringByReplacingOccurrencesOfString("'", withString: "").stringByReplacingOccurrencesOfString(" ", withString: "")
            if let url = NSURL(string: raw) {
              if let _ = url.host {
                alert.addAction(UIAlertAction(title: url.absoluteString, style: .Default, handler: { (_) -> Void in
                  self.showVideoVC(url)
                }))
              }
            }
          }
          alert.addAction(UIAlertAction(title: nil, style: .Cancel, handler: nil))
          
          presentViewController(alert, animated: true, completion: nil)
        }
      }
    }
  }
  
  func showVideoVC(url:NSURL){
    let vc = VideoViewController.viewController(url)
    presentViewController(vc, animated: true, completion: nil)
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }


}

extension ViewController:UICollectionViewDelegate,UICollectionViewDataSource {
  func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
    return 1
  }
  func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return contents.count
  }
  
  func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
    let content = contents[indexPath.row]
    getDetails(content)
  }
  
  func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! CollectionCell
    let content = contents[indexPath.row]
    cell.imageView.backgroundColor = UIColor.lightGrayColor()
    if let image = content.image,url = NSURL(string: image) {
      cell.imageView.af_setImageWithURL(url)
    }
    cell.label.text = content.title
    return cell
  }
}

class CollectionCell :UICollectionViewCell{
  @IBOutlet weak var imageView: UIImageView!
  @IBOutlet weak var label: UILabel!
}


class Content:NSObject{
  var title:String?
  var image:String?
  var link  = ""
}

