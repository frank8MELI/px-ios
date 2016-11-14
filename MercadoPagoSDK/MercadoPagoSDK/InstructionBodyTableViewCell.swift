//
//  InstructionBodyTableViewCell.swift
//  MercadoPagoSDK
//
//  Created by Eden Torres on 11/6/16.
//  Copyright © 2016 MercadoPago. All rights reserved.
//

import UIKit

class InstructionBodyTableViewCell: UITableViewCell {
    
    @IBOutlet weak var bottom: UILabel!
    @IBOutlet weak var view: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func fillCell(instruction: Instruction?, payment: Payment){
        if let instruction = instruction{
            var previus: UIView?
            var height = 0
            
            for (index, info) in instruction.info.enumerated() {
                var fontSize = 18
                
                if index>1 && index<5 && payment.paymentMethodId == "redlink" {
                    fontSize = 16
                }
                let labelTitle = NSAttributedString(string: info, attributes: getAttributes(fontSize: fontSize, color: UIColor.gray))
                let label = createLabel(labelAtributedText: labelTitle)
                height += Int(label.frame.height)
                let views = ["label": label]
                
                setContrainsHorizontal(views: views, constrain: 20)
                
                let heightConstraints:[NSLayoutConstraint]
                
                if index == 0 {
                    heightConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|-(30)-[label]", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views)
                    height += 30
                    NSLayoutConstraint.activate(heightConstraints)
                    
                } else if index+1 != instruction.info.count && instruction.info[index-1] != "" && payment.paymentMethodId == "redlink" {
                    setContrainsVertical(label: label, previus: previus, constrain: 0)
                } else if index == 6 && payment.paymentMethodId == "redlink" {
                    setContrainsVertical(label: label, previus: previus, constrain: 60)
                    height += 60
                } else {
                    setContrainsVertical(label: label, previus: previus, constrain: 30)
                    height += 30
                }
                previus = label
                
                if index == 4 && payment.paymentMethodId == "redlink"{
                    ViewUtils.drawBottomLine(y: CGFloat(height+30), width: UIScreen.main.bounds.width, inView: self.view)
                }
                
            }
            for reference in instruction.references {
                if let labelText = reference.label {
                    let labelTitle = NSAttributedString(string: String(describing: labelText), attributes: getAttributes(fontSize: 12, color: UIColor.gray))
                    let label = createLabel(labelAtributedText: labelTitle)
                    
                    let views = ["label": label]
                    
                    setContrainsHorizontal(views: views, constrain: 20)
                    let heightConstraints:[NSLayoutConstraint]
                    
                    if  previus != nil {
                        setContrainsVertical(label: label, previus: previus, constrain: 30)
                    } else {
                        heightConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|-(30)-[label]", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views)
                        NSLayoutConstraint.activate(heightConstraints)
                    }
                    
                    previus = label
                }
                
                let labelTitle = NSAttributedString(string: String(describing: reference.getFullReferenceValue()), attributes: getAttributes(fontSize: 20, color: UIColor.black))
                let label = createLabel(labelAtributedText: labelTitle)
                
                let views = ["label": label]
                
                if payment.paymentMethodId == "redlink" {
                    setContrainsHorizontal(views: views, constrain: 15)
                } else {
                    setContrainsHorizontal(views: views, constrain: 60)
                }
                
                setContrainsVertical(label: label, previus: previus, constrain: 1)
                previus = label
                
            }
            if instruction.accreditationMessage != "" {
                
                let labelTitle = NSAttributedString(string: String(describing: instruction.accreditationMessage), attributes: getAttributes(fontSize: 12, color: UIColor.gray))
                
                let label = createLabel(labelAtributedText: labelTitle)
                
                let image = UIImageView(frame: CGRect(x: 0, y: 0, width: 16, height: 16))
                image.image = MercadoPago.getImage("iconTime")
                image.translatesAutoresizingMaskIntoConstraints = false
                self.view.addSubview(image)
                
                let views = ["label": label, "image": image] as [String : Any]
                
                let widthConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:[image]-[label]-\((UIScreen.main.bounds.width - label.frame.width - 16)/2)-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views)
                NSLayoutConstraint.activate(widthConstraints)
                setContrainsVertical(label: label, previus: previus, constrain: 30)
                
                let verticalConstraint = NSLayoutConstraint(item: image, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: label, attribute: NSLayoutAttribute.centerY, multiplier: 1, constant: 0)
                view.addConstraint(verticalConstraint)
                
                previus = label
            }
            if instruction.actions != nil && (instruction.actions?.count)! > 0 {
                if instruction.actions![0].tag == ActionTag.LINK.rawValue {
                    let button = MPButton(frame: CGRect(x: 0, y: 0, width: 160, height: 30))
                    button.titleLabel?.font = UIFont(name: MercadoPago.DEFAULT_FONT_NAME, size: 16) ?? UIFont.systemFont(ofSize: 16)
                    button.setTitle(instruction.actions![0].label, for: .normal)
                    button.setTitleColor(UIColor.blueMercadoPago(), for: .normal)
                    button.translatesAutoresizingMaskIntoConstraints = false
                    
                    button.actionLink = instruction.actions![0].url
                    button.addTarget(self, action: #selector(self.goToURL), for: .touchUpInside)
                    self.view.addSubview(button)
                    let views = ["button": button]
                    setContrainsHorizontal(views: views, constrain: 60)
                    
                    setContrainsVertical(label: button, previus: previus, constrain: 30)
                    previus = button
                }
            }
            
            let views = ["label": previus]
            let heightConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:[label]-30-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views)
            NSLayoutConstraint.activate(heightConstraints)
            
        }
        
    }
    func getAttributes(fontSize:Int, color:UIColor)-> [String:AnyObject] {
        return [NSFontAttributeName : UIFont(name: MercadoPago.DEFAULT_FONT_NAME, size: CGFloat(fontSize)) ?? UIFont.systemFont(ofSize: CGFloat(fontSize)),NSForegroundColorAttributeName: color]
    }
    
    func setContrainsHorizontal(views: [String: UIView], constrain: CGFloat) {
        let widthConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-(\(constrain))-[label]-(\(constrain))-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views)
        NSLayoutConstraint.activate(widthConstraints)
    }
    
    func setContrainsVertical(label: UIView, previus: UIView?, constrain:CGFloat) {
        if let previus = previus {
            let heightConstraints = [NSLayoutConstraint(item: label, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: previus, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: constrain)]
            NSLayoutConstraint.activate(heightConstraints)
        }
    }
    
    func goToURL(sender:MPButton!)
    {   if let link = sender.actionLink {
        UIApplication.shared.openURL(URL(string: link)!)
        }
    }
    func createLabel(labelAtributedText: NSAttributedString)->UILabel{
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        label.attributedText = labelAtributedText
        label.sizeToFit()
        label.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(label)
        return label
    }
    
}
