import UIKit
import SlidingButton

class ViewController: UIViewController {
    let buyButton = SlidingButton()
    
    let addToCardButton = SlidingButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(buyButton)
        buyButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            buyButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            buyButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            buyButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -32),
        ])
        buyButton.setTrailingLabelText("Buy Now", animated: false)
        buyButton.onTap = { [unowned self] in
            let cartViewController = CartViewController()
            
            self.present(cartViewController, animated: true)
        }
        buyButton.setActionCircleImage(UIImage(named: "arrow-right")!)
        buyButton.setStyle(.buyButtonStyle(), animated: false)
        
        view.addSubview(addToCardButton)
        addToCardButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            addToCardButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            addToCardButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            addToCardButton.bottomAnchor.constraint(equalTo: buyButton.topAnchor, constant: -16),
        ])
        addToCardButton.setTrailingLabelText("Add To Cart", animated: false)
        addToCardButton.setActionCircleImage(UIImage(named: "arrow-right")!)
        
        
        let defaultStyle = SlidingButtonStyle.springGreen()
        let disabledStyle = SlidingButtonStyle.addToCartDisabledButtonStyle()
        var inCart = false
        addToCardButton.setStyle(defaultStyle, animated: false)
        addToCardButton.onTap = { [unowned self] in
            inCart = !inCart
            if inCart {
                addToCardButton.setStyle(disabledStyle, animated: true)
                addToCardButton.setTrailingLabelText("In Cart!", animated: true)
            } else {
                addToCardButton.setStyle(defaultStyle, animated: true)
                addToCardButton.setTrailingLabelText("Add To Cart", animated: true)
            }
        }
    }
}

private extension SlidingButtonStyle {
    static func buyButtonStyle() -> SlidingButtonStyle {
        return SlidingButtonStyle(backgroundColor: UIColor(white: 47 / 255, alpha: 1),
                                  slidingViewColor: .black,
                                  actionCircleColor: .white,
                                  actionCircleImageTint: .black,
                                  trailingLabelTextColor: .white)
    }
    
    static func addToCartDisabledButtonStyle() -> SlidingButtonStyle {
        let gray1 = UIColor(
            red: 47 / 255,
            green: 47 / 255,
            blue: 47 / 255,
            alpha: 1
        )
        let accentGray = UIColor(
            red: 76 / 255,
            green: 76 / 255,
            blue: 76 / 255,
            alpha: 1
        )
        return SlidingButtonStyle(
            backgroundColor: gray1,
            slidingViewColor: accentGray,
            actionCircleColor: gray1,
            actionCircleImageTint: accentGray,
            trailingLabelTextColor: .white
        )
    }
}
