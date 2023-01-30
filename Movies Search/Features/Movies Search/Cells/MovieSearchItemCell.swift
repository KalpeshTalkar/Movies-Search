//
//  MovieSearchItemCell.swift
//  Movies Search
//
//  Created by Kalpesh Talkar on 27/01/2023.
//

import UIKit

class MovieSearchItemCell: UITableViewCell {

    @IBOutlet private weak var moviePosterImageView: UIImageView!
    @IBOutlet private weak var titleLbl: UILabel!
    @IBOutlet private weak var yearLbl: UILabel!
    @IBOutlet private weak var typeLbl: UILabel!
    @IBOutlet private weak var favBtn: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    var favTapped: (() -> Void)?

    func configure(_ movie: Movie) {
        titleLbl.text = movie.title
        yearLbl.text = movie.year
        typeLbl.text = movie.type.rawValue
        favBtn.setImage(UIImage(systemName: movie.favorite ? "heart.fill" : "heart"), for: .normal)
        if let url = URL(string: movie.poster),
           let imgView = moviePosterImageView as? AsyncImageView {
            imgView.load(url: url)
        }
    }

    @IBAction func favBtnTapped() {
        favTapped?()
    }
}
