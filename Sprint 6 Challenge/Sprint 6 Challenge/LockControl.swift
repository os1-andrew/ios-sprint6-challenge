//
//  LockControl.swift
//  Sprint 6 Challenge
//
//  Created by Andrew Liao on 8/31/18.
//  Copyright © 2018 Lambda School. All rights reserved.
//

import UIKit

@IBDesignable class LockControl: UIControl {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    //MARK: - Touch Handlers
    
    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        let touchPoint = touch.location(in: self)
        if lockBarBoltBounds.contains(touchPoint){
            sendActions(for: [.touchDown])
        }
        return true
    }
    override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        moveBolt(at: touch)
        
        let touchPoint = touch.location(in: self)
        
        if lockBarBounds.contains(touchPoint){
            
            let lockBarFrame = lockBarBolt.frame
            let frame = CGRect(x: touchPoint.x-lockBarBolt.frame.width/2,
                               y: lockBarFrame.origin.y,
                               width: lockBarFrame.width,
                               height: lockBarFrame.height)
            
            lockBarBolt.frame = frame
            
            if lockBarActivateBounds.contains(touchPoint){
                updateValue(at: touch)
                return false
            }
            
            sendActions(for: [.touchDragInside])
        } else {
            sendActions(for: [.touchDragOutside])
        }
        
        return true
    }
    override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        guard let touch = touch,
            let lockBarActivateBounds = lockBarActivateBounds else {return}
        let touchPoint = touch.location(in: self)
        if lockBarActivateBounds.contains(touchPoint){
            updateValue(at: touch)
        } else {
            lockBarBolt.frame = self.convert(lockBarBoltBounds, to: lockBarView)
        }
    }
    override func cancelTracking(with event: UIEvent?) {
        sendActions(for: [.touchCancel])
    }
    func moveBolt(at touch: UITouch){
        
    }
    func updateValue(at touch: UITouch){
        imageView?.image = unlockedImage
        isLocked = false
        sendActions(for: [.valueChanged])
    }
    
    func reset(){
        
        isLocked = true
        lockBarBolt.frame = self.convert(lockBarBoltBounds, to: lockBarView)
        imageView?.image = lockedImage

    }
    
    //MARK: - Build Control View
    func setup(){
        self.isUserInteractionEnabled = true
        clipsToBounds = true
        layer.cornerRadius = 16
        layer.backgroundColor = Appearance.lightSteelBlue.cgColor
        
        createImageView()
        createLockBar()
    }
    
    func createImageView(){
        let width = self.frame.width/2
        let x = width/2
        let y = width/2
        
        let frame = CGRect(x: x, y: y, width: width, height: width)
        let imageView = UIImageView(frame: frame)
        imageView.contentMode = .scaleAspectFit
        imageView.image = lockedImage
        imageView.isUserInteractionEnabled = false
        addSubview(imageView)
        self.imageView = imageView
    }
    
    func createLockBar(){
        //create Bar
        let width = self.frame.width - 16*2
        let height = self.frame.height/6
        let y = self.frame.height - height - 10
        
        let lockFrame = CGRect(x: 16, y: y, width: width, height: height)
        let lockBar = UIView(frame: lockFrame)
        lockBar.isUserInteractionEnabled = false
        lockBar.layer.backgroundColor = UIColor.white.cgColor
        lockBar.clipsToBounds = true
        lockBar.layer.cornerRadius = height/2
        addSubview(lockBar)
        
        //create bolt of lock bar
        
        let radius = lockBar.frame.height - 6
        let boltFrame = CGRect(x: 5, y: 5/2, width: radius, height: radius)
        let bolt = UIView(frame: boltFrame)
        bolt.isUserInteractionEnabled = false
        bolt.clipsToBounds = true
        bolt.layer.cornerRadius = radius/2
        bolt.layer.backgroundColor = Appearance.midnightBlue.cgColor
        lockBar.addSubview(bolt)
        
        //for use in touch handling
        let lockBarWidth = lockBar.frame.width
        let activateBounds = CGRect(x: lockBar.frame.origin.x + lockBarWidth/5*4,
                                    y: lockBar.frame.origin.y,
                                    width: lockBarWidth/5,
                                    height: lockBar.frame.height)
        
        lockBarActivateBounds = activateBounds
        let lockBarFrame = self.convert(lockBar.bounds, from: lockBar)
        lockBarBounds = CGRect(x: lockBarFrame.origin.x + radius,
                               y: lockBarFrame.origin.y,
                               width: lockBarFrame.width - radius*2,
                               height: lockBarFrame.height)
        lockBarBoltBounds = self.convert(bolt.bounds, from:bolt)
        lockBarBolt = bolt
        lockBarView = lockBar
        
    }
    
    // MARK: - Properties
    private(set) var isLocked: Bool = true
    
    private var imageView: UIImageView!
    private var lockBarBolt: UIView!
    private var lockBarView: UIView!
    private var lockBarBoltBounds: CGRect!
    private var lockBarBounds: CGRect!
    private var lockBarActivateBounds: CGRect!
    private let lockedImage = UIImage(named: "Locked")!
    private let unlockedImage = UIImage(named: "Unlocked")!
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
