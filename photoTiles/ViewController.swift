//
//  ViewController.swift
//  photoTiles
//
//  Created by Stitch Zaa on 13/Oct/15.
//  Copyright © 2015 StitchZaa. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var mainPhoto: UIImageView!
    @IBOutlet weak var mainFrame: UIView!
    
//    var imageView:UIImageView!
    @IBOutlet weak var imageView: UIImageView!
    
    var picker = UIImagePickerController()
    
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
        
        let panRecognizer = UIPanGestureRecognizer(target:self, action:"detectPan:")
        mainFrame.gestureRecognizers = [panRecognizer]
        
        let pinchRecognizer = UIPinchGestureRecognizer(target: self, action: "detectPinch:")
        containerView.gestureRecognizers = [pinchRecognizer]
        
        picker.delegate = self
        picker.allowsEditing = false
        picker.sourceType = .PhotoLibrary
        picker.modalPresentationStyle = UIModalPresentationStyle.OverFullScreen
    }
    
    override func viewDidAppear(animated: Bool) {
        let containerFrame = containerView.frame
        
        leftPadding = gap
        rightPadding = containerFrame.width - gap
        topPadding = gap
        bottomPadding = containerFrame.height - gap
        
        minWidth = 60
        minHeight = 60
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
        
        let frame = mainFrame.frame
        
//        printLog()
        
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
    
    func addImage(image: UIImage) {
        imageView.image = image
        print("addImage: \(imageView.frame), \(image.size)")
        
        let imageFrame = imageView.frame
        let frameWidth = imageFrame.width
        let frameHeight = imageFrame.height
        
        var imageWidth = image.size.width
        var imageHeight = image.size.height
        
        let frameRatio = frameHeight / frameWidth
        let imageRatio = imageHeight / imageWidth
        if imageRatio <= frameRatio {
            imageHeight = imageHeight / imageWidth * frameWidth
            imageWidth = frameWidth
        } else {
            imageWidth = imageWidth / imageHeight * frameHeight
            imageHeight = frameHeight
        }
        
        print("imageRatio: \(imageRatio), frameRatio: \(frameRatio)")
        
        maxWidth = imageWidth
        maxHeight = imageHeight
        
        leftPadding = (containerView.frame.width - imageWidth) / 2
        rightPadding = leftPadding + imageWidth
        topPadding = (containerView.frame.height - imageHeight) / 2
        bottomPadding = topPadding + imageHeight
        
        printLog()
    }
    
    func printLog() {
        
        print("print log")
        print("left: \(leftPadding), right: \(rightPadding), top: \(topPadding), bottom: \(bottomPadding), ")
        print("minWidth: \(minWidth), maxWidth: \(maxWidth), minHeight:\(minHeight), maxHeight: \(maxHeight)")
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage //2
        dismissViewControllerAnimated(true, completion: nil) //5
        addImage(chosenImage)
    }
    
    //What to do if the image picker cancels.
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func importPhoto(sender: AnyObject) {
        presentViewController(picker, animated: true, completion: nil)
    }

    @IBAction func exportPhoto(sender: AnyObject) {
        
    }
    
}

