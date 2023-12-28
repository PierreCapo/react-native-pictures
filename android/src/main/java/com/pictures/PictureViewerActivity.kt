package com.pictures

import android.app.Activity
import android.os.Bundle
import android.graphics.BitmapFactory
import android.graphics.Color
import android.view.Gravity
import android.widget.FrameLayout
import android.widget.ImageView
import com.github.chrisbanes.photoview.PhotoView
import java.net.HttpURLConnection
import java.net.URL

class PictureViewerActivity : Activity() {
  override fun onCreate(savedInstanceState: Bundle?) {
    super.onCreate(savedInstanceState)
    // Set the layout for the activity
    // Create a LinearLayout
    // Create a FrameLayout

    val frameLayout = FrameLayout(this).apply {
      layoutParams = FrameLayout.LayoutParams(
        FrameLayout.LayoutParams.MATCH_PARENT,
        FrameLayout.LayoutParams.MATCH_PARENT
      )
      setBackgroundColor(Color.WHITE)
    }

    // Create and configure PhotoView
    val imageUrl = intent.getStringExtra("imageUrl")
    val imageView = PhotoView(this).apply {
      layoutParams = FrameLayout.LayoutParams(
        FrameLayout.LayoutParams.MATCH_PARENT,
        FrameLayout.LayoutParams.MATCH_PARENT
      )
    }

    // Add PhotoView to FrameLayout
    frameLayout.addView(imageView)

    // Create and configure Close Button
    val closeButton = ImageView(this).apply {
      layoutParams = FrameLayout.LayoutParams(
        FrameLayout.LayoutParams.WRAP_CONTENT,
        FrameLayout.LayoutParams.WRAP_CONTENT
      ).also {
        it.gravity = Gravity.TOP or Gravity.END
        it.setMargins(0, 30, 30, 0) // Adjust margins as needed
      }
      setImageResource(android.R.drawable.ic_menu_close_clear_cancel) // Use a suitable close icon
      setOnClickListener {
        finish() // Close the activity
      }
    }
    closeButton.setColorFilter(Color.BLACK)

    // Add Close Button to FrameLayout
    frameLayout.addView(closeButton)

    // Set FrameLayout as the content view
    setContentView(frameLayout)

    Thread {
      try {
        val url = URL(imageUrl)
        val connection = url.openConnection() as HttpURLConnection
        connection.doInput = true
        connection.connect()
        val inputStream = connection.inputStream
        val bitmap = BitmapFactory.decodeStream(inputStream)

        runOnUiThread {
          imageView.setImageBitmap(bitmap)
        }
      } catch (e: Exception) {
        e.printStackTrace()
        // Handle exceptions
      }
    }.start()
  }
}
