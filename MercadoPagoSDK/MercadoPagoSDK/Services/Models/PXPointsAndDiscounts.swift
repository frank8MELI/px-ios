//
//  PXPointsAndDiscounts.swift
//  MercadoPagoSDK
//
//  Created by Esteban Adrian Boffa on 22/08/2019.
//

import Foundation

struct PXPointsAndDiscounts: Decodable {

    let points: PXPoints?
    let discounts: PXDiscounts?
    let crossSelling: [PXCrossSellingItem]?
    let viewReceiptAction: PXRemoteAction?
    let topTextBox: PXText?

    init(points: PXPoints?, discounts: PXDiscounts?, crossSelling: [PXCrossSellingItem]?, viewReceiptAction: PXRemoteAction?, topTextBox: PXText?) {
        self.points = points
        self.discounts = discounts
        self.crossSelling = crossSelling
        self.viewReceiptAction = viewReceiptAction
        self.topTextBox = topTextBox
    }

    enum PointsAndDiscountsCodingKeys: String, CodingKey {
        case points = "mpuntos"
        case discounts
        case crossSelling = "cross_selling"
        case viewReceiptAction = "view_receipt"
        case topTextBox = "top_text_box"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: PointsAndDiscountsCodingKeys.self)
        let points: PXPoints? = try container.decodeIfPresent(PXPoints.self, forKey: .points)
        let discounts: PXDiscounts? = try container.decodeIfPresent(PXDiscounts.self, forKey: .discounts)
        let crossSelling: [PXCrossSellingItem]? = try container.decodeIfPresent([PXCrossSellingItem].self, forKey: .crossSelling)
        let viewReceiptAction: PXRemoteAction? = try container.decodeIfPresent(PXRemoteAction.self, forKey: .viewReceiptAction)
        let topTextBox: PXText? = try container.decodeIfPresent(PXText.self, forKey: .topTextBox)
        self.init(points: points, discounts: discounts, crossSelling: crossSelling, viewReceiptAction: viewReceiptAction, topTextBox: topTextBox)
    }
}
