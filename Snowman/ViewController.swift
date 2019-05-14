
//  Copyright © 2019 Maxim Lakhmakou. All rights reserved.

import UIKit

class ViewController: UIViewController {
  
  @IBOutlet weak var snowman: Snowman!
  

  override func viewDidLoad() {
    super.viewDidLoad()
    addTapGesture()
    addPinchGesture()
    addUpSwipeGesture()
    addDownSwipeGesture()
    addRightSwipeGesture()
    addLeftSwipeGesture()
    
  }

  private func addTapGesture() {
    let tap = UITapGestureRecognizer(target: snowman, action: #selector(snowman.handleTap))
    tap.numberOfTapsRequired = 1
    
    snowman.addGestureRecognizer(tap)
  }

  private func addPinchGesture() {
    let pinch = UIPinchGestureRecognizer(target: snowman, action: #selector(snowman.handleScale))
    
    snowman.addGestureRecognizer(pinch)
  }
  
  private func addUpSwipeGesture() {
    let swipe = UISwipeGestureRecognizer(target: snowman, action: #selector(snowman.handleSwipe))
    swipe.direction = .up
    snowman.addGestureRecognizer(swipe)
  }
  private func addDownSwipeGesture() {
    let swipe = UISwipeGestureRecognizer(target: snowman, action: #selector(snowman.handleSwipe))
    swipe.direction = .down
    snowman.addGestureRecognizer(swipe)
  }
  private func addRightSwipeGesture() {
    let swipe = UISwipeGestureRecognizer(target: snowman, action: #selector(snowman.handleSwipe))
    swipe.direction = .right
    snowman.addGestureRecognizer(swipe)
  }
  private func addLeftSwipeGesture() {
    let swipe = UISwipeGestureRecognizer(target: snowman, action: #selector(snowman.handleSwipe))
    swipe.direction = .left
    snowman.addGestureRecognizer(swipe)
  }
}

