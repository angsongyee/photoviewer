package com.songyee.photo_viewer

import android.os.Bundle // Added import
import androidx.core.view.WindowCompat // Added import
import io.flutter.embedding.android.FlutterActivity

class MainActivity : FlutterActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        WindowCompat.setDecorFitsSystemWindows(window, false)
    }
}
