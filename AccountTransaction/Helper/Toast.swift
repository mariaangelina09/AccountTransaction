//
//  Toast.swift
//  AccountTransaction
//
//  Created by Maria Angelina on 18/01/22.
//

import Foundation
import SnapKit
import UIKit

enum ToastType {
    case success
    case error
    case common
}

class Toast {
    static let shared = Toast()
    
    fileprivate func buildBannerLayout(withWrapperFrame wrapperFrame: CGRect, message: String, title: String, type: ToastType) -> UIView {
        var imageName: String = ""
        var backgroundColor: UIColor = .gray
        var textColor: UIColor = .white
        
        switch type {
        case .success:
            imageName = "icSuccess"
            backgroundColor = .lightGreen
            textColor = .darkGreen
        case .error:
            imageName = "icError"
            backgroundColor = .lightRed
            textColor = .red
        case .common:
            imageName = "icCommon"
            backgroundColor = .lightGray
            textColor = .gray
        }
        
        let frame = CGRect(x: 10, y: -100, width: wrapperFrame.size.width - 20, height: 70)
        let view = UIView(frame: frame)
        view.tag = 778
        view.backgroundColor = backgroundColor
        view.layer.cornerRadius = 10
        
        let imageView = UIImageView(frame: CGRect(x: 20, y: 15, width: 30, height: 30))
        imageView.image = UIImage(named: imageName)
        imageView.snp.makeConstraints{
            $0.width.height.equalTo(30)
        }
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.textColor = textColor
        titleLabel.font = UIFont(name: "SourceSansPro-Bold", size: 14)
        
        let messageLabel = UILabel()
        messageLabel.text = message
        messageLabel.textColor = .white
        messageLabel.numberOfLines = 2
        messageLabel.font = UIFont(name: "SourceSansPro-Regular", size: 12)
        
        let stackviewVert = UIStackView(arrangedSubviews: [
                            titleLabel,
                            messageLabel,
                        ])
        stackviewVert.axis = .vertical
        stackviewVert.spacing = 4
        
        let stackviewHor = UIStackView(arrangedSubviews: [
                            imageView,
                            stackviewVert,
                        ])
        stackviewHor.axis = .horizontal
        stackviewHor.alignment = .center
        stackviewHor.distribution = .fillProportionally
        stackviewHor.spacing = 10
        view.addSubview(stackviewHor)
        stackviewHor.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.centerY.equalToSuperview()
        }
        
        return view
    }
    
    func buildWrapperMessage(withMessage message: String, title: String = "", type: ToastType, duration: UInt64? = 0) -> UIView {
        var wrapperFrame = CGRect(x: 0, y: UIScreen.main.bounds.size.height - 80, width: UIScreen.main.bounds.size.width, height: 100)
        wrapperFrame = CGRect(x: 0, y: 64, width: UIScreen.main.bounds.size.width, height: 100)
        
        var layoutView = UIView()
        layoutView = buildBannerLayout(withWrapperFrame: wrapperFrame, message: message, title: title, type: type)
        
        let wrapper = UIView(frame: wrapperFrame)
        wrapper.tag = 777
        wrapper.backgroundColor = .clear

        wrapper.addSubview(layoutView)
        wrapper.clipsToBounds = true
        
        if let d = duration, d > 0 {
            let time = DispatchTime.now() + DispatchTimeInterval.milliseconds(Int(d * 1000))
            DispatchQueue.main.asyncAfter(deadline: time) {
                self.removeMessageBottomView()
            }
        }
        return wrapper
    }
    
    func removeMessageView() {
        let window = UIApplication.shared.keyWindow
        guard let windowToaster = window else { return }
        guard let wrapperToast = windowToaster.viewWithTag(777) else { return }
        guard let toaster = wrapperToast.viewWithTag(778) else { return }
        
        UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseInOut], animations: {
            toaster.frame.origin.y = -80
        }) { (_) in
            toaster.removeFromSuperview()
            wrapperToast.removeFromSuperview()
        }
    }
    
    func removeMessageBottomView() {
        let window = UIApplication.shared.keyWindow
        guard let windowToaster = window else { return }
        guard let wrapperToast = windowToaster.viewWithTag(777) else { return }
        guard let toaster = wrapperToast.viewWithTag(778) else { return }
        
        UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseInOut], animations: {
            toaster.frame.origin.y = wrapperToast.bounds.size.height + 10
        }) { (_) in
            toaster.removeFromSuperview()
            wrapperToast.removeFromSuperview()
        }
    }
    
    func showMessage(_ message: String, title: String, duration: UInt64, type: ToastType) {
        let window = UIApplication.shared.keyWindow
        guard let windowToaster = window else { return }
        let toaster = buildWrapperMessage(withMessage: message, title: title, type: type)
        windowToaster.addSubview(toaster)
        
        guard let toastView = windowToaster.viewWithTag(778) else { return }
        
        UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseInOut], animations: {
            toastView.frame.origin.y = 10
        }, completion: nil)
        
        let time = DispatchTime.now() + DispatchTimeInterval.milliseconds(Int(duration * 1000))
        DispatchQueue.main.asyncAfter(deadline: time) {
            self.removeMessageView()
        }
    }
}
