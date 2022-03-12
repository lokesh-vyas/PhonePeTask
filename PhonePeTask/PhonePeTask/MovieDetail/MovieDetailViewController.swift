//
//  MovieDetailViewController.swift
//  PhonePeTask
//
//  Created by Lokesh Vyas on 12/03/22.
//

import UIKit

class MovieDetailViewController: UIViewController {

    @IBOutlet weak var imgMoview: UIImageView!
    @IBOutlet weak var lblReleaseDate: UILabel!
    @IBOutlet weak var lblRating: UILabel!
    @IBOutlet weak var lblPopularity: UILabel!
    
    @IBOutlet weak var lblOverview: UILabel!
    var movieData : Movie?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.imageDetailLoad()
        // Do any additional setup after loading the view.
    }

    private func imageDetailLoad() {
        self.title = movieData?.title
        self.lblReleaseDate?.text = movieData?.releaseDate
        self.lblRating?.text = String(movieData?.voteAverage ?? 0.0)
        self.lblPopularity?.text = String(movieData?.popularity ?? 0.0)
        self.lblOverview.text = movieData?.overview
        self.loadImage(url: movieData?.posterPath ?? "")
    }
    
    private func loadImage(url:String) {
        ImageDownloader.shared.avatarImage(avatarSourceURL: url) { [weak self] image in
            guard let self = self,
                  let validImage = image
            else {return}
            DispatchQueue.main.async {
                self.imgMoview?.image = validImage
            }
        }
    }
}
