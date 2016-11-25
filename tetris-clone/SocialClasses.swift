//
//  SocialClasses.swift
//  tetris-clone
//
//  Created by Sven Forstner on 19.11.16.
//  Copyright © 2016 Sven Forstner. All rights reserved.
//

import Foundation
import Social

func openShare(opener: UIViewController, message: String, image: Data? = nil, url : String) {
    let vc = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
    //vc.view.tintColor = UIColor.init(red: 25/255, green: 143/255, blue: 163/255, alpha: 1)
    
    let facebookAction = UIAlertAction(title: "Share on facebook", style: .default, handler: {(alert: UIAlertAction!) -> Void in
        
        if let facebookVC = SLComposeViewController(forServiceType: SLServiceTypeFacebook) {
            facebookVC.setInitialText(message)
            facebookVC.add(URL(string: url))
            opener.present(facebookVC, animated: true)
        }
    })
    
    let twitterAction = UIAlertAction(title: "Share on twitter", style: .default, handler: {(alert: UIAlertAction!) -> Void in
        
        if let twitterVC = SLComposeViewController(forServiceType: SLServiceTypeTwitter) {
            twitterVC.setInitialText(message)
            twitterVC.add(URL(string: url))
            opener.present(twitterVC, animated: true)
        }
    })
    
    
    
    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { (alert: UIAlertAction!) -> Void in
        print("Cancelled")
    })
    
    vc.addAction(facebookAction)
    vc.addAction(twitterAction)
    vc.addAction(cancelAction)
    
    opener.present(vc, animated: true, completion: nil)
}
