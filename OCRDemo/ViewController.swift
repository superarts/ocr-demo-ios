//
//  ViewController.swift
//  OCRDemo
//
//  Created by Leo.Liu on 5/10/16.
//  Copyright © 2016 VML. All rights reserved.
//

import UIKit
import TesseractOCR
import AVFoundation

class ViewController: UIViewController, G8TesseractDelegate {
	@IBOutlet var viewCapture: UIView!
	@IBOutlet var textRecognized: UITextView!
	@IBOutlet var imageCapture: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
		initOCR()
	}
    override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated)
		initCapture()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

	var tesseract: G8Tesseract?
    func initOCR() {
		if let tess = G8Tesseract(language:"eng") {
			//tess.language = "eng+ita"
			tess.delegate = self
			tess.charWhitelist = "QWERTYUIOPASDFGHJKLLZXCVBNMqwertyuiopasdfghjklzxcvbnm0123456789,.:!"
			//tess.charWhitelist = "0123456789"
			//tess.image = UIImage(named: "sample.png")
			//tess.recognize()
			//print("OCR text from \(tess): \(tess.recognizedText)")
			tesseract = tess
		}
    }
	func shouldCancelImageRecognitionForTesseract(tesseract: G8Tesseract!) -> Bool {
		print("OCR should cancel \(tesseract)")
		dispatch_async(dispatch_get_main_queue()) {
			self.textRecognized.text = self.textRecognized.text + "."
		}
        return false
    }

    let captureSession = AVCaptureSession()
    let stillImageOutput = AVCaptureStillImageOutput()
	func initCapture() {
        let devices = AVCaptureDevice.devices().filter{ $0.hasMediaType(AVMediaTypeVideo) && $0.position == AVCaptureDevicePosition.Back }
        if let captureDevice = devices.first as? AVCaptureDevice, let input = try? AVCaptureDeviceInput(device: captureDevice) {
			captureSession.addInput(input)
			captureSession.sessionPreset = AVCaptureSessionPresetPhoto
			captureSession.startRunning()
			stillImageOutput.outputSettings = [AVVideoCodecKey:AVVideoCodecJPEG]
			if captureSession.canAddOutput(stillImageOutput) {
				captureSession.addOutput(stillImageOutput)
			}
			if let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession) {
				previewLayer.bounds = viewCapture.bounds
				previewLayer.position = CGPointMake(viewCapture.bounds.midX, viewCapture.bounds.midY)
				previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
				viewCapture.layer.addSublayer(previewLayer)
				//let cameraPreview = UIView(frame: viewCapture.bounds)
				//print("CAPTURE view: \(cameraPreview)")
				//cameraPreview.layer.addSublayer(previewLayer)
				//cameraPreview.addGestureRecognizer(UITapGestureRecognizer(target: self, action:"actionScanCamera:"))
				//viewCapture.addSubview(cameraPreview)
			}
        }
	}
    @IBAction func actionScanCamera(sender: AnyObject) {
        if let videoConnection = stillImageOutput.connectionWithMediaType(AVMediaTypeVideo) {
            stillImageOutput.captureStillImageAsynchronouslyFromConnection(videoConnection) {
                (imageDataSampleBuffer, error) -> Void in
                let data = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(imageDataSampleBuffer)
				let image = UIImage(data: data)
				self.imageCapture.image = image
                //UIImageWriteToSavedPhotosAlbum(UIImage(data: data), nil, nil, nil)
			
				if let tess = self.tesseract {
					self.textRecognized.text = "Processing..."
					dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
						tess.image = image
						tess.recognize()
						print("OCR text from \(tess): \(tess.recognizedText)")
						dispatch_async(dispatch_get_main_queue()) {
							self.textRecognized.text = tess.recognizedText
						}
					}
				}
            }
        }
    }
}
