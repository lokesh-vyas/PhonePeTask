//
//  MovieListCell.swift
//  PhonePeTask
//
//  Created by Lokesh Vyas on 12/03/22.
//

import UIKit

class MovieListCell: UITableViewCell {

    @IBOutlet weak var lblMovieName: UILabel!
    @IBOutlet weak var imgMovie: UIImageView!
    @IBOutlet weak var lblDescription: UILabel!
    
    var movieData : Movie? {
        didSet {
            if let model = self.movieData {
                    self.lblMovieName?.text = model.title
                    self.lblDescription?.text = model.overview
                    self.loadImage(url: model.posterPath)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func loadImage(url:String) {
        ImageDownloader.shared.avatarImage(avatarSourceURL: url) { [weak self] image in
            guard let self = self,
                  let validImage = image
            else {return}
            DispatchQueue.main.async {
                self.imgMovie?.image = validImage
            }
        }
    }
    
}
