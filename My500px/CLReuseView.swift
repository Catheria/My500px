//
//  CLReuseView.swift
//  My500px
//
//  Created by MailE on 7/16/17.
//  Copyright © 2017 MailE. All rights reserved.
//

import UIKit

@objc protocol CLReuseViewDelegate {
    @objc optional func didTap(view: CLReuseView)
}

class CLReuseView: UICollectionReusableView {
    
    static let identify = "CLReuseView"
    static let kind = "CLReuseViewKind"
    weak var delegate: CLReuseViewDelegate?
    var loadMoreButton: UIButton!
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        loadMoreButton = UIButton(type: UIButtonType.system)
        loadMoreButton.frame = CGRect(x: 10, y: (bounds.height - 40)/2, width: bounds.width - (10 * 2), height: 40)
        loadMoreButton.setTitle("Load More !!", for: .normal)
        loadMoreButton.setTitleColor(UIColor.darkGray, for: .normal)
        loadMoreButton.addTarget(self, action: #selector(CLReuseView.eventDidTap(sender:)), for: .touchUpInside)
        addSubview(loadMoreButton)
    }
    
    func eventDidTap(sender: UIButton) {
        delegate?.didTap?(view: self)
    }
}
