
import Lottie
import UIKit

public class LottieAnimationManager {
    
    //MARK: - GenericAnimationMethod
    public class func showAnimation(onView animationBackgroundView: UIView, withJsonFileName animationPath: String, removeFromSuper: Bool = true, loopMode: LottieLoopMode = .playOnce, completion: @escaping (Bool) -> ()) {
        let animationView = LottieAnimationView()
        
        animationView.animation = LottieAnimation.named(animationPath)
        
        if animationView.animation != nil {
            animationView.contentMode = .scaleAspectFit
            animationView.backgroundBehavior = .pauseAndRestore
            animationView.loopMode = loopMode
            //            animationView.frame.size = animationBackgroundView.frame.size
            animationBackgroundView.addSubview(animationView)
            
            animationView.translatesAutoresizingMaskIntoConstraints = false
            animationView.topAnchor.constraint(equalTo: animationBackgroundView.topAnchor).isActive = true
            animationView.bottomAnchor.constraint(equalTo: animationBackgroundView.bottomAnchor).isActive = true
            animationView.leadingAnchor.constraint(equalTo: animationBackgroundView.leadingAnchor).isActive = true
            animationView.trailingAnchor.constraint(equalTo: animationBackgroundView.trailingAnchor).isActive = true
            //            animationView.centerXAnchor.constraint(equalTo: animationBackgroundView.superview!.centerXAnchor).isActive = true
            
            animationView.play { _ in
                if removeFromSuper {
                    animationView.removeFromSuperview()
                }
                completion(true)
            }
        }
        else {
            completion(false)
        }
    }
    
    public class func showAnimationForOrders(onView animationBackgroundView: UIView, withJsonFileName animationPath: String, removeFromSuper: Bool = true, loopMode: LottieLoopMode = .playOnce, completion: @escaping (Bool) -> ()) {
        let animationView = LottieAnimationView()
        animationBackgroundView.subviews.forEach { $0.removeFromSuperview() }
        
        animationView.animation = LottieAnimation.named(animationPath)
        if animationView.animation != nil {
            animationView.contentMode = .scaleAspectFit
            animationView.backgroundBehavior = .pauseAndRestore
            animationView.loopMode = loopMode
            //            animationView.frame.size = animationBackgroundView.frame.size
            animationBackgroundView.addSubview(animationView)
            
            animationView.translatesAutoresizingMaskIntoConstraints = false
            animationView.topAnchor.constraint(equalTo: animationBackgroundView.topAnchor).isActive = true
            animationView.bottomAnchor.constraint(equalTo: animationBackgroundView.bottomAnchor).isActive = true
            animationView.leadingAnchor.constraint(equalTo: animationBackgroundView.leadingAnchor).isActive = true
            animationView.trailingAnchor.constraint(equalTo: animationBackgroundView.trailingAnchor).isActive = true
            //            animationView.centerXAnchor.constraint(equalTo: animationBackgroundView.superview!.centerXAnchor).isActive = true
            
            animationView.play { _ in
                if removeFromSuper {
                    animationView.removeFromSuperview()
                }
                completion(true)
            }
        }
        else {
            completion(false)
        }
    }
    
    
    public class func showAnimationFromUrl(FromUrl url: URL, animationBackgroundView: UIView, removeFromSuper: Bool = true, loopMode: LottieLoopMode = .playOnce, contentMode: UIView.ContentMode = .scaleAspectFit, shouldAnimate: Bool = true, animationPrepared:LottieAnimation.DownloadClosure?=nil, completion: @escaping (Bool) -> ()) {
        
        LottieAnimation.loadedFrom(url: url, closure: { (animation) in
            animationPrepared?(animation)
            if (animation != nil){
                let animationView = LottieAnimationView()
                animationView.animation = animation
                animationView.contentMode = contentMode
                animationView.backgroundBehavior = .pauseAndRestore
                animationView.loopMode = loopMode
                animationBackgroundView.addSubview(animationView)
                
                animationView.translatesAutoresizingMaskIntoConstraints = false
                animationView.topAnchor.constraint(equalTo: animationBackgroundView.topAnchor).isActive = true
                animationView.bottomAnchor.constraint(equalTo: animationBackgroundView.bottomAnchor).isActive = true
                animationView.leadingAnchor.constraint(equalTo: animationBackgroundView.leadingAnchor).isActive = true
                animationView.trailingAnchor.constraint(equalTo: animationBackgroundView.trailingAnchor).isActive = true
                
                if shouldAnimate {
                    animationView.play { _ in
                        if removeFromSuper {
                            animationView.removeFromSuperview()
                        }
                        completion(true)
                    }
                } else {
                    if removeFromSuper {
                        animationView.removeFromSuperview()
                    }
                    completion(true)
                }
            }
            else{
                completion(false)
            }
        }, animationCache: LRUAnimationCache.sharedCache)
    }
}
