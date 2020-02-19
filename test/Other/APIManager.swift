

import UIKit
import Foundation
import Alamofire
import SwiftyJSON
import SVProgressHUD
import PopupDialog

let headerKey = "X-Api-Key"
let headerValue = "soor"

let baseUrl = "http://soordairyfresh.com/admin/webapi/User_api/"


class APIManager: NSObject {
    static let sharedInstance = APIManager()
    
    func getResponseAPI(url:String,isPring: Bool = false,completionHandler:@escaping (AnyObject?, NSError?)->()) ->() {
        Alamofire.request(url, method: HTTPMethod.get, parameters: nil, encoding: URLEncoding.httpBody, headers: [headerKey:headerValue])
            .validate(/*contentType: ["application/json"]*/)
            .responseJSON { response in
                switch response.result {
                case .success( _):
                    if (isPring) {
                        print(response.result.value ?? " ")
                    }
                    SVProgressHUD.dismiss()
                    do {
                        SVProgressHUD.dismiss()
                        let someDictionaryFromJSON = try JSONSerialization.jsonObject(with: response.data!, options: .allowFragments) as! [String: Any]
                        completionHandler(someDictionaryFromJSON as AnyObject?,nil)
                    } catch{
                        SVProgressHUD.dismiss()
                        completionHandler(nil,response.result.error as NSError?)
                        print("Error : ",error)
                    }
                case .failure(let error):
                    SVProgressHUD.dismiss()
                    completionHandler(nil,response.result.error as NSError?)
                    print("Request failed with error: \(error)")
                }
        }
    }
    
    
    func getResponseWithDetailAPI(url:String,isPring: Bool = false,Detail: [String: AnyObject],completionHandler:@escaping (AnyObject?, NSError?)->()) ->() {
        if let jsonString = dictionaryToString(Detail: Detail) {
            if let url = URL(string: url) {
                let jsonDatas = jsonString.data(using: .utf8, allowLossyConversion: false)!
                
                var request = URLRequest(url: url)
                request.httpMethod = HTTPMethod.post.rawValue
                request.setValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")
                request.setValue(headerValue, forHTTPHeaderField: headerKey)
                request.httpBody = jsonDatas
                
                Alamofire.request(request).responseJSON {
                    (response) in
                    //print(response)
                    switch response.result {
                    case .success(let data):
                        let json = JSON(data)
                        if (isPring) {
                            print(response.result.value ?? " ")
                        }
                        if let _ = json.dictionary {
                            do {
                                SVProgressHUD.dismiss()
                                let someDictionaryFromJSON = try JSONSerialization.jsonObject(with: response.data!, options: .allowFragments) as! [String: Any]
                                completionHandler(someDictionaryFromJSON as AnyObject?,nil)
                            } catch {
                                completionHandler(nil,response.result.error as NSError?)
                                print("error: \(error)")
                            }
                        } else{
                            completionHandler(nil,response.result.error as NSError?)
                        }
                    case .failure(let error):
                        SVProgressHUD.dismiss()
                        completionHandler(nil,response.result.error as NSError?)
                        print("Request failed with error: \(error)")
                    }
                }
            }
        }
    }
    
    func postResponseAPI(_ url:String,isPring: Bool = false,param:AnyObject!,completionHandler:@escaping (AnyObject?, NSError?)->()) ->()
    {
        if isConnectedToNetwork() {
            Alamofire.request(url, method: .post, parameters: param as? [String : AnyObject], encoding: URLEncoding.default, headers: [headerKey:headerValue]).responseJSON { response in
                    switch response.result {
                    case .success( _):
                        if (isPring) {
                            print(response.result.value ?? " ")
                        }
                        SVProgressHUD.dismiss()
                        do {
                            SVProgressHUD.dismiss()
                            let someDictionaryFromJSON = try JSONSerialization.jsonObject(with: response.data!, options: .allowFragments) as! [String: Any]
                            completionHandler(someDictionaryFromJSON as AnyObject?,nil)
                        } catch{
                            SVProgressHUD.dismiss()
                            completionHandler(nil,response.result.error as NSError?)
                            print("Error : ",error)
                        }
                    case .failure(let error):
                        SVProgressHUD.dismiss()
                        completionHandler(nil,response.result.error as NSError?)
                        print("Request failed with error: \(error)")
                    }
            }
        }else{
            DispatchQueue.main.async(execute: {
                SVProgressHUD.dismiss()
                let customV = InternetConnectionView(nibName: "InternetConnectionView", bundle: nil)
                let popup = PopupDialog(viewController: customV, buttonAlignment: .horizontal, transitionStyle: .bounceDown, tapGestureDismissal: false)
                myApp.window?.rootViewController?.present(popup, animated: true, completion: nil)
            })
        }
    }
    
    
}
