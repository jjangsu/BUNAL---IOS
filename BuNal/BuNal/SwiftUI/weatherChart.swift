//
//  weatherChart.swift
//  BuNal
//
//  Created by kpugame on 2020/06/23.
//  Copyright © 2020 minjoooo. All rights reserved.
//

import SwiftUI


struct weatherChart: View {
    
    func getDegree(a : Double, b: Double) -> Double
    {
        let r = (b - a) / 1.0
        return tan(r)
    }
    
    var body: some View {
        HStack {
            ForEach(0..<12) { month in
                VStack(alignment: .leading) {
                    Spacer()
                    
                    Rectangle()
                        .fill(Color.blue)
                        .frame(width: 20, height: CGFloat(Double(month) * 25.0))
                        // .rotationEffect(.degrees(-90))
                        
//                        .rotationEffect(.degrees(self.getDegree(a: Double(month) * 25.0, b: Double(month) * 25.0)))
                }
            }
        }
    }
}

struct weatherChart_Previews: PreviewProvider {
    static var previews: some View {
        weatherChart()
    }
}
