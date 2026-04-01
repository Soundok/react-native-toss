package com.toss

import com.facebook.react.bridge.Promise
import com.facebook.react.bridge.ReactApplicationContext
import com.vivarepublica.loginsdk.TossLoginController
import com.vivarepublica.loginsdk.model.TossLoginResult
import com.vivarepublica.loginsdk.TossSdk

class TossModule(reactContext: ReactApplicationContext) :
  NativeTossSpec(reactContext) {

  override fun configure(appKey: String) {
    TossSdk.init(appKey)
  }

  override fun isLoginAvailable(promise: Promise) {
    val activity = currentActivity
    if (activity == null) {
      promise.resolve(false)
      return
    }
    promise.resolve(TossLoginController.isLoginAvailable(activity))
  }

  override fun login(policy: String?, promise: Promise) {
    val activity = currentActivity
    if (activity == null) {
      promise.reject("NO_ACTIVITY", "Activity is not available")
      return
    }

    TossLoginController.login(activity, policy) { result ->
      when (result) {
        is TossLoginResult.Success -> {
          promise.resolve(result.authCode)
        }
        is TossLoginResult.Error -> {
          promise.reject(result.error.code, result.error.message)
        }
        TossLoginResult.Cancelled -> {
          promise.reject("CANCELLED", "User cancelled login")
        }
      }
    }
  }

  override fun moveToBridgePageForNoApp() {
    // Android에서는 토스앱 미설치 시 Play Store로 이동합니다.
    val activity = currentActivity ?: return
    TossLoginController.moveToPlaystore(activity)
  }

  override fun handleOpenUrl(url: String, promise: Promise) {
    // Android에서는 AuthCodeHandlerActivity가 URL 콜백을 자동으로 처리합니다.
    promise.resolve(false)
  }

  companion object {
    const val NAME = NativeTossSpec.NAME
  }
}
