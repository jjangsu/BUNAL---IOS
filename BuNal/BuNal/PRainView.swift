//
//  StardustView.swift
//  Anagrams
//
//  Created by KIMYOUNG SIK on 2018. 2. 17..
//  Copyright © 2018년 Caroline. All rights reserved.
//
import UIKit
//ExplodeView와 매우 비슷하다.
class PRainView: UIView {
    private var emitter: CAEmitterLayer!
    
    override class var layerClass: AnyClass {
        return CAEmitterLayer.self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("use init(frame: ")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        emitter = self.layer as! CAEmitterLayer
        emitter.emitterPosition = CGPoint(x: self.bounds.size.width / 2, y: self.bounds.size.height / 2)
        emitter.emitterSize = self.bounds.size
        emitter.renderMode = CAEmitterLayerRenderMode.additive
        emitter.emitterShape = CAEmitterLayerEmitterShape.rectangle
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        if self.superview == nil {
            return
        }
        
        let texture: UIImage? = UIImage(named: "Resource/p_rain")
        assert(texture != nil, "particle image not found")
        
        let emitterCell = CAEmitterCell()
        
        emitterCell.name = "cell"
        emitterCell.contents = texture?.cgImage
        emitterCell.birthRate = 50
        emitterCell.lifetime = 5.0          //ExplodeView보다 lifetime이 길다.
        emitterCell.yAcceleration = 10     //파티클이 아래로 떨어진다. 중력효과
        //emitterCell.velocity = 40
        //emitterCell.velocityRange = 10
        emitterCell.scale = 0.5
        emitterCell.scaleRange = 0.1
        emitterCell.scaleSpeed = -0.05
        emitterCell.emissionRange = 0.0
        emitter.emitterCells = [emitterCell]
//
//        DispatchQueue.main.asyncAfter(deadline: .now() + 5, execute: {
//            self.removeFromSuperview()
//        })
    }
}

