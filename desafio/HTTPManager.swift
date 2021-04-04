//
//  HTTPManager.swift
//  desafio
//
//  Created by João Francisco Muller on 02/04/21.
//

import Foundation
import Alamofire

typealias RequestSuccess = (_ success:Data) -> Void
typealias RequestError = (_ error:ErrorModel) -> Void

class HTTPManager {
    
    func isConnected() -> Bool{
        return NetworkReachabilityManager()?.isReachable ?? false
    }
    
    func get(_ url:String, _ success: @escaping RequestSuccess,_ error: @escaping RequestError){
        if (!isConnected()){
            error(ErrorModel(statusCode: nil, errorMessage: "Internet indisponível!"))
            return
        }
        
        AF.request(url, method: .get, encoding: JSONEncoding.default)
                .responseJSON { response in
                    if let data = response.data{
                        let statusCode = response.response!.statusCode
                        if (statusCode >= 200 && statusCode < 300){
                            success(data)
                        }else{
                            error(ErrorModel(statusCode: statusCode, errorMessage: "Internet indisponível"))
                            
                            if(statusCode == 400){
                                error(ErrorModel(statusCode: statusCode, errorMessage: "Não conseguimos processar essa ação!"))
                            }else if(statusCode == 403){
                                error(ErrorModel(statusCode: statusCode, errorMessage: "Limite de requisições excedido!"))
                            }else if(statusCode == 404){
                                error(ErrorModel(statusCode: statusCode, errorMessage: "Não encontrado!"))
                            }else if(statusCode == 500){
                                error(ErrorModel(statusCode: statusCode, errorMessage: "Erro interno de servidor!"))
                            }else if(statusCode == 503){
                                error(ErrorModel(statusCode: statusCode, errorMessage: "Serviço indisponível!"))
                            }else{
                                error(ErrorModel(statusCode: statusCode, errorMessage: "Ocorreu um erro inesperado!"))
                            }
                        }
                    }else{
                        error(ErrorModel(statusCode: nil, errorMessage: "Ocorreu um erro inesperado!"))
                    }
            }
    }
}
