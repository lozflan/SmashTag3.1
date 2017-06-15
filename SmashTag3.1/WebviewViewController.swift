//
//  WebviewViewController.swift
//  SmashTag3.1
//
//  Created by Lawrence Flancbaum on 14/6/17.
//  Copyright © 2017 Cloudmass. All rights reserved.
//

import UIKit

class WebviewViewController: UIViewController {
    
    @IBOutlet weak var webView: UIWebView!
    
    
    var url: URL? {
        didSet {
            updateUI()
        }
    }
    
    private func updateUI() {
//        we
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
