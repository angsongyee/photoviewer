package com.songyee.photo_viewer

import android.os.Bundle
import androidx.core.view.WindowCompat
import android.net.Uri
import androidx.activity.result.contract.ActivityResultContracts.OpenDocumentTree
import androidx.annotation.NonNull
import io.flutter.Log
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterFragmentActivity() {
    private val CHANNEL = "photoviewer/channels"
    private var channelResult: MethodChannel.Result? = null
    private val getDirectoryIntent = registerForActivityResult(OpenDocumentTree()) { uri: Uri? ->
        uri?.let {
            channelResult?.success(it.toString())
            Log.d("DirectorySelector", "Selected directory URI: $uri")
        } ?: run {
            channelResult?.error("PICKER_CANCELLED", "User cancelled the directory picker", null)
        }
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        WindowCompat.setDecorFitsSystemWindows(window, false)
        //getDirectoryIntent.launch(null)
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
            // This method is invoked on the main thread.
                call, result ->
            if (call.method == "chooseDirectory") {
                this.channelResult = result
                getDirectoryIntent.launch(null)
            } else {
                result.notImplemented()
            }
        }
    }

}
