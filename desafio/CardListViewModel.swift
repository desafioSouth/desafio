import Foundation
import RxSwift
import RxCocoa

class CardListViewModel{
    
    public let cards:PublishSubject<CardListModel> = PublishSubject()
    public let error:PublishSubject<ErrorModel> = PublishSubject()
    public let loading:PublishSubject<Bool> = PublishSubject()
    private let httpManager:HTTPManager = HTTPManager()
    
    func getCards(){
        let url = "https://api.magicthegathering.io/v1/cards"
        loading.onNext(true)
        httpManager.get(url) { (result) in
            var cardModel:CardListModel? = nil
            self.loading.onNext(false)
            do{
                cardModel = try JSONDecoder().decode(CardListModel.self, from: result)
            } catch {
                self.error.onNext(ErrorModel(statusCode: nil,errorMessage: "Ocorreu um erro inesperado!"))
                return
            }
            
            if let parsedCards = cardModel{
                self.cards.onNext(parsedCards)
            }else{
                self.error.onNext(ErrorModel(statusCode: nil,errorMessage: "Ocorreu um erro inesperado!"))
            }
            
        } _: { (errorModel) in
            self.loading.onNext(false)
            self.error.onNext(errorModel)
        }
    }
}
