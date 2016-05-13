//
//  AppDelegate.swift
//  OCRDemo
//
//  Created by Leo.Liu on 5/10/16.
//  Copyright © 2016 VML. All rights reserved.
//

import UIKit
//import MMDrawerController
import LGSideMenuController
import FVVerticalSlideView

struct OD {
	static var app: AppDelegate!
}
typealias od = OD

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

	let storyboard = UIStoryboard(name: "Main", bundle: nil)
	var navController: NavController!
	var leftController: LeftController!
	var rightController: RightController!
	var bottomController: BottomController!
	var sideController: LGSideMenuController!

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
		od.app = self

        // Override point for customization after application launch.
		navController = storyboard.instantiateViewControllerWithIdentifier("NavController") as! NavController
		leftController = storyboard.instantiateViewControllerWithIdentifier("LeftController") as! LeftController
		rightController = storyboard.instantiateViewControllerWithIdentifier("RightController") as! RightController
		bottomController = storyboard.instantiateViewControllerWithIdentifier("BottomController") as! BottomController

		sideController = LGSideMenuController(rootViewController: navController)
		sideController.setLeftViewEnabledWithWidth(200, presentationStyle:.SlideAbove, alwaysVisibleOptions:.OnNone)
		sideController.setRightViewEnabledWithWidth(UIScreen.mainScreen().bounds.size.width, presentationStyle:.SlideAbove, alwaysVisibleOptions:.OnNone)
		sideController.rootViewCoverColorForLeftView = UIColor.clearColor()
		//sideController.swipeGestureArea = .Full
		sideController.swipeGestureArea = .Borders
		sideController.leftViewStatusBarStyle = .Default
		sideController.leftViewStatusBarVisibleOptions = .OnAll
		sideController.rightViewStatusBarStyle = .LightContent
		sideController.rightViewStatusBarVisibleOptions = .OnAll
		sideController.leftView().addSubview(leftController.view)
		sideController.rightView().addSubview(rightController.view)

		let bottom = FVVerticalSlideView(top: 0, bottom: 64, translationView: sideController.view)
		bottom.setTopY(200)
		bottom.addSubview(bottomController.view)
		sideController.view.addSubview(bottom)
		sideController.view.bringSubviewToFront(sideController.rightView())

		/*
		let drawer = MMDrawerController(centerViewController: center, leftDrawerViewController: leftController, rightDrawerViewController: rightController)
        drawer.openDrawerGestureModeMask = .All
		drawer.closeDrawerGestureModeMask = .All
		drawer.showsShadow = false
		drawer.maximumRightDrawerWidth = UIScreen.mainScreen().bounds.size.width
		drawer.setDrawerVisualStateBlock() {
			(controller, side, percent) -> Void in
			var block: MMDrawerControllerDrawerVisualStateBlock!
			if side == .Right {
				block = MMDrawerVisualState.swingingDoorVisualStateBlock()
			} else {
				block = MMDrawerVisualState.slideVisualStateBlock()
			}
			block(controller, side, percent)
		}
		*/

		window = UIWindow(frame: UIScreen.mainScreen().bounds)
		window?.rootViewController = sideController
		window?.makeKeyAndVisible()

        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}