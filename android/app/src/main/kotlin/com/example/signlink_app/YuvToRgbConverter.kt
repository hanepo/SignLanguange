package com.example.signlink_app

import android.content.Context
import android.graphics.Bitmap
import android.graphics.ImageFormat
import android.graphics.Rect
import android.graphics.YuvImage
import androidx.camera.core.ImageProxy
import java.io.ByteArrayOutputStream
import java.nio.ByteBuffer

class YuvToRgbConverter(private val context: Context) {
    fun yuvToRgb(image: ImageProxy): Bitmap? {
        val yPlane = image.planes[0].buffer.toByteArray()
        val uPlane = image.planes[1].buffer.toByteArray()
        val vPlane = image.planes[2].buffer.toByteArray()

        // NV21 packing
        val ySize = yPlane.size
        val uvSize = uPlane.size + vPlane.size
        val nv21 = ByteArray(ySize + uvSize)

        // Y
        System.arraycopy(yPlane, 0, nv21, 0, ySize)
        // VU (swap if needed depending on device)
        var offset = ySize
        val u = uPlane
        val v = vPlane
        for (i in v.indices step 2) {
            nv21[offset++] = v[i]
            if (i + 1 < u.size) nv21[offset++] = u[i + 1]
        }

        val yuvImage = YuvImage(nv21, ImageFormat.NV21, image.width, image.height, null)
        val out = ByteArrayOutputStream()
        yuvImage.compressToJpeg(Rect(0, 0, image.width, image.height), 75, out)
        val jpegBytes = out.toByteArray()
        return android.graphics.BitmapFactory.decodeByteArray(jpegBytes, 0, jpegBytes.size)
    }

    private fun ByteBuffer.toByteArray(): ByteArray {
        rewind()
        val data = ByteArray(remaining())
        get(data)
        return data
    }
}
