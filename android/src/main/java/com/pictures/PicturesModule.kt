package com.pictures

import android.content.Intent
import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.bridge.ReactContextBaseJavaModule
import com.facebook.react.bridge.ReactMethod
import com.facebook.react.bridge.Promise

class PicturesModule(reactContext: ReactApplicationContext) :
  ReactContextBaseJavaModule(reactContext) {

  override fun getName(): String {
    return NAME
  }

  // Example method
  // See https://reactnative.dev/docs/native-modules-android
  @ReactMethod
  fun openPictureViewer(url: String, promise: Promise) {
    val intent = Intent(reactApplicationContext, PictureViewerActivity::class.java)
    intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
    intent.putExtra("imageUrl", url)
    reactApplicationContext.startActivity(intent)
    promise.resolve(null)
  }

  companion object {
    const val NAME = "Pictures"
  }
}
