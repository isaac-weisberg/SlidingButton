import UIKit

public struct SlidingButtonStyle {
    public let backgroundColor: UIColor
    public let slidingViewColor: UIColor
    public let actionCircleColor: UIColor
    public let actionCircleImageTint: UIColor
    public let trailingLabelTextColor: UIColor
    
    public init(backgroundColor: UIColor,
                slidingViewColor: UIColor,
                actionCircleColor: UIColor,
                actionCircleImageTint: UIColor,
                trailingLabelTextColor: UIColor) {
        self.backgroundColor = backgroundColor
        self.slidingViewColor = slidingViewColor
        self.actionCircleColor = actionCircleColor
        self.actionCircleImageTint = actionCircleImageTint
        self.trailingLabelTextColor = trailingLabelTextColor
    }
    
    public static func springGreen() -> SlidingButtonStyle {
        let middleWashedSpringGreen = UIColor(
            red: 76 / 255,
            green: 255 / 255,
            blue: 103 / 255,
            alpha: 1)
        let white = UIColor.white
        let backgroundDark = UIColor(white: 46 / 255, alpha: 1)
        return SlidingButtonStyle(backgroundColor: backgroundDark,
                           slidingViewColor: middleWashedSpringGreen,
                           actionCircleColor: white,
                           actionCircleImageTint: middleWashedSpringGreen,
                           trailingLabelTextColor: white)
    }
}

public class SlidingButton: UIView, UIScrollViewDelegate {
    private let actionCirclePadding: CGFloat = 10
    private let trailingLabelPadding: CGFloat = 22
    private let animationDuration: TimeInterval = 0.25
    
    public private(set) var actionCircleImageInsets: UIEdgeInsets = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
    public private(set) var style: SlidingButtonStyle
    
    let scrollView = UIScrollView()
    let slidingView = UIView()
    let actionCircle = UIView()
    let actionCircleImageView = UIImageView()
    let trailingLabel = UILabel()
    
    public var onTap: (() -> Void)?
    
    public init(style: SlidingButtonStyle = .springGreen()) {
        self.style = style
        super.init(frame: .zero)
        
        setup()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override var bounds: CGRect {
        didSet {
            resetOnLayout()
        }
    }
    
    public override var intrinsicContentSize: CGSize {
        CGSize(width: 400, height: 66)
    }
    
    public func setActionCircleImage(_ image: UIImage) {
        actionCircleImageView.image = image
    }
    
    public func setActionCircleImageInsets(_ insets: UIEdgeInsets) {
        actionCircleImageInsets = insets
        relayoutCircleImageView()
    }
    
    public func setTrailingLabelText(_ text: String, animated: Bool) {
        if animated {
            UIView.transition(with: trailingLabel, duration: animationDuration, options: .transitionCrossDissolve, animations: { [weak self] in
                self?.setTrailingLabelText(text)
            }, completion: nil)
        } else {
            self.setTrailingLabelText(text)
        }
    }
    
    public func setStyle(_ style: SlidingButtonStyle, animated: Bool) {
        self.style = style
        if animated {
            UIView.animate(withDuration: animationDuration, delay: 0, options: [], animations: { [weak self] in
                self?.setStyle(style)
            }, completion: nil)
        } else {
            self.setStyle(style)
        }
    }
    
    private func setTrailingLabelText(_ text: String) {
        trailingLabel.text = text
        relayoutTrailingLabel()
    }
    
    private func setStyle(_ style: SlidingButtonStyle) {
        self.backgroundColor = style.backgroundColor
        self.slidingView.backgroundColor = style.slidingViewColor
        self.actionCircle.backgroundColor = style.actionCircleColor
        self.actionCircleImageView.tintColor = style.actionCircleImageTint
        self.trailingLabel.textColor = style.trailingLabelTextColor
    }
    
    private func setup() {
        setStyle(self.style)
        
        resetOnLayout()
        
        self.clipsToBounds = true
        
        self.addSubview(trailingLabel)
        trailingLabel.font = .systemFont(ofSize: 17, weight: .semibold)
        
        addSubview(scrollView)
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.decelerationRate = .normal
        scrollView.delegate = self
        
        scrollView.addSubview(slidingView)
        
        slidingView.addSubview(actionCircle)
        actionCircle.backgroundColor = .white
        
        actionCircleImageView.contentMode = .scaleAspectFit
        actionCircle.addSubview(actionCircleImageView)
    }
    
    private func resetOnLayout() {
        layer.cornerRadius = bounds.height / 2
        
        let actionCircleHeight = self.actionCircleHeight
        
        scrollView.frame = bounds
        slidingView.frame = bounds
        
        scrollView.contentSize = CGSize(width: bounds.width + slideViewInsetIdleRightInset,
                                        height: bounds.height)
        scrollView.setContentOffset(CGPoint(x: slideViewInsetIdleRightInset, y: 0), animated: false)
        
        slidingView.layer.cornerRadius = bounds.height / 2
        actionCircle.frame = CGRect(
            x: slidingView.bounds.width - actionCirclePadding - actionCircleHeight,
            y: actionCirclePadding,
            width: actionCircleHeight,
            height: actionCircleHeight)
        actionCircle.layer.cornerRadius = actionCircleHeight / 2
        
        relayoutCircleImageView()
        
        relayoutTrailingLabel()
    }
    
    private func relayoutTrailingLabel() {
        let trailingLabelIntrinsic = trailingLabel.intrinsicContentSize
        
        trailingLabel.frame = CGRect(x: bounds.width - trailingLabelPadding - trailingLabelIntrinsic.width,
                                     y: bounds.height / 2 - trailingLabelIntrinsic.height / 2,
                                     width: trailingLabelIntrinsic.width,
                                     height: trailingLabelIntrinsic.height)
    }
    
    private func relayoutCircleImageView() {
        let actionCircleHeight = self.actionCircleHeight
        actionCircleImageView.frame = CGRect(x: actionCircleImageInsets.left,
                                             y: actionCircleImageInsets.top,
                                             width: actionCircleHeight - actionCircleImageInsets.left - actionCircleImageInsets.right,
                                             height: actionCircleHeight - actionCircleImageInsets.top - actionCircleImageInsets.bottom)
    }
    
    private var slideViewInsetIdleRightInset: CGFloat {
        return (bounds.width / 2 - actionCircleHeight / 2 - actionCirclePadding)
    }
    
    private var actionCircleHeight: CGFloat {
        bounds.height - actionCirclePadding * 2
    }
    
    public func scrollViewWillEndDragging(_ scrollView: UIScrollView,
                                          withVelocity velocity: CGPoint,
                                          targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let minValue: CGFloat = 0
        let maxValue: CGFloat = slideViewInsetIdleRightInset
        
        let originalTargetContentOffset = targetContentOffset.pointee
        
        let progress = (originalTargetContentOffset.x - minValue) / (maxValue - minValue)
        
        if progress > 0.5 {
            targetContentOffset.pointee = CGPoint(x: maxValue, y: originalTargetContentOffset.y)
        } else {
            targetContentOffset.pointee = CGPoint(x: minValue, y: originalTargetContentOffset.y)
            onTap?()
        }
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        scrollView.setContentOffset(CGPoint(x: slideViewInsetIdleRightInset, y: 0), animated: true)
    }
}

private func clamping(_ val: CGFloat, lower: CGFloat, upper: CGFloat) -> CGFloat {
    let clampedProgress: CGFloat
    if val < lower {
        clampedProgress = lower
    } else if val > upper {
        clampedProgress = upper
    } else {
        clampedProgress = val
    }
    return clampedProgress
}
