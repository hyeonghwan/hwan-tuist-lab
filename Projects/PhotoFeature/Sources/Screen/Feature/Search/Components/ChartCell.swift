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

struct DayValue: Identifiable, Hashable {
    let id = UUID()
    let date: Date
    let value: Double
}

extension Array where Element == Double {
    func asLast30Days(endDate: Date = .now) -> [DayValue] {
        let vals = Array(self.suffix(30))
        guard !vals.isEmpty else { return [] }
        let start = Calendar.current.date(byAdding: .day, value: -(vals.count - 1), to: endDate) ?? endDate
        return vals.enumerated().compactMap { i, v in
            guard let d = Calendar.current.date(byAdding: .day, value: i, to: start) else { return nil }
            return DayValue(date: d, value: v)
        }
    }
}

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
