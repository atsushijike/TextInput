//
//  ViewController.swift
//  TextInput
//
//  Created by 寺家 篤史 on 2018/07/24.
//  Copyright © 2018年 Yumemi Inc. All rights reserved.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
    private let tableView = UITableView(frame: .zero, style: .plain)
    private let footerView = FooterView(frame: .zero)
    private var bottomInset: CGFloat = 0

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: .UIKeyboardWillHide, object: nil)

        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "default")
        view.addSubview(tableView)
        
        footerView.sendButton.addTarget(self, action: #selector(sendButtonSelected(sender:)), for: .touchUpInside)
        view.addSubview(footerView)

        tableView.snp.makeConstraints { (make) in
            make.top.leading.trailing.equalToSuperview()
        }
        footerView.snp.makeConstraints { (make) in
            make.top.equalTo(tableView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().inset(bottomInset)
        }
    }

    override func viewSafeAreaInsetsDidChange() {
        setBottomInset(view.safeAreaInsets.bottom)
    }

    private func setBottomInset(_ inset: CGFloat, duration: TimeInterval = 0) {
        bottomInset = inset
        UIView.animate(withDuration: duration, animations: {
            self.footerView.snp.updateConstraints({ (make) in
                make.bottom.equalToSuperview().inset(self.bottomInset)
            })
            self.view.layoutIfNeeded()
        })
    }

    @objc private func sendButtonSelected(sender: UIButton) {
        footerView.textView.resignFirstResponder()
        if footerView.textView.text.isEmpty { return }
        
        // メッセージ送信処理
    }

    @objc private func keyboardWillShow(notification: Notification) {
        if let duration = notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? Double,
            let rectValue = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue {
            setBottomInset(rectValue.cgRectValue.height, duration: duration)
        }
    }
    
    @objc private func keyboardWillHide(notification: Notification) {
        if let duration = notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? Double {
            setBottomInset(view.safeAreaInsets.bottom, duration: duration)
        }
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "default", for: indexPath)
        cell.textLabel?.text = "title"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
