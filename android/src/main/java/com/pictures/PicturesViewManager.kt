package com.pictures

import android.view.View
import com.facebook.react.uimanager.SimpleViewManager
import com.facebook.react.uimanager.ThemedReactContext
import com.facebook.react.uimanager.annotations.ReactProp
import android.content.Context
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.widget.FrameLayout
import com.github.chrisbanes.photoview.PhotoView
import java.net.HttpURLConnection
import java.net.URL

class PicturesViewManager : SimpleViewManager<PicturesView>() {
  override fun getName() = "PicturesView"

  override fun createViewInstance(reactContext: ThemedReactContext): PicturesView {
    return PicturesView(reactContext)
  }

  @ReactProp(name = "imageUrl")
  fun setImageUrl(view: PicturesView, imageUrl: String) {
    view.loadImage(imageUrl)
  }

}

class PicturesView(context: Context) : FrameLayout(context) {

  private val imageView: PhotoView = PhotoView(context).apply {
    layoutParams = LayoutParams(
      LayoutParams.MATCH_PARENT,
      LayoutParams.MATCH_PARENT
    )
  }

  init {
    addView(imageView)
  }

  fun loadImage(imageUrl: String) {
    // Load the image similarly as in your activity
    Thread {
      try {
        val url = URL(imageUrl)
        val connection = url.openConnection() as HttpURLConnection
        connection.doInput = true
        connection.connect()
        val inputStream = connection.inputStream
        val originalBitmap = BitmapFactory.decodeStream(inputStream)

        // Resize the bitmap to avoid Bitmap being too big and causing a crash
        val aspectRatio = originalBitmap.width.toFloat() / originalBitmap.height.toFloat()
        val targetWidth = imageView.width // You might want to adjust this
        val targetHeight = (targetWidth / aspectRatio).toInt()

        val resizedBitmap =
          Bitmap.createScaledBitmap(originalBitmap, targetWidth, targetHeight, false)


        post {
          imageView.setImageBitmap(resizedBitmap)
        }
      } catch (e: Exception) {
        e.printStackTrace()
        // Handle exceptions
      }
    }.start()
  }
}

