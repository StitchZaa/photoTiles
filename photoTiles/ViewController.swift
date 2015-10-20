//
//  ViewController.swift
//  photoTiles
//
//  Created by Stitch Zaa on 13/Oct/15.
//  Copyright © 2015 StitchZaa. All rights reserved.
//

import UIKit
import CoreGraphics

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var mainPhoto: UIImageView!
    @IBOutlet weak var mainFrame: UIView!
    @IBOutlet weak var invisibleFrame: UIView!
    @IBOutlet weak var wrapperView: UIView!
    
    @IBOutlet weak var topleftCorner: UIView!
    @IBOutlet weak var toprightCorner: UIView!
    @IBOutlet weak var bottomleftCorner: UIView!
    @IBOutlet weak var bottomrightCorner: UIView!
    
    
//    var imageView:UIImageView!
    @IBOutlet weak var imageView: UIImageView!
    
    var picker = UIImagePickerController()
    
    var imageToSave:UIImage!
    var positionToSave:[[String: CGFloat]] = [[String: CGFloat]]()
    
    var leftPadding:CGFloat!
    var rightPadding:CGFloat!
    var topPadding:CGFloat!
    var bottomPadding:CGFloat!
    
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
        
        
        leftConstrainInviFrame = NSLayoutConstraint(item: invisibleFrame, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: wrapperView, attribute: NSLayoutAttribute.Leading, multiplier: 1, constant: 50)
        rightConstrainInviFrame = NSLayoutConstraint(item: wrapperView, attribute: NSLayoutAttribute.Trailing, relatedBy: NSLayoutRelation.Equal, toItem: invisibleFrame, attribute: NSLayoutAttribute.Trailing, multiplier: 1, constant: 50)
        topConstrainInviFrame = NSLayoutConstraint(item: invisibleFrame, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: wrapperView, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 50)
        bottomConstrainInviFrame = NSLayoutConstraint(item: wrapperView, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: invisibleFrame, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 50)
        
        
        containerView.addConstraints([leftConstrainInviFrame, rightConstrainInviFrame, topConstrainInviFrame, bottomConstrainInviFrame])
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
        
        var newFrame = mainFrame.frame
        let newFrameWidth = round(containerFrame.width * 0.3)
        newFrame.size.width = newFrameWidth
        newFrame.origin.x = round(containerFrame.width * 0.35)
        newFrame.size.height = newFrameWidth
        newFrame.origin.y = round((containerFrame.height - newFrameWidth) * 0.5)
        mainFrame.frame = newFrame
        
        
        updateScale()
        updatePosition()
        
        
        NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: Selector("updateCorner"), userInfo: nil, repeats: false)
    }
    
    func updateCorner() {
        let newFrame = mainFrame.frame
        let cornerWH:CGFloat = 40
        let cornerMargin:CGFloat = 4
        
        
        var topleftFrame = topleftCorner.frame
        topleftFrame.size.width = cornerWH
        topleftFrame.size.height = cornerWH
        topleftFrame.origin.x = 0 - cornerMargin
        topleftFrame.origin.y = 0 - cornerMargin
        topleftCorner.frame = topleftFrame
        
        var toprightFrame = toprightCorner.frame
        toprightFrame.size.width = cornerWH
        toprightFrame.size.height = cornerWH
        toprightFrame.origin.x = newFrame.size.width - cornerWH + cornerMargin
        toprightFrame.origin.y = 0 - cornerMargin
        toprightCorner.frame = toprightFrame
        
        var bottomleftFrame = bottomleftCorner.frame
        bottomleftFrame.size.width = cornerWH
        bottomleftFrame.size.height = cornerWH
        bottomleftFrame.origin.x = 0 - cornerMargin
        bottomleftFrame.origin.y = newFrame.size.height - cornerWH + cornerMargin
        bottomleftCorner.frame = bottomleftFrame
        
        var bottomrightFrame = bottomrightCorner.frame
        bottomrightFrame.size.width = cornerWH
        bottomrightFrame.size.height = cornerWH
        bottomrightFrame.origin.x = newFrame.size.width - cornerWH + cornerMargin
        bottomrightFrame.origin.y = newFrame.size.height - cornerWH + cornerMargin
        bottomrightCorner.frame = bottomrightFrame
        
        print("updateCorner: \(newFrame), \(topleftFrame), \(toprightFrame), \(bottomleftFrame), \(bottomrightFrame)")
    }
    
    func updatePosition () {
        
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
        
//        updateCorner()
    }
    
    func updateScale() {
        
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
        
//        updateCorner()
        updateInviFrameBackground()
        
    }
    
    func updateInviFrameBackground() {
        let pattern:UIImage = UIImage(named: "border2")!
//        pattern.size.width = mainFrame.frame.size.width
        let imagePattern = Util.drawImageInBounds(pattern, bounds: CGRect(origin: CGPointZero, size: mainFrame.frame.size))
        invisibleFrame.backgroundColor = UIColor(patternImage: imagePattern)
    }
    
    func updateConstrain(){
        
        let frameWidth = wrapperView.frame.width
        let frameHeight = wrapperView.frame.height
        leftConstrainInviFrame.constant = startXInvisibleFrame
        rightConstrainInviFrame.constant = frameWidth - endXInvisibleFrame
        topConstrainInviFrame.constant = startYInvisibleFrame
        bottomConstrainInviFrame.constant = frameHeight - endYInvisibleFrame
        
        
        print("updateConstrain frameWidth: \(frameWidth), frameHeight: \(frameHeight)")
        printFrameLog()
    }
    
    func detectPan(recognizer:UIPanGestureRecognizer) {
        let translation  = recognizer.translationInView(containerView)
        let lastLocation = mainFrame.center
        print("mainFrame.origin 1: \(mainFrame.frame.origin)")
        mainFrame.center = CGPointMake(lastLocation.x + translation.x, lastLocation.y + translation.y)
        
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
    
    func printFrameLog() {
        print("invisibleFrame startX:\(startXInvisibleFrame), endX: \(endXInvisibleFrame), startY: \(startYInvisibleFrame), endY: \(endYInvisibleFrame)")
        
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
    
    // useful code for save image into app's memory
    /*
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

    */
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func importPhoto(sender: AnyObject) {
        presentViewController(picker, animated: true, completion: nil)
    }

    @IBAction func exportPhoto(sender: AnyObject) {
//        UIImageWriteToSavedPhotosAlbum
        let image:UIImage = mainPhoto.image!
        let frame = mainFrame.frame
//        let containerFrame = containerView.frame
        
        let ratioX = image.size.width / (rightPadding - leftPadding)
        let ratioY = image.size.height / (bottomPadding - topPadding)
        
        let imageWidth = frame.width * ratioX
        let imageHeight = frame.height * ratioY
        
        
        let amountX:Int = Int(round((endXInvisibleFrame - startXInvisibleFrame) / frame.width))
        let amountY:Int = Int(round((endYInvisibleFrame - startYInvisibleFrame) / frame.height))
        
        let beginX = (startXInvisibleFrame - leftPadding) * ratioX
        let beginY = (startYInvisibleFrame - topPadding) * ratioY
        
        for (var j = 0; j < amountY ; j++) {
            let startY = beginY + (imageHeight * CGFloat(j))
            for (var i = 0 ; i < amountX ; i++) {
                let startX = beginX + (imageWidth * CGFloat(i))
//                let stopX = startX + imageWidth
                print("i: \(i), j: \(j)")
                print("startX: \(startX), startY: \(startY), imageWidth: \(imageWidth), imageHeight: \(imageHeight)")
                
                positionToSave.append(["x": startX, "y": startY, "width": imageWidth, "height": imageHeight])
            }
        }
        
        imageToSave = image
        saveImageToLibrary()
    }
    
    func saveImageToLibrary() {
        if positionToSave.count > 0 {
            let pos:[String: CGFloat]! = positionToSave.popLast()!
            let image:UIImage = imageToSave
            print("pos: \(pos)")
            let targetImage = Util.croppedImageWithRect(image, rect: CGRect(x: pos["x"]!, y: pos["y"]!, width: pos["width"]!, height: pos["height"]!))
            UIImageWriteToSavedPhotosAlbum(targetImage, self, Selector("image:didFinishSavingWithError:contextInfo:"), nil)
        }
    }
    
    func image(image: UIImage, didFinishSavingWithError: NSError?, contextInfo:UnsafePointer<Void>) {
        
        if didFinishSavingWithError != nil {
            print("error:")
        }
        else{
            print("image saved")//this worked do the alert thing
            saveImageToLibrary()
        }
    }
    
    
    internal struct Util {
        
        /**
        Get the CGImage of the image with the orientation fixed up based on EXF data.
        This helps to normalise input images to always be the correct orientation when performing
        other core graphics tasks on the image.
        
        - parameter image: Image to create CGImageRef for
        
        - returns: CGImageRef with rotated/transformed image context
        */
        static func CGImageWithCorrectOrientation(image : UIImage) -> CGImageRef {
            
            if (image.imageOrientation == UIImageOrientation.Up) {
                return image.CGImage!
            }
            
            var transform : CGAffineTransform = CGAffineTransformIdentity;
            
            switch (image.imageOrientation) {
            case UIImageOrientation.Right, UIImageOrientation.RightMirrored:
                transform = CGAffineTransformTranslate(transform, 0, image.size.height)
                transform = CGAffineTransformRotate(transform, CGFloat(-1.0 * M_PI_2))
                break
            case UIImageOrientation.Left, UIImageOrientation.LeftMirrored:
                transform = CGAffineTransformTranslate(transform, image.size.width, 0)
                transform = CGAffineTransformRotate(transform, CGFloat(M_PI_2))
                break
            case UIImageOrientation.Down, UIImageOrientation.DownMirrored:
                transform = CGAffineTransformTranslate(transform, image.size.width, image.size.height)
                transform = CGAffineTransformRotate(transform, CGFloat(M_PI))
                break
            default:
                break
            }
            
            switch (image.imageOrientation) {
            case UIImageOrientation.RightMirrored, UIImageOrientation.LeftMirrored:
                transform = CGAffineTransformTranslate(transform, image.size.height, 0);
                transform = CGAffineTransformScale(transform, -1, 1);
                break
            case UIImageOrientation.DownMirrored, UIImageOrientation.UpMirrored:
                transform = CGAffineTransformTranslate(transform, image.size.width, 0);
                transform = CGAffineTransformScale(transform, -1, 1);
                break
            default:
                break
            }
            
            let contextWidth : Int
            let contextHeight : Int
            
            switch (image.imageOrientation) {
            case UIImageOrientation.Left, UIImageOrientation.LeftMirrored,
            UIImageOrientation.Right, UIImageOrientation.RightMirrored:
                contextWidth = CGImageGetHeight(image.CGImage)
                contextHeight = CGImageGetWidth(image.CGImage)
                break
            default:
                contextWidth = CGImageGetWidth(image.CGImage)
                contextHeight = CGImageGetHeight(image.CGImage)
                break
            }
            
            let context : CGContextRef = CGBitmapContextCreate(nil, contextWidth, contextHeight,
                CGImageGetBitsPerComponent(image.CGImage),
                CGImageGetBytesPerRow(image.CGImage),
                CGImageGetColorSpace(image.CGImage),
                CGImageGetBitmapInfo(image.CGImage).rawValue)!;
            
            CGContextConcatCTM(context, transform);
            CGContextDrawImage(context, CGRectMake(0, 0, CGFloat(contextWidth), CGFloat(contextHeight)), image.CGImage);
            
            let cgImage = CGBitmapContextCreateImage(context);
            return cgImage!;
        }
        
        /**
        Draw the image within the given bounds (i.e. resizes)
        
        - parameter image:  Image to draw within the given bounds
        - parameter bounds: Bounds to draw the image within
        
        - returns: Resized image within bounds
        */
        static func drawImageInBounds(image: UIImage, bounds : CGRect) -> UIImage {
            return drawImageWithClosure(size: bounds.size) { (size: CGSize, context: CGContext) -> () in
                image.drawInRect(bounds)
            };
        }
        
        /**
        Crop the image within the given rect (i.e. resizes and crops)
        
        - parameter image: Image to clip within the given rect bounds
        - parameter rect:  Bounds to draw the image within
        
        - returns: Resized and cropped image
        */
        static func croppedImageWithRect(image: UIImage, rect: CGRect) -> UIImage {
            return drawImageWithClosure(size: rect.size) { (size: CGSize, context: CGContext) -> () in
                let drawRect = CGRectMake(-rect.origin.x, -rect.origin.y, image.size.width, image.size.height)
                CGContextClipToRect(context, CGRectMake(0, 0, rect.size.width, rect.size.height))
                image.drawInRect(drawRect)
            };
        }
        
        /**
        Closure wrapper around image context - setting up, ending and grabbing the image from the context.
        
        - parameter size:    Size of the graphics context to create
        - parameter closure: Closure of magic to run in a new context
        
        - returns: Image pulled from the end of the closure
        */
        static func drawImageWithClosure(size size: CGSize!, closure: (size: CGSize, context: CGContext) -> ()) -> UIImage {
            UIGraphicsBeginImageContextWithOptions(size, false, 0)
            closure(size: size, context: UIGraphicsGetCurrentContext()!)
            let image : UIImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return image
        }
    }
}

