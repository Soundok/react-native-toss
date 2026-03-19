import Foundation
import UIKit
import TossLogin
import TossFoundation

@objc(TossLoginBridge)
public class TossLoginBridge: NSObject {

  @objc public static let shared = TossLoginBridge()

  @objc public func configure(appKey: String) {
    TossSDK.shared.initSDK(appKey: appKey)
  }

  @objc public func isLoginAvailable() -> Bool {
    return TossLoginController.shared.isLoginAvailable
  }

  @objc public func moveToBridgePageForNoApp() {
    TossLoginController.shared.moveToBridgePageForNoApp()
  }

  @objc public func login(
    policy: String?,
    completion: @escaping (
      _ authCode: String?,
      _ errorCode: String?,
      _ errorMessage: String?,
      _ cancelled: Bool
    ) -> Void
  ) {
    TossLoginController.shared.login(policy: policy) { result in
      switch result {
      case let .success(authCode):
        completion(authCode, nil, nil, false)
      case let .error(error):
        completion(nil, error.code, error.message, false)
      case .cancelled:
        completion(nil, nil, nil, true)
      }
    }
  }

  @objc public func isCallbackURL(_ url: URL) -> Bool {
    return TossLoginController.shared.isCallbackURL(url)
  }

  @objc public func handleOpenUrl(_ url: URL) -> Bool {
    return TossLoginController.shared.handleOpenUrl(url)
  }
}
