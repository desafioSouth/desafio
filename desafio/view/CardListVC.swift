//
//  ViewController.swift
//  desafio
//
//  Created by João Francisco Muller on 02/04/21.
//

import UIKit
import RxSwift
import PINRemoteImage

class CardListVC: UIViewController{
    
    private let viewModel:CardListViewModel = CardListViewModel()
    private let spinner = SpinnerVC()
    private let disposeBag = DisposeBag()
    private var cardList:CardListModel? = nil;
    
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindData()
        viewModel.getCards()
    }
}

// MARK: - TableView
extension CardListVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cardList?.cards?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(cardList != nil){
            if let cell = tableView.dequeueReusableCell(withIdentifier: "CardCell", for: indexPath) as? CardCell{
                cell.setData(cardList?.cards?[indexPath.row])
                return cell
            }
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cardDetail = cardList?.cards?[indexPath.row]{
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let cardDetailVC = storyBoard.instantiateViewController(withIdentifier: "CardDetail") as! CardDetail
            cardDetailVC.setCard(card:cardDetail)
            self.present(cardDetailVC, animated: true, completion: nil)
        }
    }
}

// MARK: - Spinner
extension CardListVC {
    func showSpinner(_ show:Bool) {
        if(show){
        addChild(spinner)
        spinner.view.frame = view.frame
        view.addSubview(spinner.view)
        spinner.didMove(toParent: self)
        }else{
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            self.spinner.willMove(toParent: nil)
            self.spinner.view.removeFromSuperview()
            self.spinner.removeFromParent()
        }
        }
    }
}

// MARK: - cardCell
class CardCell:UITableViewCell{
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var cardSet: UILabel!
    @IBOutlet weak var cardImage: UIImageView!
    @IBOutlet weak var cmc: UILabel!
    
    public func setData(_ card:Card?){
        if let unwrappedCard = card{
            self.name.text = unwrappedCard.name
            self.cardSet.text = unwrappedCard.setName
            self.cmc.text = unwrappedCard.cmc?.description ?? ""
            self.cardImage.image = UIImage(named:"placeholderCard")
            if let imageUrl = unwrappedCard.imageURL , !(unwrappedCard.imageURL?.isEmpty ?? false){
            self.cardImage.pin_setImage(from: URL(string:imageUrl))
            }
        }
    }
}

// MARK: - Bind data
extension CardListVC {
    private func bindData(){
        viewModel.loading
                .observe(on: MainScheduler.instance)
                .subscribe(onNext: { (loading) in
                    self.showSpinner(loading)
                })
                .disposed(by: disposeBag)
        
        viewModel.cards
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { (cards) in
                self.cardList = cards
                self.tableView.reloadData()
                })
                .disposed(by: disposeBag)
        
        viewModel.error
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { (error) in
                self.showError(error: error)
                })
                .disposed(by: disposeBag)
    }
}
// MARK: - Error message
extension CardListVC {
    private func showError(error:ErrorModel){
        var message = ""
        if (error.statusCode != nil){
            message = (error.statusCode!.description) + " - "
        }
        message += error.errorMessage
        let alert = UIAlertController(title: "Ocorreu um erro!", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.destructive, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

