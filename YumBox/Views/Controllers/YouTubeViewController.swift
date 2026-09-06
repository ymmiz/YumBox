//
//  YouTubeViewController.swift
//  YumBox
//
//  Created by Zin Mie Mie Thet on 23/09/2024.
//

import UIKit
import WebKit

class YouTubeViewController: UIViewController {
    
    @IBOutlet weak var webView : WKWebView!
    var videoID = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(webView)
        let embedHTML = """
                <html>
                    <body style="margin:0px;padding:0px;">
                        <iframe width="100%" height="100%" src="https://www.youtube.com/embed/\(videoID)" frameborder="0" allowfullscreen></iframe>
                    </body>
                </html>
                """
        
        webView.loadHTMLString(embedHTML, baseURL: nil)
    }
}
