package com.example.signlink_app

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

import android.util.Size
import androidx.camera.core.*
import androidx.camera.lifecycle.ProcessCameraProvider
import androidx.core.content.ContextCompat
import android.annotation.SuppressLint

import com.google.mediapipe.tasks.vision.core.RunningMode
import com.google.mediapipe.tasks.vision.handlandmarker.HandLandmarker
import com.google.mediapipe.tasks.vision.handlandmarker.HandLandmarkerResult
import com.google.mediapipe.tasks.core.BaseOptions
import com.google.mediapipe.framework.image.BitmapImageBuilder

import android.graphics.Bitmap

class MainActivity: FlutterActivity() {
    private val CHANNEL = "signlink/hands"
    private lateinit var methodChannel: MethodChannel

    private var imageAnalyzer: ImageAnalysis? = null
    private var handLandmarker: HandLandmarker? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        methodChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
        methodChannel.setMethodCallHandler { call, result ->
            when (call.method) {
                "start" -> {
                    if (handLandmarker == null) {
                        setupHandLandmarker()
                    }
                    startCamera()
                    result.success(true)
                }
                "stop"  -> { stopCamera();  result.success(true) }
                else -> result.notImplemented()
            }
        }
    }

    private fun setupHandLandmarker() {
        val baseOptions = BaseOptions.builder()
            .setModelAssetPath("hand_landmarker.task")
            .build()

        val options = HandLandmarker.HandLandmarkerOptions.builder()
            .setBaseOptions(baseOptions)
            .setMinHandDetectionConfidence(0.5f)
            .setMinHandPresenceConfidence(0.5f)
            .setMinTrackingConfidence(0.5f)
            .setNumHands(1)
            .setRunningMode(RunningMode.LIVE_STREAM)
            .setResultListener { result, _ -> onHands(result) }
            .build()

        handLandmarker = HandLandmarker.createFromOptions(this, options)
    }

    @SuppressLint("UnsafeOptInUsageError")
    private fun startCamera() {
        val providerFuture = ProcessCameraProvider.getInstance(this)
        providerFuture.addListener({
            val provider = providerFuture.get()
            val selector = CameraSelector.DEFAULT_FRONT_CAMERA

            imageAnalyzer = ImageAnalysis.Builder()
                .setTargetResolution(Size(640, 480))
                .setBackpressureStrategy(ImageAnalysis.STRATEGY_KEEP_ONLY_LATEST)
                .build().also { analysis ->
                    analysis.setAnalyzer(ContextCompat.getMainExecutor(this)) { imageProxy ->
                        val bitmap = imageProxyToBitmap(imageProxy)
                        if (bitmap != null) {
                            val mpImage = BitmapImageBuilder(bitmap).build()
                            handLandmarker?.detectAsync(mpImage, System.nanoTime())
                        }
                        imageProxy.close()
                    }
                }

            provider.unbindAll()
            provider.bindToLifecycle(this, selector, imageAnalyzer)
        }, ContextCompat.getMainExecutor(this))
    }

    private fun stopCamera() {
        val provider = ProcessCameraProvider.getInstance(this).get()
        provider.unbindAll()
    }

    private fun onHands(result: HandLandmarkerResult) {
        if (result.landmarks().isEmpty()) {
            methodChannel.invokeMethod("landmarks", emptyList<List<Double>>())
            return
        }
        val first = result.landmarks()[0]
        val pts = first.map { listOf(it.x().toDouble(), it.y().toDouble(), it.z().toDouble()) }
        methodChannel.invokeMethod("landmarks", listOf(pts))
    }

    private fun imageProxyToBitmap(image: ImageProxy): Bitmap? {
        return YuvToRgbConverter(this).yuvToRgb(image)
    }
}
