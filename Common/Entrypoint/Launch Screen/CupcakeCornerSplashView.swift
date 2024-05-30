//
//  CupcakeCornerSplashView.swift
//  CupcakeCorner
//
//  Created by Isaque da Silva on 30/05/24.
//

import SwiftUI

struct CupcakeCornerSplashView: View {
    @Binding var isSplashViewShowing: Bool
    
    @State private var timerCount = 3
    @State private var cicleCount = 0
    @State private var scale = CGSize(width: 1, height: 1)
    @State private var viewOpacity: Double = 1
    @State private var cicleOpcity: Double = 1
    
    private let timer = Timer.publish(every: 1.0, on: .main, in: .common).autoconnect()
    
    var body: some View {
        VStack {
            ZStack {
                Image(.cupcakeCornerIcon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 250, height: 250)
                    .clipped()
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .scaleEffect(scale)
                
                Circle()
                    .trim(from: 0.0, to: CGFloat(cicleCount) / 2)
                    .stroke(style: StrokeStyle(lineWidth: 3, lineCap: .round, lineJoin: .round))
                    .rotationEffect(Angle(degrees: -90))
                    .animation(Animation.easeInOut(duration: 1), value: cicleCount)
                    .frame(width: 180, height: 180)
                    .opacity(cicleOpcity)
            }
            .frame(maxHeight: .infinity, alignment: .center)
            
        }
        .opacity(viewOpacity)
        .onReceive(timer) { newTime in
            if isSplashViewShowing {
                if timerCount > 1 {
                    cicleCount += 1
                    timerCount -= 1
                } else if timerCount == 1 {
                    withAnimation {
                        cicleOpcity = 0
                    }
                    timerCount = 0
                } else {
                    timer.upstream.connect().cancel()
                    withAnimation(.easeInOut(duration: 0.5)) {
                        scale = .init(width: 50, height: 50)
                        viewOpacity = 0
                        isSplashViewShowing = false
                    }
                }
            }
        }
    }
}


#Preview {
    CupcakeCornerSplashView(isSplashViewShowing: .constant(true))
}
