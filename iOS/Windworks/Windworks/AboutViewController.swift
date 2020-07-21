//
//  AboutViewController.swift
//  Windworks
//
//  Created by Dave Boyce on 7/12/20.
//  Copyright © 2020 Apple Inc. All rights reserved.
//

import UIKit
import WebKit

class AboutViewController: UIViewController {

    @IBOutlet weak var aboutWebView: WKWebView!
    
    let windworksURL = "https://www.windworkssailing.com/contact/"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        sendRequest(urlString: windworksURL)
    }
    
    private func sendRequest(urlString: String) {
        let myURL = URL(string: urlString)
        let myRequest = URLRequest(url:myURL!)
        
            aboutWebView.load(myRequest)
    }
}
