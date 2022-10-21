import UIKit

public class SlidingButton: UIView {
    private let actionCirclePadding: CGFloat = 10
    private let trailingLabelPadding: CGFloat = 22
    
    private var progress: CGFloat = 0
    
    let slidingView = UIView()
    let actionCircle = UIView()
    let trailingLabel = UILabel()
    
    public init() {
        super.init(frame: .zero)
        
        setup()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        resetOnLayout()
    }
    
    public override var intrinsicContentSize: CGSize {
        CGSize(width: 400, height: 66)
    }
    
    private func setup() {
        resetOnLayout()
        
        self.clipsToBounds = true
        backgroundColor = UIColor(white: 46 / 255, alpha: 1)
        
        self.addSubview(trailingLabel)
        trailingLabel.text = "Buy Now"
        trailingLabel.textColor = .white
        trailingLabel.font = .systemFont(ofSize: 17, weight: .semibold)
        
        addSubview(slidingView)
        slidingView.backgroundColor = UIColor(
            red: 76 / 255,
            green: 255 / 255,
            blue: 103 / 255,
            alpha: 1)
        
        slidingView.addSubview(actionCircle)
        actionCircle.backgroundColor = .white
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(onPan))
        slidingView.addGestureRecognizer(panGesture)
    }
    
    private func resetOnLayout() {
        layer.cornerRadius = bounds.height / 2
        
        let actionCircleHeight = self.actionCircleHeight
        
        slidingView.layer.cornerRadius = bounds.height / 2
        slidingView.frame = CGRect(x: slidingViewMinimumX,
                                   y: 0,
                                   width: bounds.width,
                                   height: bounds.height)
        actionCircle.frame = CGRect(
            x: slidingView.bounds.width - actionCirclePadding - actionCircleHeight,
            y: actionCirclePadding,
            width: actionCircleHeight,
            height: actionCircleHeight)
        actionCircle.layer.cornerRadius = actionCircleHeight / 2
        
        let trailingLabelIntrinsic = trailingLabel.intrinsicContentSize
        trailingLabel.frame = CGRect(x: bounds.width - trailingLabelPadding - trailingLabelIntrinsic.width,
                                     y: bounds.height / 2 - trailingLabelIntrinsic.height / 2,
                                     width: trailingLabelIntrinsic.width,
                                     height: trailingLabelIntrinsic.height)
    }
    
    private func setProgress(_ progress: CGFloat) {
        self.progress = progress
        
        let minPoint = slidingViewMinimumX
        let maxPoint: CGFloat = 0
        slidingView.frame.origin.x = progress * (maxPoint - minPoint) + minPoint
    }
    
    @objc private func onPan(_ sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .changed:
            let translation = sender.translation(in: self)
            
            let maxValue = bounds.width / 2
            let minValue: CGFloat = 0
            
            let progress = (translation.x - minValue) / maxValue + minValue
            let clampedProgress: CGFloat
            if progress < 0 {
                clampedProgress = 0
            } else if progress > 1 {
                clampedProgress = 1
            } else {
                clampedProgress = progress
            }
            setProgress(clampedProgress)
        case .possible:
            break
        case .began:
            break
        case .ended:
            resetToMinPosition(animated: true)
        case .cancelled:
            resetToMinPosition(animated: true)
        case .failed:
            break
        @unknown default:
            break
        }
    }
    
    private var slidingViewMinimumX: CGFloat {
        -bounds.width / 2 + actionCircleHeight / 2 + actionCirclePadding
    }
    
    private var actionCircleHeight: CGFloat {
        bounds.height - actionCirclePadding * 2
    }
    
    private func resetToMinPosition(animated: Bool) {
        if animated {
            UIView.animate(withDuration: 0.25, delay: 0, options: [], animations: { [weak self] in
                self?.resetToMinPosition()
            }, completion: nil)
        } else {
            resetToMinPosition()
        }
    }
    
    private func resetToMinPosition() {
        slidingView.frame.origin.x = slidingViewMinimumX
    }
}
