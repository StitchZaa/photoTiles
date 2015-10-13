//
//  ViewController.swift
//  photoTiles
//
//  Created by Stitch Zaa on 13/Oct/15.
//  Copyright © 2015 StitchZaa. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var mainPhoto: UIImageView!
    @IBOutlet weak var mainFrame: UIView!
    
    @IBOutlet weak var scrollView: UIScrollView!
//    var scrollView:UIScrollView!
    
    var imageView:UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
//        return imageView
//    }
    
    func scrollViewDidZoom(scrollView: UIScrollView) {
        centerScrollViewContents()
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        NSLog("scrolling")
    }
    
    func centerScrollViewContents() {
        print("centerScrollViewContents")
    }

    @IBAction func onPinchFrame(sender: AnyObject) {
        
    }

    @IBAction func onPanFrame(sender: AnyObject) {
        
    }
    
    @IBAction func importPhoto(sender: AnyObject) {
        
    }

    @IBAction func exportPhoto(sender: AnyObject) {
        
    }
    
}

