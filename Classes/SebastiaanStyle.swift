//
//  SebastiaanStyle.swift
//  SebastiaanSchool
//
//  Created by Jeroen Leenarts on 07-10-16.
//
//

import UIKit

class SebastiaanStyle {
    static let sebastiaanBlueColor: UIColor = #colorLiteral(red: 0.1921568627, green: 0.7098039216, blue: 0.8352941176, alpha: 1) // 49, 181, 213
    static let longStyleDateFormatter: DateFormatter = {
       let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
    
    static let titleFont = UIFont.boldSystemFont(ofSize: UIFont.labelFontSize + 1.0)
    static let subtitleFont = UIFont.systemFont(ofSize: UIFont.systemFontSize)
    static let bodyFont = UIFont.systemFont(ofSize: UIFont.systemFontSize + 2.0)
    
    static let standardMargin = CGFloat(15.0)
    
    static func applyStyle(toTextView textView: UITextView) {
        textView.layer.borderWidth = 1.0
        textView.layer.borderColor = UIColor.lightGray.cgColor
        textView.font = bodyFont
    }
    
    static func selectedBackground() -> UIView {
        let view = UIView()
        view.backgroundColor = sebastiaanBlueColor
        view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        return view
    }
    
    static func applyStyle(_ button: UIButton) {
        //TODO
//        [deleteButton setBackgroundImage:[[UIImage imageNamed:@"redButton"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 16, 0, 16)] forState:UIControlStateNormal];
//        [deleteButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        [deleteButton setTitleShadowColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
//        [deleteButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateHighlighted];
//        deleteButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
//        [deleteButton setTitle:NSLocalizedString(@"Delete", nil) forState:UIControlStateNormal];
    }
    
}
