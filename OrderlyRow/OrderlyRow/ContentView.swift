//
//  ContentView.swift
//  OrderlyRow
//
//  Created by Inna Chystiakova on 16/05/2024.
//

import SwiftUI

struct ContentView: View {
    @State private var isTapped = false
    private var squareAmount = 6
    
    var body: some View {
        let MyLayout = isTapped ? AnyLayout(AnimatedLayout()) : AnyLayout(StartLayout())
        
        MyLayout {
            ForEach(0..<squareAmount, id: \.self) { _ in
                RoundedRectangle(cornerRadius: 8.0).foregroundStyle(.blue)
            }
        }
        .gesture(
            LongPressGesture()
                .onChanged({ _ in
                    changeLayout()
                })
                .onEnded({ _ in
                    changeLayout()
                })
        )
    }
    
    func changeLayout() {
        withAnimation {
            isTapped.toggle()
        }
    }
}

struct StartLayout: Layout {
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        proposal.replacingUnspecifiedDimensions()
    }
    
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        
        let spacing = 3.0
        let subviewsCount = Double(subviews.count)
        let rectSide: CGFloat = (bounds.width - spacing * (subviewsCount - 1.0)) / subviewsCount 
        var x: CGFloat = bounds.minX + 0.5 * rectSide
        
        for (_, subview) in subviews.enumerated() {
            let place = CGPoint(x: x, y: bounds.midY)
            subview.place(
                at: place,
                anchor: .center,
                proposal: .init(width: rectSide, height: rectSide)
            )
            x += rectSide + spacing
        }
    }
}

struct AnimatedLayout: Layout {
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        proposal.replacingUnspecifiedDimensions()
    }
    
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        
        let subviewsCount = Double(subviews.count)
        let rectSide: CGFloat = bounds.height / subviewsCount
        var x = 0.0
        var y = bounds.maxY
        
        for (_, subview) in subviews.enumerated() {
            let place = CGPoint(x: x , y: y)
            subview.place(
                at: place,
                anchor: .bottomLeading,
                proposal: .init(width: rectSide, height: rectSide)
            )
            x += (bounds.width - rectSide)/(subviewsCount - 1)
            y -= rectSide
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

