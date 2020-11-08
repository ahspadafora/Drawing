//
//  ContentView.swift
//  Drawing
//
//  Created by Amber Spadafora on 11/1/20.
//  Copyright © 2020 Amber Spadafora. All rights reserved.
//

import SwiftUI

struct Flower: Shape {
    var petalOffset: Double = -20
    
    var petalWidth: Double = 100
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        for number in stride(from: 0, to: CGFloat.pi * 2, by: CGFloat.pi / 8 ) {
            let rotation = CGAffineTransform(rotationAngle: number)
            let position = rotation.concatenating(CGAffineTransform(translationX: rect.width / 2, y: rect.height / 2))
            
            let originalPetal = Path(ellipseIn: CGRect(x: CGFloat(petalOffset), y: 0, width: CGFloat(petalWidth), height: rect.width/2))
            
            let rotatedPetal = originalPetal.applying(position)
            path.addPath(rotatedPetal)
            
        }
        return path
    }
}

struct Arc: InsettableShape {
    var insetAmount: CGFloat = 0
    var startAngle: Angle
    var endAngle: Angle
    var clockwise: Bool
    
    func path(in rect: CGRect) -> Path {
        let rotationAdjustment = Angle.degrees(90)
        let modifiedStart = startAngle - rotationAdjustment
        let modifiedEnd = endAngle - rotationAdjustment
        
        var path = Path()
        path.addArc(center: CGPoint(x: rect.midX, y: rect.midY), radius: rect.width / 2 - insetAmount, startAngle: modifiedStart, endAngle: modifiedEnd, clockwise: clockwise)
        return path
    }
    
    func inset(by amount: CGFloat) -> some InsettableShape {
        var arc = self
        arc.insetAmount += amount
        return arc
    }
}

struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.minY))
        return path
    }
}

struct Arrow: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addRect(CGRect(x: rect.midX - (30/2), y: rect.maxY, width: 30, height: 60))
        return path
    }
}

struct Trapezoid: Shape {
    var insetAmount: CGFloat
    
    var animatableData: CGFloat {
        get { insetAmount }
        set { self.insetAmount = newValue }
    }
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        path.move(to: CGPoint(x: 0,y: rect.maxY))
        path.addLine(to: CGPoint(x: insetAmount,y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX - insetAmount,y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX,y: rect.maxY))
        return path
    }
}

struct Checkerboard: Shape {
    var rows: Int
    var columns: Int
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let rowSize = rect.height / CGFloat(rows)
        let columnsSize = rect.width / CGFloat(columns)
        
        for row in 0..<rows {
            for column in 0..<columns {
                if (row + column).isMultiple(of: 2) {
                    let startX = columnsSize * CGFloat(column)
                    let startY = rowSize * CGFloat(row)
                    let rect = CGRect(x: startX, y: startY, width: columnsSize, height: rowSize)
                    path.addRect(rect)
                }
            }
        }
        
        return path
    }
}
struct ContentView: View {
    // for Flower shape
    @State private var petalOffset = -20.0
    @State private var petalWidth = 100.0
    
    @State private var colorCycle = 0.0
    
    // For Trapezoid shape
    @State private var insetAmount: CGFloat = 50
    
    // For Checkerboard
    @State private var rows = 4
    @State private var columns = 4
    
    @State private var lineWidth: CGFloat = 10
    public var animatableData: CGFloat {
        get {
            return self.lineWidth
        }
        set {
            self.lineWidth = newValue
        }
    }
//    public var animatableData: AnimatablePair<Double, Double> {
//        get {
//            AnimatablePair(Double(rows), Double(columns))
//        }
//        set {
//            self.rows = Int(newValue.first)
//            self.columns = Int(newValue.second)
//        }
//    }
    
    
    var body: some View {
//        Checkerboard(rows: rows, columns: columns).onTapGesture {
//            withAnimation(.linear(duration: 3)) {
//                self.rows = 8
//                self.columns = 16
//            }
//        }
        Arrow().stroke(Color.red, style: StrokeStyle(lineWidth: self.lineWidth, lineCap: .round, lineJoin: .round)).frame(width: 200, height: 200).onTapGesture {
            withAnimation {
                self.lineWidth = self.lineWidth + 5
            }
        }
        
//        Trapezoid(insetAmount: insetAmount).frame(width: 200, height: 100).onTapGesture {
//            withAnimation {
//                self.insetAmount = CGFloat.random(in: 10...90)
//            }
//        }
        
//        VStack {
//            ColorCyclingCircle(amount: self.colorCycle)
//                .frame(width: 300, height: 300)
//            Slider(value: $colorCycle)
//        }
        
//        Triangle()
//            .stroke(Color.red, style: StrokeStyle(lineWidth: 10, lineCap: .round, lineJoin: .round))
//            .frame(width: 150, height: 150)
//        Arc(startAngle: .degrees(0), endAngle: .degrees(110), clockwise: true)
//            .stroke(Color.blue, lineWidth: 10)
//            .frame(width: 300, height: 300)
//        Circle()
//            .strokeBorder(Color.blue, lineWidth:  10)
        
        // The Flower Shape demo
//        VStack {
//            Flower(petalOffset: petalOffset, petalWidth: petalWidth).fill(Color.red, style: FillStyle(eoFill: true))
//            Text("Offset")
//            Slider(value: $petalOffset, in: -40...40).padding([.horizontal, .bottom])
//            Text("Width")
//            Slider(value: $petalWidth, in: 0...100).padding(.horizontal)
//        }
        
//        Capsule().strokeBorder(ImagePaint(image: Image("example"), scale: 0.1), lineWidth: 20)
//            .frame(width: 300, height: 200)
//
        
        
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
