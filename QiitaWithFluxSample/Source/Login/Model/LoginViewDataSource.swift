//
//  LoginViewDataSource.swift
//  QiitaWithFluxSample
//
//  Created by marty-suzuki on 2017/04/17.
//  Copyright © 2017年 marty-suzuki. All rights reserved.
//

import UIKit
import RxSwift
import WebKit

final class LoginViewDataSource: NSObject {
    
    let viewModel: LoginViewModel
    let requestAccessTokenWithCode: Observable<String>
    fileprivate let _requestAccessTokenWithCode = PublishSubject<String>()
    
    init(viewModel: LoginViewModel) {
        self.viewModel = viewModel
        self.requestAccessTokenWithCode = _requestAccessTokenWithCode
    }
}

extension LoginViewDataSource: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Swift.Void) {
        guard let url = navigationAction.request.url else {
            decisionHandler(.cancel)
            return
        }
        if url.absoluteString.hasPrefix(Config.shared.redirectUrl) {
            guard
                let URLComponents = URLComponents(string: url.absoluteString),
                let items = URLComponents.queryItems,
                let codeItem = items.filter({ $0.name == "code"}).first,
                let code = codeItem.value
            else {
                fatalError("can not find \"code\" from URL query")
            }
            
            _requestAccessTokenWithCode.onNext(code)
            decisionHandler(.cancel)
            return
        }
        decisionHandler(.allow)
    }
}
