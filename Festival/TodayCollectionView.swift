//
//  TodayCollectionView.swift
//  Festival
//
//  Created by Asti Lagmay on 16/12/2019.
//  Copyright © 2019 Asti Lagmay. All rights reserved.
//

import UIKit

class TodayCollectionView: UICollectionView {

    override func layoutSubviews() {
        super.layoutSubviews()
        if bounds.size != intrinsicContentSize {
            invalidateIntrinsicContentSize()
        }
    }
    
    override var intrinsicContentSize: CGSize {
        return self.contentSize
    }

}
