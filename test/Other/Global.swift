
import UIKit
import AVFoundation
import SVProgressHUD
import SystemConfiguration
import PopupDialog
import Toast_Swift
import JNKeychain
import CoreLocation
import ChameleonFramework




let myApp = UIApplication.shared.delegate as! AppDelegate

var style = ToastStyle()

@available(iOS 11.0, *)
let safeAreaBottomSize = UIApplication.shared.keyWindow?.safeAreaInsets.bottom

func isValidEmail(testStr:String) -> Bool {
   // print("validate calendar: \(testStr)")
   let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
   let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
   return emailTest.evaluate(with: testStr)
}

var BundleID = "com.test"
var appStoreID =  1487603837
var mailId = "test@gmail.com"
var appFullName = "test"
var ShareLinkMsg = "\(appFullName) \n\n Downlaod : https://itunes.apple.com/app/id\(appStoreID)"

public func Loading(string: String?, maskType: SVProgressHUDMaskType = SVProgressHUDMaskType.black) {
    SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
    SVProgressHUD.show(withStatus: string  ?? "")
}

var headerColorCode = "#452080"
var creamColorCode = "#EECDEE"
var choclateColorCode = "#4E2C1A"

var choclateColor = UIColor(hexString: choclateColorCode)!
var headerColor = UIColor(hexString: headerColorCode)!
var creamColor = UIColor(hexString: creamColorCode)!

var headercolor0 = UIColor(hexString: "#5e2f8c")!
var headercolor1 = UIColor(hexString: "#452080")!
var headercolor2 = UIColor(hexString: "#FEF9E7")!
var headercolor3 = UIColor(hexString: "#FFECC7")!
var headercolor4 = UIColor(hexString: "#FDDAC5")!

var fbcolor1 = UIColor(hexString: "#3b5998")!
var fbcolor2 = UIColor(hexString: "#2f55a4")!


var isLoginUser = false


var ltr = UIGradientStyle.leftToRight
var ttb = UIGradientStyle.topToBottom

func setGradientColor(button: UIView,style: UIGradientStyle,colors: [UIColor]) -> UIColor {
   return (UIColor(gradientStyle:style, withFrame:CGRect(x: button.frame.origin.x, y: button.frame.origin.y, width: button.frame.size.width, height: button.frame.size.height), andColors:colors))
}

var currentLocation : CLLocation?

func getStoryBoard(name:String) -> UIStoryboard {
   return UIStoryboard(name: name, bundle: nil)
}

func checkInternetCon(vc: UIViewController?) {
   if isConnectedToNetwork() == false {
       let customV = InternetConnectionView(nibName: "InternetConnectionView", bundle: nil)
       let popup = PopupDialog(viewController: customV, buttonAlignment: .horizontal, transitionStyle: .bounceDown, tapGestureDismissal: false)
       vc?.present(popup, animated: true, completion: nil)
   }
}

func changeTabBar(hidden:Bool, animated: Bool,vc: UIViewController){
   guard let tabBar = vc.tabBarController?.tabBar else { return; }
   if tabBar.isHidden == hidden{ return }
   let frame = tabBar.frame
   let offset = hidden ? frame.size.height : -frame.size.height
   let duration:TimeInterval = (animated ? 0.5 : 0.0)
   tabBar.isHidden = false
   
   UIView.animate(withDuration: duration, animations: {
       tabBar.frame = frame.offsetBy(dx: 0, dy: offset)
   }, completion: { (true) in
       tabBar.isHidden = hidden
   })
}

func dateformetChange(date:String) -> String {
   let dateFormatter = DateFormatter()
   dateFormatter.dateFormat = "yyyy-MM-dd"
   if let dt = dateFormatter.date(from: date) {
       dateFormatter.dateFormat = "dd/MM/yyyy"
       return dateFormatter.string(from: dt)
   } else{
       return ""
   }
}

func convertToDictionary(text: String) -> [String: Any]? {
   if let data = text.data(using: .utf8) {
       do {
           return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
       } catch {
           print(error.localizedDescription)
       }
   }
   return nil
}

func convertToArray(text: String) -> NSArray? {
   if let data = text.data(using: .utf8) {
       do {
           return try JSONSerialization.jsonObject(with: data, options: []) as? NSArray
       } catch {
           print(error.localizedDescription)
       }
   }
   return nil
}

func removeFileAtURLIfExists(url: NSURL) {
    if let filePath = url.path {
        if FileManager.default.fileExists(atPath: filePath) {
            do{
                try FileManager.default.removeItem(atPath: filePath)
            } catch let error as NSError {
                print("Couldn't remove existing destination file: \(error)")
            }
        }
    }
}

func getThumbnailImage(forUrl url: URL,completion: @escaping ((_ image: UIImage?)->Void)) {
   DispatchQueue.global().async { //1
       let asset = AVAsset(url: url) //2
       let avAssetImageGenerator = AVAssetImageGenerator(asset: asset) //3
       avAssetImageGenerator.appliesPreferredTrackTransform = true //4
       let thumnailTime = CMTimeMake(value: 2, timescale: 1) //5
       do {
           let cgThumbImage = try avAssetImageGenerator.copyCGImage(at: thumnailTime, actualTime: nil) //6
           let thumbImage = UIImage(cgImage: cgThumbImage) //7
           DispatchQueue.main.async { //8
               completion(thumbImage) //9
           }
       } catch {
           print(error.localizedDescription) //10
           DispatchQueue.main.async {
               completion(nil) //11
           }
       }
   }
}


func dictionaryToString(Detail : [String: AnyObject]) -> String? {
   do {
       let jsonData = try JSONSerialization.data(withJSONObject: Detail, options: JSONSerialization.WritingOptions.prettyPrinted)
       let jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)! as String
       print(jsonString)
       return jsonString
   }catch {
       print("Error : ",error.localizedDescription)
       SVProgressHUD.showInfo(withStatus: error.localizedDescription)
       return nil
   }
}

func dictionaryToString2(Detail : [String: AnyObject]) -> String? {
   do {
       let jsonData = try JSONSerialization.data(withJSONObject: Detail, options: JSONSerialization.WritingOptions.prettyPrinted)
       let jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)! as String
       //print(jsonString)
       return jsonString
   }catch {
       print("Error : ",error.localizedDescription)
       SVProgressHUD.showInfo(withStatus: error.localizedDescription)
       return nil
   }
}


struct ScreenSize
{
   static let SCREEN_WIDTH         = UIScreen.main.bounds.size.width
   static let SCREEN_HEIGHT        = UIScreen.main.bounds.size.height
   static let SCREEN_MAX_LENGTH    = max(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
   static let SCREEN_MIN_LENGTH    = min(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
}

struct DeviceType
{
   static let IS_IPHONE_X  = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 812.0
   static let IS_IPHONE_4_OR_LESS  = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH < 568.0
   static let IS_IPHONE_5          = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 568.0
   static let IS_IPHONE_6_7          = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 667.0
   static let IS_IPHONE_6P_7P         = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 736.0
   static let IS_IPAD              = UIDevice.current.userInterfaceIdiom == .pad && ScreenSize.SCREEN_MAX_LENGTH == 1024.0
   static let IS_IPAD_PRO          = UIDevice.current.userInterfaceIdiom == .pad && ScreenSize.SCREEN_MAX_LENGTH == 1366.0
   static let IS_IPAD_XR         = UIDevice.current.userInterfaceIdiom == .pad && ScreenSize.SCREEN_MAX_LENGTH == 896.0
   static let IS_IPAD_XS          = UIDevice.current.userInterfaceIdiom == .pad && ScreenSize.SCREEN_MAX_LENGTH == 812.0
   static let IS_IPAD_XSMax         = UIDevice.current.userInterfaceIdiom == .pad && ScreenSize.SCREEN_MAX_LENGTH == 812.0
}

class KeychainManager: NSObject {
   static let sharedInstance = KeychainManager()
   
   func getDeviceIdentifierFromKeychain() -> String {
       
       // try to get value from keychain
       var deviceUDID = self.keychain_valueForKey("keychainDeviceUDID") as? String
       if deviceUDID == nil {
           deviceUDID = UIDevice.current.identifierForVendor!.uuidString
           // save new value in keychain
           self.keychain_setObject(deviceUDID! as AnyObject, forKey: "keychainDeviceUDID")
       }
       return deviceUDID!
   }
   
   // MARK: - Keychain
   
   func keychain_setObject(_ object: AnyObject, forKey: String) {
       let result = JNKeychain.saveValue(object, forKey: forKey)
       if !result {
           print("keychain saving: smth went wrong")
       }
   }
   
   func keychain_deleteObjectForKey(_ key: String) -> Bool {
       let result = JNKeychain.deleteValue(forKey: key)
       return result
   }
   
   func keychain_valueForKey(_ key: String) -> AnyObject? {
       let value = JNKeychain.loadValue(forKey: key)
       return value as AnyObject?
   }
}

func isConnectedToNetwork() -> Bool {
   var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
   zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
   zeroAddress.sin_family = sa_family_t(AF_INET)
   
   let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
       $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
           SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
       }
   }
   
   var flags: SCNetworkReachabilityFlags = SCNetworkReachabilityFlags(rawValue: 0)
   if SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) == false {
       return false
   }
   // Working for Cellular and WIFI
   let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
   let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
   let ret = (isReachable && !needsConnection)
   
   return ret
}
