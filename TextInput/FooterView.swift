//
//  FooterView.swift
//  TextInput
//
//  Created by 寺家 篤史 on 2018/07/26.
//  Copyright © 2018年 Yumemi Inc. All rights reserved.
//

import UIKit

class FooterView: UIView {
    let textView = MessageTextView(frame: .zero)
    let sendButton = UIButton(type: .system)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        textView.font = UIFont.systemFont(ofSize: 17)
        textView.placeholder = "Message"
        addSubview(textView)
        
        sendButton.setTitle("Send", for: .normal)
        addSubview(sendButton)
        
        textView.snp.makeConstraints { (make) in
            make.width.equalToSuperview()
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
}

class MessageTextView: UITextView {
    private let maximumHeight: CGFloat = 160
    lazy private var placeholderLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        return label
    }()
    var placeholder: String? {
        get {
            return placeholderLabel.text
        }
        set {
            placeholderLabel.text = newValue
        }
    }
    var estimatedContentSize: CGSize {
        return sizeThatFits(CGSize(width: frame.width, height: CGFloat.greatestFiniteMagnitude))
    }
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        NotificationCenter.default.addObserver(self, selector: #selector(textViewTextDidChange(notification:)), name: .UITextViewTextDidChange, object: nil)
        addSubview(placeholderLabel)

        placeholderLabel.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(textContainerInset)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    override var intrinsicContentSize: CGSize {
        let size = estimatedContentSize
        return CGSize(width: size.width, height: min(size.height, maximumHeight))
    }
    
    @objc func textViewTextDidChange(notification: Notification) {
        placeholderLabel.isHidden = !text.isEmpty
        invalidateIntrinsicContentSize()
        isScrollEnabled = estimatedContentSize.height > maximumHeight
    }
}
