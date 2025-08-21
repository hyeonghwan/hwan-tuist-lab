//
//  PinterestLayout.swift
//  PhotoFeature
//
//  Created by hwan on 8/17/25.
//  Copyright © 2025 com.hwan. All rights reserved.
//

import UIKit

final class PinterestLayout: UICollectionViewFlowLayout {
    
    weak var delegate: PinterestLayoutDelegate?
    
    private var contentHeight: CGFloat = 0
    private var yOffSet: [CGFloat] = []
    private let numberOfColumns: Int = 2
    private let cellPadding: CGFloat = 5
    
    private var footerAttributes: UICollectionViewLayoutAttributes?
    
    func invalidateCache() {
        cache.removeAll()
        contentHeight = 0
        footerAttributes = nil
    }
    
    private var contentWidth: CGFloat {
        guard let collectionView else {
            return 0
        }
        let insets = collectionView.contentInset
        return collectionView.bounds.width - (insets.left + insets.right)
    }
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }
    
    private var cache: [UICollectionViewLayoutAttributes] = []
    
    override func prepare() {
        guard let collectionView else { return }
        
        func build(from start: Int, to end: Int) {
            var column = (yOffSet.enumerated().min(by: { $0.element < $1.element })?.offset) ?? 0
            for item in start..<end {
                let indexPath = IndexPath(item: item, section: 0)
                let imageHeight = delegate?.collectionView(collectionView, heightForPhotoAtIndexPath: indexPath) ?? 180
                let height = cellPadding * 2 + imageHeight

                let frame = CGRect(x: xOffsets[column],
                                   y: yOffSet[column],
                                   width: cellWidth,
                                   height: height)
                let insetFrame = frame.insetBy(dx: cellPadding, dy: cellPadding)

                let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                attributes.frame = insetFrame
                cache.append(attributes)

                contentHeight = max(contentHeight, frame.maxY)
                yOffSet[column] += height

                column = yOffSet.enumerated().min(by: { $0.element < $1.element })?.offset ?? 0
            }
        }

        let itemCount = collectionView.numberOfItems(inSection: 0)

        let cellWidth: CGFloat = contentWidth / CGFloat(numberOfColumns)
        let xOffsets: [CGFloat] = (0..<numberOfColumns).map { CGFloat($0) * cellWidth }

        if itemCount <= cache.count {
            cache.removeAll()
            contentHeight = 0
            yOffSet = Array(repeating: 0, count: numberOfColumns)
            build(from: 0, to: itemCount)
            buildFooterIfNeeded()
            return
        }

        if yOffSet.count != numberOfColumns || yOffSet.reduce(0, +) == 0 {
            yOffSet = .init(repeating: 0, count: numberOfColumns)
            for attribute in cache {
                let col = xOffsets.enumerated().min(by: { abs($0.element - attribute.frame.minX) < abs($1.element - attribute.frame.minX) })?.offset ?? 0
                yOffSet[col] = max(yOffSet[col], attribute.frame.maxY)
                contentHeight = max(contentHeight, attribute.frame.maxY)
            }
        }
        
        build(from: cache.count, to: itemCount)
        buildFooterIfNeeded()
    }
    
    private func buildFooterIfNeeded() {
        guard let collectionView else { return }
        guard 0 < collectionView.numberOfSections else { return }
        let indexPath = IndexPath(item: 0, section: 0)

        let attributes = UICollectionViewLayoutAttributes(
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
            with: indexPath
        )
        attributes.frame = CGRect(x: 0, y: contentHeight, width: contentWidth, height: 44)
        attributes.zIndex = 0
        footerAttributes = attributes
        contentHeight = max(contentHeight, attributes.frame.maxY)
    }
    
    override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        print("layoutAttributesForSupplementaryView: \(indexPath)")
        if elementKind == UICollectionView.elementKindSectionFooter && indexPath.section == 0 {
            return footerAttributes
        }
        return nil
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var visibleLayoutAttributes: [UICollectionViewLayoutAttributes] = []
        for attributes in cache {
            if attributes.frame.intersects(rect) {
                visibleLayoutAttributes.append(attributes)
            }
        }
        
        if let footerAttributes {
            return visibleLayoutAttributes + [footerAttributes]
        } else {
            return visibleLayoutAttributes
        }
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard indexPath.item < cache.count else { return nil }
        return cache[indexPath.item]
    }
}
