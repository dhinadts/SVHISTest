package com.servicedx.sdxcontact

import android.util.Log
import io.agora.rtc.ss.ScreenSharingClient
import io.agora.rtc.ss.ScreenSharingClient.IStateListener
import io.agora.rtc.video.VideoEncoderConfiguration
import io.agora.rtc.video.VideoEncoderConfiguration.STANDARD_BITRATE
import io.agora.rtc.video.VideoEncoderConfiguration.VD_840x480
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val CHANNEL = "flutter.native/screen_share_helper"
    private lateinit var mSSClient: ScreenSharingClient
    private var isSharing = false

    override fun onDestroy() {
        super.onDestroy()
        if (mSSClient != null) {
            mSSClient.stop(context)
        }
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        println("configureFlutterEngine called...")
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler{
            call, result ->
            if(call.method == "createMediaProjection"){
                println("createMediaProjection called...")
                try {
                    // Initialize Screen Share Client
                    mSSClient = ScreenSharingClient.getInstance()
                    mSSClient.setListener(mListener)
                } catch (e: Exception) {
                    e.printStackTrace()
                    activity.onBackPressed()
                }

                val appId = call.argument<String>("appId")
                val appToken = call.argument<String>("appToken")
                val channelName = call.argument<String>("channelName")
                val userFullName = call.argument<String>("userFullName")
                val screenShareUid = call.argument<Int>("screenShareUid")

                if(!isSharing){
                    print("START SHARE");
                    if (screenShareUid != null) {
                        mSSClient.start(context, appId, appToken, channelName, screenShareUid, userFullName, VideoEncoderConfiguration(
                                VD_840x480,
                                VideoEncoderConfiguration.FRAME_RATE.FRAME_RATE_FPS_24,
                                STANDARD_BITRATE,
                                VideoEncoderConfiguration.ORIENTATION_MODE.ORIENTATION_MODE_ADAPTIVE
                        ))
                        isSharing = true
                    }
                }else{
                    if(mSSClient != null) {
                        mSSClient.stop(context)
                        isSharing = false

                        if (screenShareUid != null) {
                            mSSClient.start(context, appId, appToken, channelName, screenShareUid, userFullName, VideoEncoderConfiguration(
                                    VD_840x480,
                                    VideoEncoderConfiguration.FRAME_RATE.FRAME_RATE_FPS_24,
                                    STANDARD_BITRATE,
                                    VideoEncoderConfiguration.ORIENTATION_MODE.ORIENTATION_MODE_ADAPTIVE
                            ))
                            isSharing = true
                        }
                    }
                }

                result.success(true)
            }else if(call.method == "destroyMediaProjection") {
                println("destroyMediaProjection called...")
                if(mSSClient != null){
                    mSSClient.stop(context)
                    isSharing = false
                }
                result.success(true)
            }
        }
    }

    private val mListener: IStateListener = object : IStateListener {
        override fun onError(error: Int) {
            Log.e("mListener", "Screen share service error happened: $error")
        }

        override fun onTokenWillExpire() {
            Log.d("mListener", "Screen share service token will expire")
            mSSClient!!.renewToken(null) // Replace the token with your valid token
        }
    }
}
