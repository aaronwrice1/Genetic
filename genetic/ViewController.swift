//
//  ViewController.swift
//  genetic
//
//  Created by Aaron Rice on 8/4/17.
//  Copyright © 2017 Aaron Rice. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var boxes: [Box] = []
    var timer = Timer()
    
    let killZone: UIImageView = UIImageView(frame: CGRect(x: UIScreen.main.bounds.midX - 100,
                                                          y: UIScreen.main.bounds.midY - 100,
                                                          width: 200,
                                                          height: 200))
    
    var generation: Int = 0
    @IBOutlet weak var genLabel: UILabel!
    
    
    
    // things you can change to simulation
    let maxPopulation: Int = 20
    
    // will be changed after each generation
    var minXVelocity: CGFloat = -3
    var maxXVelocity: CGFloat = 3
    
    var minYVelocity: CGFloat = -3
    var maxYVelocity: CGFloat = 3
    
    // can't change max and min position
    // because a small range of values could be bad, not just all above a certian area
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // add squares
        for _ in 1...maxPopulation {
            
            // random pos and vel
            
            let posX = randomNumber(inRange: 0...Int(UIScreen.main.bounds.width - 50))
            let posY = randomNumber(inRange: 0...Int(UIScreen.main.bounds.height - 50))
            
            let velX = CGFloat(randomNumber(inRange: (Int(minXVelocity) * 10)...(Int(maxXVelocity) * 10))) / 10
            let velY = CGFloat(randomNumber(inRange: (Int(minYVelocity) * 10)...(Int(maxYVelocity) * 10))) / 10
            
            let box:Box = Box(imageView: UIImageView(frame:
                                        CGRect(x: posX,
                                               y: posY,
                                               width: 50,
                                               height: 50)),
                              velocity: Velocity(x: velX,
                                                 y: velY),
                              view: self.view)
            boxes.append(box)
        }

        // update timer
        timer = Timer.scheduledTimer(timeInterval: 0.033,
                                     target: self,
                                     selector: #selector(updateBoxes),
                                     userInfo: nil,
                                     repeats: true)
 
        
        genLabel.text = "Gen: \(generation)"
        
        // add kill zone (in future add more areas)
        killZone.backgroundColor = .red
        self.view.addSubview(killZone)
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func updateBoxes() {
        
        for i in 0...(boxes.count - 1) {
            
            let box = boxes[i]
            
            var curX = box.imageView.frame.minX
            var curY = box.imageView.frame.minY
            
            var velX = box.velocity.x
            var velY = box.velocity.y
            
            // check if out of bounds
            if curX + velX < 0 {
                curX = 0
                boxes[i].velocity.x = -boxes[i].velocity.x
                velX = -velX
            }
            if curX + velX + 50 > UIScreen.main.bounds.width {
                curX = UIScreen.main.bounds.width - 50
                boxes[i].velocity.x = -boxes[i].velocity.x
                velX = -velX
            }
            if curY + velY < 0{
                curY = 0
                boxes[i].velocity.y = -boxes[i].velocity.y
                velY = -velY
            }
            if curY + velY + 50 > UIScreen.main.bounds.height {
                curY = UIScreen.main.bounds.height - 50
                boxes[i].velocity.y = -boxes[i].velocity.y
                velY = -velY
            }
            
            box.imageView.frame = CGRect(x: curX + velX,
                                         y: curY + velY,
                                         width: box.imageView.frame.size.width,
                                         height: box.imageView.frame.size.height)
 
        }
 
        
    }
    
    func randomNumber<T : SignedInteger>(inRange range: ClosedRange<T> = 1...6) -> T {
        let length = (range.upperBound - range.lowerBound + 1).toIntMax()
        let value = arc4random().toIntMax() % length + range.lowerBound.toIntMax()
        return T(value)
    }
    
    @IBAction func nextButtonPressed() {
        // kill off some
        removeUnfit()
        // add new ones
        addNewSquares()
        
        // have label to keep track of generations?
        generation += 1
        genLabel.text = "Gen: \(generation)"
    }
    
    func removeUnfit(){
        
        var onesToRemove: [Int] = []
        
        // mark ones to delete
        for i in 0...(boxes.count - 1) {
            let box = boxes[i]
            
            if killZone.frame.intersects(box.imageView.frame){
                onesToRemove.append(i)
            }
        }
        
        // delete them
        for i in onesToRemove.reversed(){
            boxes[i].imageView.removeFromSuperview()
            boxes[i].imageView = nil
            boxes.remove(at: i)
        }
        
    }
    
    func addNewSquares(){
        
        let numberOfSquaresToAdd: Int = maxPopulation - boxes.count
        
        if numberOfSquaresToAdd != 0 {
            
            findNewMaxAndMins()
            
            for _ in 0...(numberOfSquaresToAdd - 1) {
                
                let posX = randomNumber(inRange: 0...Int(UIScreen.main.bounds.width - 50))
                let posY = randomNumber(inRange: 0...Int(UIScreen.main.bounds.height - 50))
                
                let velX = CGFloat(randomNumber(inRange: (Int(minXVelocity) * 10)...(Int(maxXVelocity) * 10))) / 10
                let velY = CGFloat(randomNumber(inRange: (Int(minYVelocity) * 10)...(Int(maxYVelocity) * 10))) / 10
                
                let box:Box = Box(imageView: UIImageView(frame:
                    CGRect(x: posX,
                           y: posY,
                           width: 50,
                           height: 50)),
                                  velocity: Velocity(x: velX,
                                                     y: velY),
                                  view: self.view)
                boxes.append(box)
                
            }
            
        }
        
    }
    
    func findNewMaxAndMins() {
        
        var tempMinX = boxes[0].velocity.x
        var tempMaxX = boxes[0].velocity.x
        var tempMinY = boxes[0].velocity.y
        var tempMaxY = boxes[0].velocity.y
        
        // find new min of vel x and vel y
        for box in boxes {
            
            if box.velocity.x < tempMinX {
                tempMinX = box.velocity.x
            }
            if box.velocity.x > tempMaxX {
                tempMaxX = box.velocity.x
            }
            if box.velocity.y < tempMinY {
                tempMinY = box.velocity.y
            }
            if box.velocity.y > tempMaxY {
                tempMaxY = box.velocity.y
            }
            
        }
        
        minXVelocity = tempMinX
        maxXVelocity = tempMaxX
        minYVelocity = tempMinY
        maxYVelocity = tempMaxY
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

