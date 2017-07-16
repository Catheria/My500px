//
//  CloseView.swift
//  My500px
//
//  Created by MailE on 7/16/17.
//  Copyright © 2017 MailE. All rights reserved.
//

import UIKit

@objc protocol CloseViewDelegate {
    @objc optional func closeViewDidTap(view: CloseView)
}

class CloseView: UIView {
    
    weak var delegate: CloseViewDelegate?
    let lineWidth: CGFloat = 2.0
    let lineColor: UIColor = UIColor.white
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        beginCloseView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func beginCloseView() {
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(CloseView.didTap(gesture:)))
        addGestureRecognizer(singleTap)
    }
    
    @objc func didTap(gesture: UITapGestureRecognizer) {
        delegate?.closeViewDidTap?(view: self)
    }
    
    override func draw(_ rect: CGRect) {
        func p(x: CGFloat, y: CGFloat) -> CGPoint { return CGPoint(x: x * rect.width, y: y * rect.height) }
        func px(x: CGFloat) -> CGFloat { return x * rect.width }
        func py(y: CGFloat) -> CGFloat { return y * rect.height }
        
        let ctx = UIGraphicsGetCurrentContext()!
        UIColor.clear.setFill()
        lineColor.setStroke()
        
        let q: CGFloat = 0.25
        let bp = UIBezierPath()
        bp.lineWidth = lineWidth
        bp.lineCapStyle = CGLineCap.round
        bp.move(to: p(x: q, y: q))
        bp.addLine(to: p(x: (1 - q), y: (1 - q)))
        bp.stroke()
        
        ctx.translateBy(x: rect.width/2, y: rect.height/2)
        ctx.rotate(by: CGFloat.pi/2)
        ctx.translateBy(x: -rect.width/2, y: -rect.height/2)
        bp.stroke()
    }
}
