//
//  GameViewController.swift
//  tetris-clone
//
//  Created by Sven Forstner on 23.10.16.
//  Copyright © 2016 Sven Forstner. All rights reserved.
//

import UIKit
import GameplayKit
import SpriteKit
import Social

class GameViewController: UIViewController, SwiftrisDelegate, UIGestureRecognizerDelegate {
    
    
    
    var iPhoneType = iPhoneTypeSize().iphoneType()
    
    var defaults = UserDefaults.standard
    
    var scene: GameScene!
    var swiftris:Swiftris!
    
    var panPointReference:CGPoint?
    
    @IBOutlet weak var scoreLabel: LabelWithAdaptiveTextHeight!
    @IBOutlet weak var levelLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "Background-3x")!)
        
        print(iPhoneType)
        
        // Configure the view.
        let skView = view as! SKView
        skView.isMultipleTouchEnabled = false
        
        // Create and configure the scene.
        scene = GameScene(size: skView.bounds.size)
        scene.scaleMode = .aspectFill
        // #13
        scene.tick = didTick
        
        swiftris = Swiftris()
        swiftris.delegate = self 
        swiftris.beginGame()
        
        // Present the scene.
        skView.presentScene(scene)
        
        
        // Tap Gesture
        let didTap = UITapGestureRecognizer()
        didTap.delegate = self
        self.view.addGestureRecognizer(didTap)
        didTap.addTarget(self, action: #selector(rotate))
        
        // Pan Gesture 
        
        let didPan = UIPanGestureRecognizer()
        didPan.delegate = self
        self.view.addGestureRecognizer(didPan)
        didPan.addTarget(self, action: #selector(pan))
        
        // Swipe Gesture
        
        let downSwipe = UISwipeGestureRecognizer()
        downSwipe.delegate = self
        self.view.addGestureRecognizer(downSwipe)
        downSwipe.addTarget(self, action: #selector(swipeDown))
        
        downSwipe.direction = .down
        
    }
    
    //Gestures
    
    func rotate(_sender: UITapGestureRecognizer) {
        swiftris.rotateShape()
    }
    
    func pan(_sender: UIPanGestureRecognizer) {
        
        let currentPoint = _sender.translation(in: self.view)
        if let originalPoint = panPointReference {
            // #3
            if abs(currentPoint.x - originalPoint.x) > (BlockSize * 0.9) {
                // #4
                if _sender.velocity(in: self.view).x > CGFloat(0) {
                    swiftris.moveShapeRight()
                    panPointReference = currentPoint
                } else {
                    swiftris.moveShapeLeft()
                    panPointReference = currentPoint
                }
            }
        } else if _sender.state == .began {
            panPointReference = currentPoint
        }
        
    }
    
    func swipeDown(_sender: UISwipeGestureRecognizer) {
        if (_sender.direction == .down) {
            swiftris.dropShape()
        }
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    // #6
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer is UISwipeGestureRecognizer {
            if otherGestureRecognizer is UIPanGestureRecognizer {
                return true
            }
        } else if gestureRecognizer is UIPanGestureRecognizer {
            if otherGestureRecognizer is UITapGestureRecognizer {
                return true
            }
        }
        return false
    }
    
        
    // #15
    func didTick() {
        swiftris.letShapeFall()
    }
    
    func nextShape() {
        let newShapes = swiftris.newShape()
        guard let fallingShape = newShapes.fallingShape else {
            return
        }
        self.scene.addPreviewShapeToScene(shape: newShapes.nextShape!) {}
        self.scene.movePreviewShape(shape: fallingShape) {
            // #16
            self.view.isUserInteractionEnabled = true
            self.scene.startTicking()
        }
    }
    
    func gameDidBegin(swiftris: Swiftris) {
        
        print("**** Game Did Begin ****")
        
        levelLabel.text = "\(swiftris.level)"
        scoreLabel.text = "\(swiftris.score)"
        scene.tickLengthMillis = TickLengthLevelOne
        
        // The following is false when restarting a new game
        if swiftris.nextShape != nil && swiftris.nextShape!.blocks[0].sprite == nil {
            scene.addPreviewShapeToScene(shape: swiftris.nextShape!) {
                self.nextShape()
            }
        } else {
            nextShape()
        }
    }
    
    func gameDidEnd(swiftris: Swiftris) {
        
        print("**** Game Did End ****")
        
        if defaults.integer(forKey: "userHighscore") < Int(self.scoreLabel.text!)! {
            defaults.set(Int(self.scoreLabel.text!), forKey: "userHighscore")
        }
        
        view.isUserInteractionEnabled = false
        scene.stopTicking()
        
        scene.playSound(sound: "Sounds/gameover.mp3")
        
        let alert = UIAlertController(title: "GAME OVER!", message: "Your SCORE : \(self.scoreLabel.text!)", preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "Try Again!", style: UIAlertActionStyle.default, handler: { action in
            self.scene.animateCollapsingLines(linesToRemove: swiftris.removeAllBlocks(), fallenBlocks: swiftris.removeAllBlocks()) {
                swiftris.beginGame()
            }

            print("New Game")
            
        }))
        
        alert.addAction(UIAlertAction(title: "Share Highscore", style: UIAlertActionStyle.default, handler: { action in
            
            openShare(opener: self, message: "share", url: "")
            
            print("Share Highscore")
            
        }))
        
        alert.addAction(UIAlertAction(title: "End Game", style: UIAlertActionStyle.destructive, handler: { action in
            
            let vc = self.storyboard!.instantiateViewController(withIdentifier: "storyboardStartScene") as! StartViewController
            self.present(vc, animated: true, completion: nil)
            
            print("game ended")
            
        }))
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func gameDidLevelUp(swiftris: Swiftris) {
        levelLabel.text = "\(swiftris.level)"
        if scene.tickLengthMillis >= 100 {
            scene.tickLengthMillis -= 100
        } else if scene.tickLengthMillis > 50 {
            scene.tickLengthMillis -= 50
        }
        scene.playSound(sound: "Sounds/levelup.mp3")
    }
    
    func gameShapeDidDrop(swiftris: Swiftris) {
        scene.stopTicking()
        scene.redrawShape(shape: swiftris.fallingShape!) {
            swiftris.letShapeFall()
        }
        
        scene.playSound(sound: "Sounds/drop.mp3")
    }
    
    func gameShapeDidLand(swiftris: Swiftris) {
        scene.stopTicking()
        
        self.view.isUserInteractionEnabled = false
        
        let removedLines = swiftris.removeCompletedLines()
        if removedLines.linesRemoved.count > 0 {
            self.scoreLabel.text = "\(swiftris.score)"
            scene.animateCollapsingLines(linesToRemove: removedLines.linesRemoved, fallenBlocks:removedLines.fallenBlocks) {
                // #11
                self.gameShapeDidLand(swiftris: swiftris)
            }
            scene.playSound(sound:  "Sounds/bomb.mp3")
        } else {
            nextShape()
        }
    }
    
    // #17
    func gameShapeDidMove(swiftris: Swiftris) {
        scene.redrawShape(shape: swiftris.fallingShape!) {}
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}
