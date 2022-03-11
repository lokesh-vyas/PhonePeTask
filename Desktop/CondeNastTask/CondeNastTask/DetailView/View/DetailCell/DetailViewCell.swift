//
//  DetailViewCell.swift
//  CondeNastTask
//
//  Created by Lokesh Vyas on 10/03/22.
//

import UIKit

class DetailViewCell: UITableViewCell {
    @IBOutlet weak var lblLikesCount: UILabel!
    
    @IBOutlet weak var lblCommentsCount: UILabel!
    @IBOutlet weak var detailImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var firstTitleLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var secondTitleLabel: UILabel!
    @IBOutlet weak var lblAuthor: UILabel!
    
    var articleData : Article? {
        didSet {
            if let model = self.articleData {
                DispatchQueue.main.async {
                    self.titleLabel?.text = model.source.name ?? ""
                    self.firstTitleLabel.text = model.title
                    self.secondTitleLabel.text = model.content ?? ""
                    self.lblAuthor.text = model.author ?? ""
                    //self.timeLabel.text = model.publishedAt ?? ""
                    if let urlString = model.urlToImage, let urlImage = URL(string: urlString) {
                        self.loadImage(url: urlImage)
                    } else {
                        DispatchQueue.main.async {
                            self.detailImage?.image = UIImage(named: "thumbnil")
                        }
                    }
                }
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
    
    private func loadImage(url:URL) {
        CacheManager.shared.avatarImage(avatarSourceURL: url) { [weak self] image in
            guard let self = self,
                  let validImage = image
            else {return}
            DispatchQueue.main.async {
                self.detailImage?.image = validImage
            }
        }
    }
    
}
