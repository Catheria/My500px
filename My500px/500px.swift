//
//  500px.swift
//  My500px
//
//  Created by MailE on 7/16/17.
//  Copyright © 2017 MailE. All rights reserved.
//

import UIKit
import Foundation

class Photo500px {
    
    let previewURL: String
    let imageURL: String
    var thumbnail: UIImage?
    var image: UIImage?
    var author: String?
    var title: String?
    
    init(previewURL: String, imageURL: String) {
        self.previewURL = previewURL
        self.imageURL = imageURL
    }
    
    class func map(dict: Dictionary<String, Any>?) -> [Photo500px] {
        var arrAll = [Photo500px]()
        if let dict = dict,
            let arrPhotos = dict["photos"] as? [AnyObject] {
            for p in arrPhotos {
                if let images = p["images"] as? NSArray {
                    var previewURL: String?
                    var fullURL: String?
                    for i in images {
                        if let i = i as? NSDictionary {
                            if (i["size"] as! Int) == 30 {
                                previewURL = i.object(forKey: "url") as? String
                            }else if (i["size"] as! Int) == 2048 {
                                fullURL = i.object(forKey: "url") as? String
                            }
                        }
                    }
                    if let preview = previewURL,
                        let full = fullURL {
                        let photo = Photo500px(previewURL: preview, imageURL: full)
                        if let title = p["name"] as? String {
                            photo.title = title
                        }
                        if let user = p["user"] as? Dictionary<String, Any>,
                            let fullname = user["fullname"] as? String {
                            photo.author = fullname
                        }
                        arrAll.append(photo)
                    }
                }
            }
        }
        return arrAll
    }
    
}


extension Photo500px: Equatable {}
func ==(lhs: Photo500px, rhs: Photo500px) -> Bool {
    return lhs.previewURL == rhs.previewURL && lhs.imageURL == rhs.imageURL
}
