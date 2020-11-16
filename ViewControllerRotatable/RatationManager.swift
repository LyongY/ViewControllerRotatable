//
//  RatationManager.swift
//  ViewControllerRotatable
//
//  Created by Raysharp666 on 2020/6/17.
//  Copyright © 2020 Raysharp. All rights reserved.
//

import UIKit

// MARK: - RotationManager: appdelegate User
class RotationManager {
    enum RotatableInterfaceOrientationMask: UInt {
        case portrait
        case landscape
        case allButUpsideDown
        
        var convert: UIInterfaceOrientationMask {
            switch self {
            case .landscape:
                return .landscape
            case .portrait:
                return .portrait
            default:
                return .allButUpsideDown
            }
        }
    }
    static let shared: RotationManager = RotationManager()
    var interfaceOrientationMask: RotatableInterfaceOrientationMask = .portrait
    private init() {

    }
}

// MARK: - Protocol: UIViewController遵守
/*
 P: Portraitable
 UP: Unsupport Portrait
 L: Landscapable
 只支持竖屏: P
 只支持横屏: P & UP & L
 竖屏和横屏: P & L
 */
private protocol PortraitOnly {}    // P
protocol PortraitUnsupport {}       // UP
protocol PortraitAndLandscape {}    // L

typealias LandscapeOnly = PortraitUnsupport&PortraitAndLandscape


extension UIViewController: PortraitOnly {}
extension UIViewController {
    func autoAdaptOrientation() {
        let statusBarOrientation = UIApplication.shared.statusBarOrientation
        if self is PortraitOnly&LandscapeOnly { // LandOnly
            print("landonly")
            RotationManager.shared.interfaceOrientationMask = .landscape
            if statusBarOrientation == .portrait {
                UIDevice.current.setValue(NSNumber(value: UIDeviceOrientation.unknown.rawValue), forKey: "orientation")
                UIDevice.current.setValue(NSNumber(value: UIDeviceOrientation.landscapeLeft.rawValue), forKey: "orientation")
            }
        } else if self is PortraitOnly&PortraitAndLandscape { // PortraitAndLandscape
            print("PortraitAndLandscape")
            RotationManager.shared.interfaceOrientationMask = .allButUpsideDown
        } else { // PortraitOnly
            print("PortraitOnly")
            RotationManager.shared.interfaceOrientationMask = .portrait
            if statusBarOrientation != .portrait {
                UIDevice.current.setValue(NSNumber(value: UIDeviceOrientation.unknown.rawValue), forKey: "orientation")
                UIDevice.current.setValue(NSNumber(value: UIDeviceOrientation.portrait.rawValue), forKey: "orientation")
            }
        }
    }
}


// MARK: - NavigationController默认处理
class BaseNavigationController: UINavigationController {
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        defer {
            autoAdaptInteractivePopGestureRecognizerAndOrientation()
        }
        super.pushViewController(viewController, animated: animated)
    }
    
    override func popViewController(animated: Bool) -> UIViewController? {
        defer {
            autoAdaptInteractivePopGestureRecognizerAndOrientation()
        }
        return super.popViewController(animated: animated)
    }

    override func popToViewController(_ viewController: UIViewController, animated: Bool) -> [UIViewController]? {
        defer {
            autoAdaptInteractivePopGestureRecognizerAndOrientation()
        }
        return super.popToViewController(viewController, animated: animated)
    }

    override func popToRootViewController(animated: Bool) -> [UIViewController]? {
        defer {
            autoAdaptInteractivePopGestureRecognizerAndOrientation()
        }
        return super.popToRootViewController(animated: animated)
    }
        
    private func autoAdaptInteractivePopGestureRecognizerAndOrientation() {
        if self.interactivePopGestureRecognizer?.state == .began {
            DispatchQueue.global().async {
                var state: UIGestureRecognizer.State = .began
                while !(state == .ended || state == .failed || state == .cancelled || state == .possible) {
                    DispatchQueue.main.sync {
                        let ges = self.interactivePopGestureRecognizer!
                        state = ges.state
                    }
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.autoAdaptInteractivePopGestureRecognizerAndOrientation()
                }
            }
            return
        }
        
        var previseSupport: RotationManager.RotatableInterfaceOrientationMask = .portrait
        var currentSupport: RotationManager.RotatableInterfaceOrientationMask = .portrait
        if self.viewControllers.count < 2 {
            self.interactivePopGestureRecognizer?.isEnabled = false
            return
        }
        let previseController = self.viewControllers[self.viewControllers.count - 2]
        if previseController is PortraitOnly&LandscapeOnly { // LandOnly
            previseSupport = .landscape
        } else if previseController is PortraitOnly&PortraitAndLandscape { // PortraitAndLandscape
            previseSupport = .allButUpsideDown
        }
        let statusBarOrientation = UIApplication.shared.statusBarOrientation
        if statusBarOrientation == .landscapeLeft || statusBarOrientation == .landscapeRight {
            currentSupport = .landscape
        }
        self.interactivePopGestureRecognizer?.isEnabled = previseSupport.convert.contains(currentSupport.convert)
        self.topViewController?.autoAdaptOrientation()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        autoAdaptInteractivePopGestureRecognizerAndOrientation()
    }
    
}
