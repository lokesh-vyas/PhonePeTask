//
//  GSAPODCollectionViewCell.swift
//  APOD
//
//  Created by Lokesh Vyas on 29/01/22.
//

import UIKit

public class ApodTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var pictureImageView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var notAvaliableLabel: UILabel!
    
    var dataTask: URLSessionDataTask?
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    public override func prepareForReuse() {
        dataTask?.cancel()
        pictureImageView.image = UIImage(named: "no_image")
        activityIndicator.isHidden = false
    }
    
}
