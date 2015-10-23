//
//  SummitUIViewController.swift
//  ReadyAppRetail
//
//  Created by Trisha Hanlon on 10/23/15.
//  Copyright © 2015 IBM. All rights reserved.
//

import Foundation
class SummitUIViewController: UIViewController {
    override func viewWillAppear(animated: Bool) {
        let tracker = GAI.sharedInstance().defaultTracker
        tracker.set(kGAIScreenName, value: NSStringFromClass(self.dynamicType))
    
        let builder = GAIDictionaryBuilder.createScreenView()
        tracker.send(builder.build() as [NSObject : AnyObject])
    
        super.viewWillAppear(animated)
    }
}