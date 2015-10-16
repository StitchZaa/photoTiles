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
    @IBOutlet weak var invisibleFrame: UIView!
    
//    var imageView:UIImageView!
    @IBOutlet weak var imageView: UIImageView!
    
    var picker = UIImagePickerController()
    
    var leftPadding:CGFloat!
    var rightPadding:CGFloat!
    var topPadding:CGFloat!
    var bottomPadding:CGFloat!
    
    var leftConstrainMainFrame:NSLayoutConstraint!
    var rightConstrainMainFrame:NSLayoutConstraint!
    var topConstrainMainFrame:NSLayoutConstraint!
    var bottomConstrainMainFrame:NSLayoutConstraint!
    
    var startXMainFrame:CGFloat!
    var endXMainFrame:CGFloat!
    var startYMainFrame:CGFloat!
    var endYMainFrame:CGFloat!
    
    var leftConstrainInviFrame:NSLayoutConstraint!
    var rightConstrainInviFrame:NSLayoutConstraint!
    var topConstrainInviFrame:NSLayoutConstraint!
    var bottomConstrainInviFrame:NSLayoutConstraint!
    
    var startXInvisibleFrame:CGFloat!
    var endXInvisibleFrame:CGFloat!
    var startYInvisibleFrame:CGFloat!
    var endYInvisibleFrame:CGFloat!
    
    var maxWidth:CGFloat!
    var maxHeight:CGFloat!
    var minWidth:CGFloat!
    var minHeight:CGFloat!
    
    var isFirstTimeUpdatePosition:Bool! = true
    
    var aspectRatio:CGFloat = 1.0 // height / width
    
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
        
        leftConstrainInviFrame = NSLayoutConstraint(item: invisibleFrame, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: containerView, attribute: NSLayoutAttribute.Leading, multiplier: 1, constant: leftPadding)
        rightConstrainInviFrame = NSLayoutConstraint(item: containerView, attribute: NSLayoutAttribute.Trailing, relatedBy: NSLayoutRelation.Equal, toItem: invisibleFrame, attribute: NSLayoutAttribute.Trailing, multiplier: 1, constant: leftPadding)
        topConstrainInviFrame = NSLayoutConstraint(item: invisibleFrame, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: containerView, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: topPadding)
        bottomConstrainInviFrame = NSLayoutConstraint(item: containerView, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: invisibleFrame, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: topPadding)
        
//        containerView.addConstraint(leftConstrainInviFrame)
//        containerView.addConstraint(rightConstrainInviFrame)
//        containerView.addConstraint(topConstrainInviFrame)
//        containerView.addConstraint(bottomConstrainInviFrame)
        
        startXMainFrame = containerFrame.width * 0.5 - 100
        endXMainFrame = containerFrame.width * 0.5 + 100
        startYMainFrame = containerFrame.height * 0.5 - 100
        endYMainFrame = containerFrame.height * 0.5 + 100
        
        printFrameLog()
        
//        let mainFrame = UIView()
//        containerView.addSubview(mainFrame)
        mainFrame.backgroundColor = UIColor.blueColor()
        
        leftConstrainMainFrame = NSLayoutConstraint(item: mainFrame, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: containerView, attribute: NSLayoutAttribute.Leading, multiplier: 1, constant: startXMainFrame)
        rightConstrainMainFrame = NSLayoutConstraint(item: containerView, attribute: NSLayoutAttribute.Trailing, relatedBy: NSLayoutRelation.Equal, toItem: mainFrame, attribute: NSLayoutAttribute.Trailing, multiplier: 1, constant: startXMainFrame)
        topConstrainMainFrame = NSLayoutConstraint(item: mainFrame, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: containerView, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: startYMainFrame)
        bottomConstrainMainFrame = NSLayoutConstraint(item: containerView, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: mainFrame, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: startYMainFrame)
        
//        containerView.addConstraint(leftConstrainMainFrame)
//        containerView.addConstraint(rightConstrainMainFrame)
//        containerView.addConstraint(topConstrainMainFrame)
//        containerView.addConstraint(bottomConstrainMainFrame)
        
//        leftConstrainMainFrame.priority = 800
//        rightConstrainMainFrame.priority = 800
//        topConstrainMainFrame.priority = 800
//        bottomConstrainMainFrame.priority = 800
//        leftConstrainInviFrame.priority = 800
//        rightConstrainInviFrame.priority = 800
//        topConstrainInviFrame.priority = 800
//        bottomConstrainInviFrame.priority = 800
        
        
//                containerView.addConstraints([leftConstrainMainFrame, rightConstrainMainFrame, topConstrainMainFrame, bottomConstrainMainFrame, leftConstrainInviFrame, rightConstrainInviFrame, topConstrainInviFrame, bottomConstrainInviFrame])
        containerView.addConstraints([leftConstrainMainFrame, rightConstrainMainFrame, topConstrainMainFrame, bottomConstrainMainFrame])
//        containerView.addConstraints([leftConstrainInviFrame, rightConstrainInviFrame, topConstrainInviFrame, bottomConstrainInviFrame])
        
        printFrameLog()
        
//        updatePosition()
        
    }
    
    func temp1 (){
        
        leftConstrainInviFrame = NSLayoutConstraint(item: containerView, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: invisibleFrame, attribute: NSLayoutAttribute.Leading, multiplier: 1, constant: leftPadding)
        rightConstrainInviFrame = NSLayoutConstraint(item: containerView, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: invisibleFrame, attribute: NSLayoutAttribute.Trailing, multiplier: 1, constant: rightPadding)
        topConstrainInviFrame = NSLayoutConstraint(item: containerView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: invisibleFrame, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: topPadding)
        bottomConstrainInviFrame = NSLayoutConstraint(item: containerView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: invisibleFrame, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: bottomPadding)
        
        leftConstrainMainFrame = NSLayoutConstraint(item: containerView, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: mainFrame, attribute: NSLayoutAttribute.Leading, multiplier: 1, constant: startXMainFrame)
        rightConstrainMainFrame = NSLayoutConstraint(item: containerView, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: mainFrame, attribute: NSLayoutAttribute.Trailing, multiplier: 1, constant: endXMainFrame)
        topConstrainMainFrame = NSLayoutConstraint(item: containerView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: mainFrame, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: startYMainFrame)
        bottomConstrainMainFrame = NSLayoutConstraint(item: containerView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: mainFrame, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: endYMainFrame)
    }
    
    func viewDidAppear1(animated: Bool) {
        let containerFrame = containerView.frame
        
        leftPadding = gap
        rightPadding = containerFrame.width - gap
        topPadding = gap
        bottomPadding = containerFrame.height - gap
        
        minWidth = 60
        minHeight = 60
        maxWidth = containerFrame.width - gap - gap
        maxHeight = containerFrame.height - gap - gap
        
        leftConstrainInviFrame = NSLayoutConstraint(item: invisibleFrame, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: containerView, attribute: NSLayoutAttribute.Leading, multiplier: 1, constant: leftPadding)
        rightConstrainInviFrame = NSLayoutConstraint(item: invisibleFrame, attribute: NSLayoutAttribute.Trailing, relatedBy: NSLayoutRelation.Equal, toItem: containerView, attribute: NSLayoutAttribute.Leading, multiplier: 1, constant: rightPadding)
        topConstrainInviFrame = NSLayoutConstraint(item: invisibleFrame, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: containerView, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: topPadding)
        bottomConstrainInviFrame = NSLayoutConstraint(item: invisibleFrame, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: containerView, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: bottomPadding)
        
        containerView.addConstraint(leftConstrainInviFrame)
        containerView.addConstraint(rightConstrainInviFrame)
        containerView.addConstraint(topConstrainInviFrame)
        containerView.addConstraint(bottomConstrainInviFrame)
        
        startXMainFrame = containerFrame.width * 0.5 - 100
        endXMainFrame = containerFrame.width * 0.5 + 100
        startYMainFrame = containerFrame.height * 0.5 - 100
        endYMainFrame = containerFrame.height * 0.5 + 100
        
        printFrameLog()
        
        
        leftConstrainMainFrame = NSLayoutConstraint(item: mainFrame, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: containerView, attribute: NSLayoutAttribute.Leading, multiplier: 1, constant: startXMainFrame)
        rightConstrainMainFrame = NSLayoutConstraint(item: mainFrame, attribute: NSLayoutAttribute.Trailing, relatedBy: NSLayoutRelation.Equal, toItem: containerView, attribute: NSLayoutAttribute.Leading, multiplier: 1, constant: endXMainFrame)
        topConstrainMainFrame = NSLayoutConstraint(item: mainFrame, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: containerView, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: startYMainFrame)
        bottomConstrainMainFrame = NSLayoutConstraint(item: mainFrame, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: containerView, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: endYMainFrame)
        
        containerView.addConstraint(leftConstrainMainFrame)
        containerView.addConstraint(rightConstrainMainFrame)
        containerView.addConstraint(topConstrainMainFrame)
        containerView.addConstraint(bottomConstrainMainFrame)
        
        
        printFrameLog()
        
        updatePosition()
        
    }
    
    func detectPan(recognizer:UIPanGestureRecognizer) {
        let translation  = recognizer.translationInView(containerView)
        let lastLocation = mainFrame.center
        print("mainFrame.origin 1: \(mainFrame.frame.origin)")
//        mainFrame.center = CGPointMake(lastLocation.x + translation.x, lastLocation.y + translation.y)
        startXMainFrame = startXMainFrame + translation.x
        startYMainFrame = startYMainFrame + translation.y
        endXMainFrame = endXMainFrame + translation.x
        endYMainFrame = endYMainFrame + translation.y
        
        recognizer.setTranslation(CGPointZero, inView: containerView)
        
        print("mainFrame.origin 2: \(mainFrame.frame.origin)")
        print("detectPan: \(translation) / \(lastLocation)")
//        updateScale()
        updatePosition()
        
    }
    
    func detectPinch(recognizer: UIPinchGestureRecognizer) {
        
        let frame = mainFrame.frame
        print("detectPinch frame: \(frame)")
//        printLog()
        
        if ((frame.width < maxWidth && frame.height < maxHeight) || recognizer.scale < 1) && ((frame.width > minWidth && frame.height > minHeight) || recognizer.scale > 1) {
            mainFrame.transform = CGAffineTransformScale(mainFrame.transform, recognizer.scale, recognizer.scale)
            recognizer.scale = 1
            
            updateScale()
            updatePosition()
        }
        
        
        print("detectPinch scale: \(recognizer.scale)")
    }
    
    func updateScale() {
        
//        var newFrame = mainFrame.frame
        
        if (endXMainFrame - startXMainFrame) > maxWidth {
            endXMainFrame = maxWidth + startXMainFrame
            endYMainFrame = round(maxWidth * aspectRatio) + startYMainFrame
        }
        if (endYMainFrame - startYMainFrame) > maxHeight {
            endYMainFrame = maxHeight + startYMainFrame
            endXMainFrame = round(maxHeight / aspectRatio) + startXMainFrame
        }
        
        updateConstrain()
//        print("updateScale: \(newFrame.size)")
        
//        mainFrame.frame = newFrame
        
        
    }
    
    func updateScale1() {
        
        var newFrame = mainFrame.frame
        
        if newFrame.width > maxWidth {
            newFrame.size.width = maxWidth
            newFrame.size.height = round(maxWidth * aspectRatio)
        }
        if newFrame.height > maxHeight {
            newFrame.size.height = maxHeight
            newFrame.size.width = round(maxHeight / aspectRatio)
        }
        
        print("updateScale: \(newFrame.size)")
        
        mainFrame.frame = newFrame
        
        
    }
    
    func updatePosition() {
        let mainframeWidth = endXMainFrame - startXMainFrame
        let mainframeHeight = endYMainFrame - startYMainFrame
        if startXMainFrame < leftPadding {
            startXMainFrame = leftPadding
            endXMainFrame = startXMainFrame + mainframeWidth
        }
        if endXMainFrame > rightPadding {
            endXMainFrame = rightPadding
            startXMainFrame = endXMainFrame - mainframeWidth
        }
        if startYMainFrame < topPadding {
            startYMainFrame = topPadding
            endYMainFrame = startYMainFrame + mainframeHeight
        }
        if endYMainFrame > bottomPadding {
            endYMainFrame = bottomPadding
            startYMainFrame = endYMainFrame - mainframeHeight
        }
        
        
        var startX = startXMainFrame
        while ((startX - mainframeWidth) >= leftPadding) {
            startX = startX - mainframeWidth
        }
        var endX = endXMainFrame
        while ((endX + mainframeWidth) <= rightPadding) {
            endX = endX + mainframeWidth
        }
        var startY = startYMainFrame
        while ((startY - mainframeHeight) >= topPadding) {
            startY = startY - mainframeHeight
        }
        var endY = endYMainFrame
        while ((endY + mainframeHeight) <= bottomPadding) {
            endY = endY + mainframeHeight
        }
        
        startXInvisibleFrame = startX
        endXInvisibleFrame = endX
        startYInvisibleFrame = startY
        endYInvisibleFrame = endY
        
        updateConstrain()
    }
    
    func updatePosition1 () {
        
        var newFrame = mainFrame.frame
        
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
        printLog()
        print("newframe.origin: \(newFrame.origin)")
        
        mainFrame.frame = newFrame
        
        var startX = newFrame.origin.x
        while ((startX - newFrame.width) >= leftPadding) {
            startX = startX - newFrame.width
        }
        var endX = newFrame.origin.x + newFrame.width
        while ((endX + newFrame.width) <= rightPadding) {
            endX = endX + newFrame.width
        }
        var startY = newFrame.origin.y
        while ((startY - newFrame.height) >= topPadding) {
            startY = startY - newFrame.height
        }
        var endY = newFrame.origin.y + newFrame.height
        while ((endY + newFrame.height) <= bottomPadding) {
            endY = endY + newFrame.height
        }
        
        startXInvisibleFrame = startX
        endXInvisibleFrame = endX
        startYInvisibleFrame = startY
        endYInvisibleFrame = endY
        
        updateConstrain()
        
//        var frameInvisible = invisibleFrame.frame
//        frameInvisible.origin.x = startX
//        frameInvisible.origin.y = startY
//        frameInvisible.size.width = endX - startX
//        frameInvisible.size.height = endY - startY
//        invisibleFrame.frame = frameInvisible
        
//        if !isFirstTimeUpdatePosition && false {
//            containerView.removeConstraint(leftConstrainInviFrame)
//            containerView.removeConstraint(rightConstrainInviFrame)
//            containerView.removeConstraint(topConstrainInviFrame)
//            containerView.removeConstraint(bottomConstrainInviFrame)
//        } else {
//            isFirstTimeUpdatePosition = false
//        }
        
//        leftConstrainInviFrame.constant = startX
//        rightConstrainInviFrame.constant = endX
//        topConstrainInviFrame.constant = startY
//        bottomConstrainInviFrame.constant = endY
        
//        leftConstrainInviFrame = NSLayoutConstraint(item: invisibleFrame, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: containerView, attribute: NSLayoutAttribute.Leading, multiplier: 1, constant: startX)
//        rightConstrainInviFrame = NSLayoutConstraint(item: invisibleFrame, attribute: NSLayoutAttribute.Trailing, relatedBy: NSLayoutRelation.Equal, toItem: containerView, attribute: NSLayoutAttribute.Leading, multiplier: 1, constant: endX)
//        topConstrainInviFrame = NSLayoutConstraint(item: invisibleFrame, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: containerView, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: startY)
//        bottomConstrainInviFrame = NSLayoutConstraint(item: invisibleFrame, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: containerView, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: endY)
        
//        containerView.addConstraint(leftConstrainInviFrame)
//        containerView.addConstraint(rightConstrainInviFrame)
//        containerView.addConstraint(topConstrainInviFrame)
//        containerView.addConstraint(bottomConstrainInviFrame)

        
//        mainFrame.frame = newFrame
        
        
//        NSTimer.scheduledTimerWithTimeInterval(0.2, target: self, selector: Selector("updateConstrain"), userInfo: nil, repeats: false)
    }
    
    func updateConstrain(){
        
        let frameWidth = containerView.frame.width
        let frameHeight = containerView.frame.height
        leftConstrainInviFrame.constant = startXInvisibleFrame
        rightConstrainInviFrame.constant = frameWidth - endXInvisibleFrame
        topConstrainInviFrame.constant = startYInvisibleFrame
        bottomConstrainInviFrame.constant = frameHeight - endYInvisibleFrame
        
        leftConstrainMainFrame.constant = startXMainFrame
        rightConstrainMainFrame.constant = frameWidth - endXMainFrame
        topConstrainMainFrame.constant = startYMainFrame
        bottomConstrainMainFrame.constant = frameHeight - endYMainFrame
        
        print("updateConstrain frameWidth: \(frameWidth), frameHeight: \(frameHeight)")
        printFrameLog()
    }
    func printFrameLog() {
        print("invisibleFrame startX:\(startXInvisibleFrame), endX: \(endXInvisibleFrame), startY: \(startYInvisibleFrame), endY: \(endYInvisibleFrame)")
        print("mainFrame startX:\(startXMainFrame), endX: \(endXMainFrame), startY: \(startYMainFrame), endY: \(endYMainFrame)")
        
//        print("\nmainFrame startX:\(leftConstrainMainFrame), endX: \(rightConstrainMainFrame), startY: \(topConstrainMainFrame), endY: \(bottomConstrainMainFrame)")
        
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
        
        updatePosition()
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
    
    func manageImage (){
//        let imgRef = Util.CGImageWithCorrectOrientation(image)
//        let resizedImage = Util.drawImageInBounds(image, bounds: resizedImageBounds)
//        Util.croppedImageWithRect(resizedImage, rect: croppedRect)
    }
    
    func imageWithColor(color: UIColor, size: CGSize) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContextWithOptions(rect.size, true, 0)
        color.setFill()
        UIRectFill(rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image;
    }
    
    func saveImage(key: String, image: UIImage) -> Void {
        
        UIGraphicsBeginImageContextWithOptions(image.size, false, 1.0)
        image.drawInRect(CGRect(origin: CGPointZero, size: image.size))
        let imageToSave:UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        let imageData:NSData = UIImagePNGRepresentation(imageToSave)!
        
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
        let userData = "test"
        let filePathToWrite = "\(paths)/image-\(userData)-\(key).png"
        let fileManager = NSFileManager.defaultManager()
        fileManager.createFileAtPath(filePathToWrite, contents: imageData, attributes: nil)
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

