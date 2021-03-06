//
//  Lesson.swift
//  Lesson
//
//  Created by Jane Appleseed on 11/10/16.
//  Copyright © 2016 Apple Inc. All rights reserved.
//

import UIKit
import os.log

class Lesson: NSObject, NSCoding {
    
    //MARK: Properties
    
    var name: String
    var caption: String
    var photo: UIImage?
    var url: String
    
    //MARK: Archiving Paths
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("lessons")
    
    //MARK: Types
    
    struct PropertyKey {
        static let name = "name"
        static let caption = "caption"
        static let photo = "photo"
        static let url = "url"
    }
    
    //MARK: Initialization
    
    init?(name: String, caption: String, photo: UIImage?, url: String) {
        
        // The name must not be empty
        guard !name.isEmpty else {
            return nil
        }

        // Initialization should fail if there is no name
        if name.isEmpty  {
            return nil
        }

        // The url must not be empty
        guard !url.isEmpty else {
            return nil
        }

        // Initialization should fail if there is no url
        if url.isEmpty  {
            return nil
        }

        // Initialize stored properties.
        self.name = name
        self.caption = caption
        self.photo = photo
        self.url = url
    }
    
    //MARK: NSCoding
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: PropertyKey.name)
        aCoder.encode(caption, forKey: PropertyKey.caption)
        aCoder.encode(photo, forKey: PropertyKey.photo)
        aCoder.encode(url, forKey: PropertyKey.url)    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        
        // The name is required. If we cannot decode a name string, the initializer should fail.
        guard let name = aDecoder.decodeObject(forKey: PropertyKey.name) as? String else {
            os_log("Unable to decode the name for a Lesson object.", log: OSLog.default, type: .debug)
            return nil
        }
        
        // The url is required. If we cannot decode a url string, the initializer should fail.
        guard let url = aDecoder.decodeObject(forKey: PropertyKey.url) as? String else {
            os_log("Unable to decode the url for a Lesson object.", log: OSLog.default, type: .debug)
            return nil
        }
        
        // Because caption is optional property of Lesson, just use a conditional cast.
        let caption = aDecoder.decodeObject(forKey: PropertyKey.caption) as! String

        // Because photo is optional property of Lesson, just use conditional cast.
        let photo = aDecoder.decodeObject(forKey: PropertyKey.photo) as? UIImage
        
        // Must call designated initializer.
        self.init(name: name, caption: caption, photo: photo, url: url)
        
    }
}
