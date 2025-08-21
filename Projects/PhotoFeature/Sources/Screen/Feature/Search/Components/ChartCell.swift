//
//  ChartCell.swift
//  PhotoFeature
//
//  Created by hwan on 8/18/25.
//  Copyright © 2025 com.hwan. All rights reserved.
//

import UIKit
import Design
import SwiftUI
import Charts


struct DownloadsChartView: View {
    var data: [DayValue]
    
    private var gradient: LinearGradient {
        LinearGradient(
            colors: [
                Color.blue.opacity(0.35),
                Color.blue.opacity(0.05)
            ],
            startPoint: .top,
            endPoint: .bottom
        )
    }

    var body: some View {
        Chart {
            ForEach(data) { item in
                AreaMark(
                    x: .value("Date", item.date),
                    y: .value("Value", item.value)
                )
            }
            .interpolationMethod(.catmullRom)
            .foregroundStyle(gradient)

            ForEach(data) { item in
                LineMark(
                    x: .value("Date", item.date),
                    y: .value("Value", item.value)
                )
            }
            .interpolationMethod(.catmullRom)
            .foregroundStyle(.blue)
            
            if let last = data.last {
                PointMark(
                    x: .value("Date", last.date),
                    y: .value("Value", last.value)
                )
                .symbolSize(30)
                .foregroundStyle(.white)
                .annotation(position: .overlay, alignment: .center) {
                    Circle().strokeBorder(Color.blue, lineWidth: 2).frame(width: 8, height: 8)
                }
            }
        }
        .chartXAxis(.hidden)
        .chartYAxis(.hidden)
        .padding(.vertical, 8)
        .background(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(LinearGradient(
                    colors: [.blue.opacity(0.06), .clear],
                    startPoint: .top, endPoint: .bottom)
                )
        )
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
    }
}



final class ChartCell: BaseCollectionViewCell, CellIdentifialble {
    typealias Series = [DayValue]

    func set(with data: Series) {
        contentConfiguration = UIHostingConfiguration {
            DownloadsChartView(data: data)
        }
        .margins(.all, 0)
    }
}
