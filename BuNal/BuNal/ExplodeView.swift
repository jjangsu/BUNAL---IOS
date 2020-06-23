//
//  ExplodeView.swift
//  Anagrams
//
//  Created by KIMYOUNG SIK on 2018. 2. 13..
//  Copyright © 2018년 Caroline. All rights reserved.
//

import UIKit

class ExplodeView: UIView {
    //CAEmitterLayer 변수
    private var emitter: CAEmitterLayer!
    //UIView class 메소드 : CALayer 가 아니라 CAEmitterLayer 리턴
    override class var layerClass: AnyClass {
        return CAEmitterLayer.self
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("use init(frame: ")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        //파티클 표현을 위해서 emitter cell을 생성하고 설정
        emitter = self.layer as! CAEmitterLayer
        emitter.emitterPosition = CGPoint(x: self.bounds.size.width / 2, y: self.bounds.size.height / 2)
        emitter.emitterSize = self.bounds.size
        emitter.renderMode = CAEmitterLayerRenderMode.additive
        emitter.emitterShape = CAEmitterLayerEmitterShape.rectangle
    }
    
    func didMoveToSuperview(weather: String) {
        //1. 부모의 didMoveToSuperView()를 호출하고 superview가 없다면 exit
        super.didMoveToSuperview()
        if self.superview == nil {
            return
        }
        //2. particle.png 파일 UIImage로 로딩
        let texture_snow: UIImage? = UIImage(named: "p_snow")
        assert(texture_snow != nil, "snow image not found")
        
        let texture_rain: UIImage? = UIImage(named: "p_rain")
        assert(texture_rain != nil, "rain image not found")
        
        let texture_sun: UIImage? = UIImage(named: "p_sun")
        assert(texture_sun != nil, "sun image not found")
        
        let texture_cloud: UIImage? = UIImage(named: "p_cloud")
        assert(texture_cloud != nil, "cloud image not found")
        //3. emitterCell 생성, 뒤에는 설정
        let emitterCell = CAEmitterCell()
        
        emitterCell.name = "cell"               //name 설정
        switch weather {
        case "snow":
            emitterCell.contents = texture_snow?.cgImage
        case "rain":
            emitterCell.contents = texture_rain?.cgImage
        case "sun":
            emitterCell.contents = texture_sun?.cgImage
        case "cloud":
            emitterCell.contents = texture_cloud?.cgImage
        default:
            emitterCell.contents = texture_sun?.cgImage
        }
        emitterCell.birthRate = 100     //1초에 200개 생성
        emitterCell.lifetime = 2.0     //1개 particle는 0.75초 동안 생존
        //emitterCell.blueRange = 0.99    //랜덤색깔 rgb(1,1,1) ~ (1,1,0.67)white~orange
        //emitterCell.blueSpeed = -0.99   //시간이 지나면서 blue 색을 줄인다.
        emitterCell.velocity = 50      //셀의 속도 범위 160-40 ~ 160+40
        emitterCell.velocityRange = 10
        emitterCell.scaleRange = 0.0    //셀크기 1.0-0.5 ~ 1.0+0.5
        emitterCell.scaleSpeed = 0.0   //셀크기 감소 속도
        emitterCell.emissionRange = 0.0  //셀생성 방향 360도
        emitter.emitterCells = [emitterCell] //emitterCell 배열에 넣는다.
        //2초 후에 파티클 remove
        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
            self.removeFromSuperview()
        })
    }

}

