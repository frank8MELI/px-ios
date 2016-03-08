//
//  PaymentSearchRowTableViewCell.swift
//  MercadoPagoSDK
//
//  Created by Maria cristina rodriguez on 15/1/16.
//  Copyright © 2016 MercadoPago. All rights reserved.
//

import UIKit

class PaymentSearchCell: UITableViewCell {
    
    @IBOutlet weak var paymentTitle: UILabel!
    
    @IBOutlet weak var paymentIcon: UIImageView!

    
    override init(style: UITableViewCellStyle, reuseIdentifier: String!) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.separatorInset = UIEdgeInsetsZero
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    func fillRowWithPayment(paymentSearchItem : PaymentMethodSearchItem, iconImage: UIImage, tintColor : Bool){
        self.paymentTitle.text = paymentSearchItem.description
        if tintColor {
            let tintedImage = iconImage.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
            self.paymentIcon.image = tintedImage
            self.paymentIcon.tintColor = UIColor().blueMercadoPago()
        } else {
            self.paymentIcon.image = iconImage
            self.paymentTitle.hidden = true
        }
    
    }
}
