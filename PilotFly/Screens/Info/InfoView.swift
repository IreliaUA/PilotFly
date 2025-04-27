
import SwiftUI

struct InfoView: View {
    @State private var scrollOffset: CGFloat = 0
    @State private var totalContentWidth: CGFloat = 0
    @Environment(\.presentationMode) var presentationMode
    
    init() {
        UIScrollView.appearance().bounces = false
    }
    
    var body: some View {
        GeometryReader { geometry in
            let screenWidth = geometry.size.width
            
            ZStack {

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 0) {
                        ForEach(0..<3) { index in
                            GeometryReader { innerGeo in
                                Image("info\(index + 1)")
                                    .resizable()
//                                    .scaledToFill()
                                    .frame(width: screenWidth, height: geometry.size.height)
                                    .clipped()
                                    .onAppear {
                                        totalContentWidth = screenWidth * 3
                                    }
                                    .background(Color.clear)
                                    .onChange(of: innerGeo.frame(in: .global).minX) { newValue in
                                        if index == 0 {
                                            scrollOffset = -newValue
                                        }
                                    }
                            }
                            .frame(width: screenWidth, height: geometry.size.height)
                        }
                    }
                }
                
                VStack {
                    Spacer().frame(height: 50)
                    HStack {
                        Button(action: {
                            self.presentationMode.wrappedValue.dismiss()
                        }) {
                            Image(.backButton)
                                .resizable()
                                .frame(width: 40, height: 40)
                                .padding()
//                                .padding(.top, -10)
                        }
                        Spacer()
                    }
                    Spacer()
                }
                
                ZStack {
                    Image("airplane")
                        .resizable()
                        .frame(width: 50, height: 50)
                        .rotationEffect(
                            calculatePlaneRotation(
                                scrollOffset: scrollOffset,
                                screenWidth: screenWidth
                            ),
                            anchor: .bottom
                        )
                }
                .offset(
                    x: 0,
                    y: calculatePlaneOffset(
                        scrollOffset: scrollOffset,
                        screenWidth: screenWidth,
                        viewHeight: geometry.size.height
                    )
                )
                .animation(.smooth, value: scrollOffset)
                .position(x: screenWidth / 2, y: geometry.size.height - 50)
                
            }
        }
        .ignoresSafeArea()
    }
    
    private func calculatePlaneOffset(scrollOffset: CGFloat, screenWidth: CGFloat, viewHeight: CGFloat) -> CGFloat {
        let fullScroll = screenWidth * 2
        let progress = scrollOffset / fullScroll
        
        let bottomY: CGFloat = 0
        let topY: CGFloat = -viewHeight + 100
        
        
        if progress < 0.5 {
            return lerp(from: bottomY, to: topY, progress: progress * 2)
        } else {
            return lerp(from: topY, to: bottomY, progress: (progress - 0.5) * 2)
        }
    }
    
    private func lerp(from: CGFloat, to: CGFloat, progress: CGFloat) -> CGFloat {
        return from + (to - from) * progress
    }
    
    private func calculatePlaneRotation(scrollOffset: CGFloat, screenWidth: CGFloat) -> Angle {
        let fullScroll = screenWidth * 2
        let progress = scrollOffset / fullScroll
        
        
        let maxUpTilt: Double = -70
        let maxDownTilt: Double = 70
        
        if progress < 0.5 {
            return Angle(degrees: maxUpTilt * (progress * 2))
        } else if progress < 1 {
            
            return Angle(degrees: maxDownTilt * ((progress - 0.5) * 2))
        } else {
            return Angle(degrees: 0)
        }
    }
}

//#Preview {
//    InfoView()
//}
