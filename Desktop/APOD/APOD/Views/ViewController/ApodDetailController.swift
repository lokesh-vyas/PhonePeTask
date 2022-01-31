//
//  ApodDetailController.swift
//  APOD
//
//  Created by Lokesh Vyas on 29/01/22.
//

import UIKit

class ApodDetailController: UIViewController {

    var apod: APOD?
    
    @IBOutlet weak var pictureImageView: UIImageView!
    @IBOutlet weak var bgPictureImageView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var explanationLabel: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        view.backgroundColor = .black
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        if let data = apod?.imageData {
            
            pictureImageView.image = UIImage(data: data)
            pictureImageView.layer.borderColor = UIColor.white.cgColor
            pictureImageView.layer.borderWidth = 5
            
            // Handle image click
            // create tap gesture recognizer
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(ApodDetailController.imageTapped(gesture:)))
            
            // add it to the image view;
            pictureImageView.addGestureRecognizer(tapGesture)
            // make sure imageView can be interacted with by user
            pictureImageView.isUserInteractionEnabled = true
            
            bgPictureImageView.image = UIImage(data: data)
            
        }
        
        
        dateLabel.text = apod?.date
        
        titleLabel.text = apod?.title
        titleLabel.adjustsFontSizeToFitWidth = true
        
        explanationLabel.text = "   " + apod!.explanation
        explanationLabel.numberOfLines = 0
        explanationLabel.adjustsFontSizeToFitWidth = true
        
    }
    
    @objc func imageTapped(gesture: UIGestureRecognizer) {
        // if the tapped view is a UIImageView then set it to imageview
        if (gesture.view as? UIImageView) != nil {
            
            performSegue(withIdentifier: "goToImageSegue", sender: self.apod)

            
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToImageSegue",
        let imageController = segue.destination as? ApodImageController,
            let apod = sender as? APOD{
            
            imageController.apod = apod
            
        }
    }
    
    
}
