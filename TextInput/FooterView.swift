//
//  FooterView.swift
//  TextInput
//
//  Created by 寺家 篤史 on 2018/07/26.
//  Copyright © 2018年 Yumemi Inc. All rights reserved.
//

import UIKit

class FooterView: UIView, UITextViewDelegate {
    let textView = MessageTextView(frame: .zero)
    let sendButton = UIButton(type: .system)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        textView.delegate = self
        textView.font = UIFont.systemFont(ofSize: 17)
        textView.placeholder = "Message"
        addSubview(textView)
        let height = textView.sizeThatFits(CGSize(width: textView.frame.size.width, height: CGFloat.greatestFiniteMagnitude)).height
        
        sendButton.setTitle("Send", for: .normal)
        addSubview(sendButton)
        
        textView.snp.makeConstraints { (make) in
            make.width.equalToSuperview()
            make.height.equalTo(height)
            make.height.greaterThanOrEqualTo(20)
            make.top.equalToSuperview()
        }
        sendButton.snp.makeConstraints { (make) in
            make.width.equalTo(85)
            make.height.equalTo(40)
            make.top.equalTo(textView.snp.bottom)
            make.bottom.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        layer.borderColor = UIColor.red.cgColor
        layer.borderWidth = 1
        textView.layer.borderColor = UIColor.green.cgColor
        textView.layer.borderWidth = 1
        sendButton.layer.borderColor = UIColor.cyan.cgColor
        sendButton.layer.borderWidth = 1
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func textViewDidChange(_ textView: UITextView) {
        let height = textView.sizeThatFits(CGSize(width: textView.frame.size.width, height: CGFloat.greatestFiniteMagnitude)).height
        textView.snp.updateConstraints { (make) in
            make.height.equalTo(height)
        }
    }
}

class MessageTextView: UITextView {
    lazy var placeholderLabel = UILabel()
    var placeholder = ""
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        NotificationCenter.default.addObserver(self, selector: #selector(textViewTextDidChange(notification:)), name: .UITextViewTextDidChange, object: nil)
        placeholderLabel.textColor = .lightGray
        placeholderLabel.numberOfLines = 0
        addSubview(placeholderLabel)
        
        placeholderLabel.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func textViewTextDidChange(notification: Notification) {
        placeholderLabel.isHidden = text.isEmpty
    }
}
