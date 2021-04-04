import Foundation
import UIKit
import PINRemoteImage

class CardDetail: UIViewController{
    
    @IBOutlet var cardImage: UIImageView!
    @IBOutlet var name: UILabel!
    @IBOutlet var cmcValue: UILabel!
    @IBOutlet var cardSet: UILabel!
    @IBOutlet var desc: UILabel!
    private var card:Card? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setData()
    }
    
    @IBAction func closeButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    public func setCard(card:Card){
        self.card = card
    }
    
    private func setData(){
        if let cardDetails = self.card{
            name.text = cardDetails.name ?? ""
            cmcValue.text = cardDetails.cmc?.description ?? ""
            cardSet.text = cardDetails.setName ?? ""
            desc.text = cardDetails.text ?? ""
            self.cardImage.image = UIImage(named:"placeholderCard")
            if let imageUrl = cardDetails.imageURL , !(cardDetails.imageURL?.isEmpty ?? false){
                self.cardImage.pin_setImage(from: URL(string:imageUrl))
            }
        }
    }
}
