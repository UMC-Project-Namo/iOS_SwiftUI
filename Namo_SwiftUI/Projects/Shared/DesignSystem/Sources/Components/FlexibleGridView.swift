//
//  FlexibleGridView.swift
//  FeatureMoim
//
//  Created by 권석기 on 9/11/24.
//

import SwiftUI

public struct FlexibleGridView<Content: View, Data: Hashable>: View {
    let data: [Data]
    let content: (Data) -> Content
    
    @State private var elementSizes: [CGFloat] = []
    @State private var viewSize: CGFloat = .zero
    
    private var horizontalSpacing: CGFloat = 10
    private var verticalSpacing: CGFloat = 10
    
    public init(data: [Data],
                horizontalSpacing: CGFloat = 10,
                verticalSpacing: CGFloat = 10,
                @ViewBuilder content: @escaping (Data) -> Content) {
        self.data = data
        self.content = content
        self.horizontalSpacing = horizontalSpacing
        self.verticalSpacing = verticalSpacing
    }
    
    public var body: some View {
        ZStack(alignment: .leading) {
            if elementSizes.count == data.count {
                VStack(alignment: .leading, spacing: verticalSpacing) {
                    ForEach(makeRow(), id: \.self) { rowData in
                        HStack(spacing: horizontalSpacing) {
                            ForEach(rowData, id: \.self) { item in
                                content(item)
                            }
                            Spacer()
                        }
                    }
                }
                
                
            } else {
                ForEach(data, id: \.self) { item in
                    content(item)
                        .fixedSize()
                        .onReadSize { size in
                            elementSizes.append(size.width)
                        }
                }
            }
        }
        .frame(maxWidth: .infinity)
        .onReadSize { size in
            viewSize = size.width
        }
    }
    
    private func makeRow() -> [[Data]] {
        
        var row: [[Data]] = [[]]
        var currentRow: Int = 0
        var currentData = data
        var currentViewSize = viewSize
        
        for elementSize in elementSizes.reversed() {
            // 여백을 포함한 viwesize
            let itemSize = elementSize + (horizontalSpacing * 2)
            
            if itemSize <= currentViewSize {
                row[currentRow].append(currentData.removeFirst())
                currentViewSize -= itemSize
            } else {
                currentRow += 1
                row.append([currentData.removeFirst()])
                currentViewSize = viewSize - itemSize
            }
        }
        
        return row
    }
}

struct ViewSizeKey: PreferenceKey {
    static var defaultValue: CGSize = .zero
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) { }
}

extension View {
    @ViewBuilder
    func onReadSize(_ perform: @escaping (CGSize) -> Void) -> some View {
        self
            .background(
                GeometryReader { proxy in
                    Color.clear
                        .preference(key: ViewSizeKey.self, value: proxy.size)
                }
            )
            .onPreferenceChange(ViewSizeKey.self, perform: perform)
    }
}
