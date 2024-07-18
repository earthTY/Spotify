//
//  NewReleaseCollectionViewCell.swift
//  Spotify
//
//  Created by Alex on 2024/7/17.
//

import UIKit
import SDWebImage

//struct NewReleasesCellViewModel {
//    let name: String
//    let artworkUrl: URL?
//    let numberOfTracks: Int
//    let artistName: String
//}


class QNewReleaseCollectionViewCell: UICollectionViewCell {
    static let identifer = "QNewReleaseCollectionViewCell"
    
    private let albumCoverImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "photo")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let albumNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 22, weight: .semibold)
        label.numberOfLines = 2
        return label
    }()
    
    private let numberOfTracksLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .light)
        label.numberOfLines = 0
        return label
    }()
    
    private let artistNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.numberOfLines = 0
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .secondarySystemBackground
        contentView.addSubview(albumCoverImageView)
        contentView.addSubview(albumNameLabel)
        contentView.addSubview(artistNameLabel)
        contentView.addSubview(numberOfTracksLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
//        albumNameLabel.sizeToFit()
        
        
        let imageSize:CGFloat = contentView.heigh - 10
        let albumLabelSize = albumNameLabel.sizeThatFits(
            CGSize(
                width: contentView.width - imageSize - 10,
                height: contentView.heigh - 10
            )
        )
        
        artistNameLabel.sizeToFit()
        numberOfTracksLabel.sizeToFit()
        
        albumCoverImageView.frame = CGRect(x: 5, y: 5, width: imageSize, height: imageSize)
        
        let albumLabelHeight = min(70, albumLabelSize.height)
        
        albumNameLabel.frame = CGRect(
            x: albumCoverImageView.right + 10,
            y: 5,
            width: albumLabelSize.width,
            height: albumLabelHeight
        )
        
        artistNameLabel.frame = CGRect(
            x: albumCoverImageView.right + 10,
            y: albumNameLabel.bottom,
            width: contentView.width - albumCoverImageView.right - 5,
            height: 44
        )
        
        numberOfTracksLabel.frame = CGRect(
            x: albumCoverImageView.right + 10,
            y: contentView.bottom - 44,
            width: numberOfTracksLabel.width + 10,
            height: 44
        )
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        albumNameLabel.text = nil
        artistNameLabel.text = nil
        numberOfTracksLabel.text = nil
        albumCoverImageView.image = nil
    }
    
    func configre(with viewMode: NewReleasesCellViewModel){
        albumNameLabel.text = viewMode.name
        artistNameLabel.text = viewMode.artistName
        numberOfTracksLabel.text = "Tracks:\(viewMode.numberOfTracks)"
        albumCoverImageView.sd_setImage(with: viewMode.artworkUrl, completed: nil)
    }
}
