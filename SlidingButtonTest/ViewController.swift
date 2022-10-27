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
        
        view.addSubview(addToCardButton)
        addToCardButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            addToCardButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            addToCardButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            addToCardButton.bottomAnchor.constraint(equalTo: buyButton.topAnchor, constant: -16),
        ])
        addToCardButton.setTrailingLabelText("Add To Cart", animated: false)
        addToCardButton.onTap = { [unowned self] in
            addToCardButton.setTrailingLabelText("In Cart!", animated: true)
        }
        addToCardButton.setActionCircleImage(UIImage(named: "arrow-right")!)
    }
}

