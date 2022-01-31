//
//  ApodImageController.swift
//  APOD
//
//  Created by Lokesh Vyas on 29/01/22.
//

import UIKit

class ApodImageController: UIViewController {
    
    var apod: APOD?
    @IBOutlet weak var apodImageView: UIImageView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageViewTrailingConstant: NSLayoutConstraint!
    @IBOutlet weak var imageViewBottomConstant: NSLayoutConstraint!
    @IBOutlet weak var imageViewTopConstant: NSLayoutConstraint!
    @IBOutlet weak var imageViewLeadingConstant: NSLayoutConstraint!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let apodImage = apod?.imageData {
            apodImageView.image = UIImage(data: apodImage)
            scrollView.delegate = self
        }
       
        view.backgroundColor = .black
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()

    }
    
    fileprivate func updateMinZoomScaleForSize(_ size: CGSize) {
        let widthScale = size.width / apodImageView.bounds.width
        let heightScale = size.height / apodImageView.bounds.height
        let minScale = min(widthScale, heightScale)
        
        scrollView.minimumZoomScale = minScale
        scrollView.zoomScale = minScale
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        updateMinZoomScaleForSize(view.bounds.size)
    }

    @IBAction func doneButtonClick(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}

extension ApodImageController: UIScrollViewDelegate{
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return apodImageView
    }
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        updateConstraintsForSize(view.bounds.size)
    }
    
    fileprivate func updateConstraintsForSize(_ size: CGSize) {
        
        let yOffset = max(0, (size.height - apodImageView.frame.height) / 2)
        imageViewTopConstant.constant = yOffset
        imageViewBottomConstant.constant = yOffset
        
        let xOffset = max(0, (size.width - apodImageView.frame.width) / 2)
        imageViewLeadingConstant.constant = xOffset
        imageViewTrailingConstant.constant = xOffset
        
        view.layoutIfNeeded()
    }

}
