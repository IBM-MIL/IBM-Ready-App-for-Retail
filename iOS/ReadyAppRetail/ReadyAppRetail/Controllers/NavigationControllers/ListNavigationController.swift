//
//  ListNavigationController.swift
//  ReadyAppRetail
//
//  Created by Alex Buck on 8/4/15.
//  Copyright (c) 2015 IBM. All rights reserved.
//

import UIKit

class ListNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.navigationBar.barTintColor = UIColor.summitMainColor()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
