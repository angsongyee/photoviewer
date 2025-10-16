package com.songyee.photo_viewer

import android.os.Bundle
import androidx.core.view.WindowCompat
import android.net.Uri
import android.provider.DocumentsContract
import androidx.activity.result.contract.ActivityResultContracts.OpenDocumentTree
import io.flutter.Log
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import androidx.core.net.toUri
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.MainScope
import kotlinx.coroutines.launch

class MainActivity : FlutterFragmentActivity() {
    private val CHANNEL = "photoviewer/channels"
    private var channelResult: MethodChannel.Result? = null

    private val activityScope = MainScope();
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
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
            // This method is invoked on the main thread.
                call, result ->
            when (call.method) {
                "chooseDirectory" -> {
                    this.channelResult = result
                    getDirectoryIntent.launch(null)
                }
                "getImages" -> {
                    val directoryUriString = call.argument<String>("directoryUri")
                    if (directoryUriString == null) {
                        result.error("MISSING_ARG", "directoryUri argument is missing", null)
                        return@setMethodCallHandler
                    }
                    // Call the new function to get image URIs
                    activityScope.launch(Dispatchers.IO) {
                        val imageUris = getImagesInDirectory(directoryUriString)
                        result.success(imageUris)
                    }
                }
                "getImageBytes" -> {
                    val imageUriString = call.argument<String>("imageUri")
                    if (imageUriString == null) {
                        result.error("MISSING_ARG", "imageUri argument is missing", null)
                        return@setMethodCallHandler
                    }
                    activityScope.launch(Dispatchers.IO) {
                        val imageUri = imageUriString.toUri()
                        val inputStream = contentResolver.openInputStream(imageUri)
                        if (inputStream != null) {
                            val bytes = inputStream.readBytes()
                            inputStream.close()
                            result.success(bytes)
                        }
                    }
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
    }

    private fun getImagesInDirectory(directoryUriString: String): List<String> {
        val imageUris = mutableListOf<String>()
        val directoryUri = directoryUriString.toUri()

        val childrenUri = DocumentsContract.buildChildDocumentsUriUsingTree(
            directoryUri,
            DocumentsContract.getTreeDocumentId(directoryUri)
        )

        val projection = arrayOf(
            DocumentsContract.Document.COLUMN_DOCUMENT_ID,
            DocumentsContract.Document.COLUMN_MIME_TYPE
        )

        contentResolver.query(
            childrenUri,
            projection,
            null,
            null,
            null
        )?.use { cursor ->
            val idColumn = cursor.getColumnIndexOrThrow(DocumentsContract.Document.COLUMN_DOCUMENT_ID)
            val mimeTypeColumn = cursor.getColumnIndexOrThrow(DocumentsContract.Document.COLUMN_MIME_TYPE)

            while (cursor.moveToNext()) {
                val mimeType = cursor.getString(mimeTypeColumn)
                if (mimeType != null && mimeType.startsWith("image/")) {
                    val documentId = cursor.getString(idColumn)
                    val documentUri = DocumentsContract.buildDocumentUriUsingTree(directoryUri, documentId)
                    imageUris.add(documentUri.toString())
                }
            }
        }

        return imageUris
    }

}
