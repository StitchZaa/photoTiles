//
//  ViewController.swift
//  photoTiles
//
//  Created by Stitch Zaa on 13/Oct/15.
//  Copyright © 2015 StitchZaa. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var mainPhoto: UIImageView!
    @IBOutlet weak var mainFrame: UIView!
    
//    @IBOutlet weak var scrollView: UIScrollView!
//    var scrollView:UIScrollView!
    
    var imageView:UIImageView!
    
    var leftPadding:CGFloat!
    var rightPadding:CGFloat!
    var topPadding:CGFloat!
    var bottomPadding:CGFloat!
    
    var maxWidth:CGFloat!
    var maxHeight:CGFloat!
    var minWidth:CGFloat!
    var minHeight:CGFloat!
    
    let gap: CGFloat = 10.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        /*
//        scrollView = UIScrollView(frame: containerView.frame)
        scrollView.delegate = self
        scrollView.backgroundColor = UIColor.grayColor().colorWithAlphaComponent(0.3)
        
        scrollView.minimumZoomScale = 0.5
        scrollView.maximumZoomScale = 1.0
        scrollView.zoomScale = 1.0
        
        let image:UIImage = UIImage(named: "img3")!
//        let imageView = UIImageView(image: image)
        imageView = UIImageView(image: image)
        imageView.frame = CGRect(origin: CGPoint(x: 0, y: 0), size:image.size)
        scrollView.addSubview(imageView)
        scrollView.contentSize = CGSize(width: scrollView.frame.width * 3, height: scrollView.frame.height * 3)
        
        containerView.addSubview(scrollView)
        */
        
        let panRecognizer = UIPanGestureRecognizer(target:self, action:"detectPan:")
        mainFrame.gestureRecognizers = [panRecognizer]
        
        let pinchRecognizer = UIPinchGestureRecognizer(target: self, action: "detectPinch:")
        containerView.gestureRecognizers = [pinchRecognizer]
        
        
    }
    
    override func viewDidAppear(animated: Bool) {
        let containerFrame = containerView.frame
        
        leftPadding = gap
        rightPadding = containerFrame.width - gap
        topPadding = gap
        bottomPadding = containerFrame.height - gap
        
        minWidth = 80
        minHeight = 80
        maxWidth = containerFrame.width - gap - gap
        maxHeight = containerFrame.height - gap - gap
        
        updateFrame()
    }
    
    func detectPan(recognizer:UIPanGestureRecognizer) {
        let translation  = recognizer.translationInView(containerView)
        let lastLocation = mainFrame.center
        mainFrame.center = CGPointMake(lastLocation.x + translation.x, lastLocation.y + translation.y)
        
        recognizer.setTranslation(CGPointZero, inView: containerView)
        
        updateFrame()
        
        print("detectPan: \(translation) / \(lastLocation)")
    }
    
    func detectPinch(recognizer: UIPinchGestureRecognizer) {
//        if let view = recognizer.view {
//            view.transform = CGAffineTransformScale(view.transform, recognizer.scale, recognizer.scale)
//            recognizer.scale = 1
//        }
        
        let frame = mainFrame.frame
        
        print("frame: \(frame)")
        print("left: \(leftPadding), right: \(rightPadding), top: \(topPadding), bottom: \(bottomPadding), ")
        print("minWidth: \(minWidth), maxWidth: \(maxWidth), minHeight:\(minHeight), maxHeight: \(maxHeight)")
        
        if ((frame.width < maxWidth && frame.height < maxHeight) || recognizer.scale < 1) && ((frame.width > minWidth && frame.height > minHeight) || recognizer.scale > 1) {
            mainFrame.transform = CGAffineTransformScale(mainFrame.transform, recognizer.scale, recognizer.scale)
            recognizer.scale = 1
            
            updateFrame()
        }
        
        
        print("detectPinch: \(recognizer.scale)")
    }
    
    func updateFrame () {
        
        var newFrame = mainFrame.frame
        
        if newFrame.width > maxWidth {
            newFrame.size.width = maxWidth
        }
        if newFrame.height > maxHeight {
            newFrame.size.height = maxHeight
        }
        
        if newFrame.origin.x < leftPadding {
            newFrame.origin.x = leftPadding
        }
        if (newFrame.origin.x + newFrame.width) > rightPadding {
            newFrame.origin.x = rightPadding - newFrame.width
        }
        if newFrame.origin.y < topPadding {
            newFrame.origin.y = topPadding
        }
        if (newFrame.origin.y + newFrame.height) > bottomPadding {
            newFrame.origin.y = bottomPadding - newFrame.height
        }
        
        print("newframe.origin: \(newFrame.origin)")
        
        mainFrame.frame = newFrame
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
//        return imageView
//    }
    
//    func scrollViewDidZoom(scrollView: UIScrollView) {
//        centerScrollViewContents()
//    }
//    
//    func scrollViewDidScroll(scrollView: UIScrollView) {
//        NSLog("scrolling")
//    }
//    
//    func centerScrollViewContents() {
//        print("centerScrollViewContents")
//    }

    @IBAction func onPinchFrame(sender: AnyObject) {
        
    }

    @IBAction func onPanFrame(sender: AnyObject) {
        
    }
    
    @IBAction func importPhoto(sender: AnyObject) {
        
    }

    @IBAction func exportPhoto(sender: AnyObject) {
        
    }
    
}

