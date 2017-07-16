//
//  CollectionCell.swift
//  My500px
//
//  Created by MailE on 7/16/17.
//  Copyright © 2017 MailE. All rights reserved.
//

import UIKit

class CollectionCell: UICollectionViewCell {
    
    static let identify = "CollectionCell"
    var imageView: UIImageView!
    var titleLabel: UILabel!
    var descriptionLabel: UILabel!
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        imageView = UIImageView(frame: CGRect(origin: CGPoint.zero, size: frame.size))
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        insertSubview(imageView, at: 0)
        
        let effect = UIBlurEffect(style: .light)
        let vibrancyView = UIVisualEffectView(frame: CGRect(x: 0, y: frame.height - 34, width: frame.width, height: 34))
        vibrancyView.effect = effect
        insertSubview(vibrancyView, aboveSubview: imageView)
        
        titleLabel = UILabel(frame: CGRect(x: 4, y: frame.height - 30, width: frame.width - 4 * 2, height: 14))
        titleLabel.textColor = UIColor.black
        titleLabel.font = UIFont.systemFont(ofSize: 14)
        insertSubview(titleLabel, aboveSubview: vibrancyView)
        
        descriptionLabel = UILabel(frame: CGRect(x: 4, y: frame.height - 14, width: frame.width - 4 * 2, height: 12))
        descriptionLabel.textColor = UIColor.black
        descriptionLabel.font = UIFont.systemFont(ofSize: 12)
        insertSubview(descriptionLabel, aboveSubview: vibrancyView)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        titleLabel.text = ""
        descriptionLabel.text = ""
    }
}
