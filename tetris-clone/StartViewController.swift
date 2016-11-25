//
//  StartViewController.swift
//  tetris-clone
//
//  Created by Sven Forstner on 18.11.16.
//  Copyright © 2016 Sven Forstner. All rights reserved.
//

import UIKit

class StartViewController: UIViewController {
    
    var defaults = UserDefaults.standard

    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var highScoreLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        print("**** HighScore : \(defaults.integer(forKey: "userHighscore")) ****")
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        highScoreLabel.text = "Highest Score : \(defaults.integer(forKey: "userHighscore"))"
        
        startButton.layer.borderWidth = 0.5
        startButton.layer.borderColor = UIColor.purple.cgColor
        startButton.layer.cornerRadius = 15.0
        
        isAppAlreadyLaunchedOnce()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func isAppAlreadyLaunchedOnce() {
        if let _ = defaults.string(forKey: "isAppAlreadyLaunchedOnce"){
            print("App already launched")
        }else{
            defaults.set(true, forKey: "isAppAlreadyLaunchedOnce")
            defaults.set(0, forKey: "userHighScore")
            print("App launched first time")
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    @IBAction func btnStartGame(_ sender: Any) {
        
        let vc = storyboard!.instantiateViewController(withIdentifier: "storyboardGameScene") as! GameViewController
        self.present(vc, animated: true, completion: nil)
        
    }
    
    @IBAction func btnSettings(_ sender: Any) {
        
        let vc = self.storyboard!.instantiateViewController(withIdentifier: "storyboardSettings") as! SettingsTableViewController
        
        self.present(vc, animated: true, completion: nil)
        
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }

}
