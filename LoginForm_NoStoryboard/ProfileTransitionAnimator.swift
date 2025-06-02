import UIKit

class ProfileTransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    let duration = 0.5
    var presenting = true

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard
            let fromVC = transitionContext.viewController(forKey: .from),
            let toVC = transitionContext.viewController(forKey: .to)
        else {
            transitionContext.completeTransition(false)
            return
        }

        let containerView = transitionContext.containerView

        if presenting {
            containerView.addSubview(toVC.view)
            toVC.view.alpha = 0
            toVC.view.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)

            UIView.animate(withDuration: duration, animations: {
                toVC.view.alpha = 1
                toVC.view.transform = .identity
            }) { finished in
                transitionContext.completeTransition(finished)
            }
        } else {
            UIView.animate(withDuration: duration, animations: {
                fromVC.view.alpha = 0
                fromVC.view.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            }) { finished in
                fromVC.view.removeFromSuperview()
                transitionContext.completeTransition(finished)
            }
        }
    }
}
