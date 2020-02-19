 
 import UIKit
 
 
 
 extension UIApplication {
    class func topViewController(base: UIViewController? = (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topViewController(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(base: selected)
            }
        }
        if let presented = base?.presentedViewController {
            return topViewController(base: presented)
        }
        return base
    }
 }
 
 // *********** ************ *********** ************ *********** ************ *********** ************ *********** ************
 /// #UIViewController
 // *********** ************ *********** ************ *********** ************ *********** ************ *********** ************
 
 
 
 extension UIViewController {
    private struct AssociatedKey {
        static var leftEdgePanGestureName = UIScreenEdgePanGestureRecognizer()
        static var leftPanTriggeredName = false
    }
    
    var leftPanTriggered: Bool? {
        get {
            return getAssociatedObject(object: self, associativeKey: &AssociatedKey.leftPanTriggeredName)
        }
        
        set {
            if let value = newValue {
                setAssociatedObject(object: self, value: value, associativeKey: &AssociatedKey.leftPanTriggeredName, policy: objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
        }
    }
    
    var leftEdgePanGesture: UIScreenEdgePanGestureRecognizer? {
        get {
            return getAssociatedObject(object: self, associativeKey: &AssociatedKey.leftEdgePanGestureName)
        }
        
        set {
            if let value = newValue {
                setAssociatedObject(object: self, value: value, associativeKey: &AssociatedKey.leftEdgePanGestureName, policy: objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
        }
    }
    
 }
 
 extension UIViewController {
    
    func addSwipeBackGesture() {
        
        //let leftEdgePanGesture = UIScreenEdgePanGestureRecognizer()
        //var leftPanTriggered: Bool = false
        
        self.leftEdgePanGesture = UIScreenEdgePanGestureRecognizer()
        self.leftPanTriggered = false
        
        self.leftEdgePanGesture?.addTarget(self, action: #selector(UIViewController.handleLeftEdge(gesture:)))
        self.leftEdgePanGesture?.edges = .left
        if let gesture = self.leftEdgePanGesture {
            self.view.addGestureRecognizer(gesture)
        }
        
    }
    
    @objc func handleLeftEdge(gesture: UIScreenEdgePanGestureRecognizer) {
        var leftPanTriggered = self.leftPanTriggered ?? false
        switch gesture.state {
        case .began, .changed:
            if !leftPanTriggered {
                let threshold: CGFloat = 10  // you decide this
                let translation = abs(gesture.translation(in: self.view).x)
                if translation >= threshold  {
                    performLeftGesture()
                    leftPanTriggered = true
                }
            }
            
        case .ended, .failed, .cancelled:
            leftPanTriggered = false
            
        default: break
        }
    }
    
    func performLeftGesture() {
        //Pop back to login view controller
        _ = self.navigationController?.popViewController(animated: true)
    }
 }
 
 
 final class Lifted<T> {
    let value: T
    init(_ x: T) {
        value = x
    }
 }
 
 private func lift<T>(x: T) -> Lifted<T>  {
    return Lifted(x)
 }
 
 func setAssociatedObject<T>(object: AnyObject, value: T, associativeKey: UnsafeRawPointer, policy: objc_AssociationPolicy) {
    if let v: AnyObject = value as AnyObject? {
        objc_setAssociatedObject(object, associativeKey, v,  policy)
    }
    else {
        objc_setAssociatedObject(object, associativeKey, lift(x: value),  policy)
    }
 }
 
 func getAssociatedObject<T>(object: AnyObject, associativeKey: UnsafeRawPointer) -> T? {
    if let v = objc_getAssociatedObject(object, associativeKey) as? T {
        return v
    }
    else if let v = objc_getAssociatedObject(object, associativeKey) as? Lifted<T> {
        return v.value
    }
    else {
        return nil
    }
 }
 
 // *********** ************ *********** ************ *********** ************ *********** ************ *********** ************
 /// #UIView
 // *********** ************ *********** ************ *********** ************ *********** ************ *********** ************
 
 extension UIView {
    @IBInspectable
    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
    
    @IBInspectable
    var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable
    var borderColor: UIColor? {
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.borderColor = color.cgColor
            } else {
                layer.borderColor = nil
            }
        }
    }
    
    @IBInspectable var shadow: Bool {
        get {
            return layer.shadowOpacity > 0.0
        }
        set {
            if newValue == true {
                self.addShadow()
            }
        }
    }
    
    func addShadow(shadowColor: CGColor = UIColor.black.cgColor,
                   shadowOffset: CGSize = CGSize(width: 1.0, height: 2.0),
                   shadowOpacity: Float = 0.5,
                   shadowRadius: CGFloat = 2.0) {
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 1.0)
        layer.shadowOpacity = 0.2
        layer.shadowRadius = 2.0
    }
    
    
    
    public func setRoundCornerRadious()
    {
        //        let sw = UIScreen.main.bounds.size.width
        self.layer.cornerRadius = CGFloat(self.frame.width/2.0)
        self.layer.masksToBounds = true
        self.clipsToBounds = true
    }
    
    func rotate360Degrees(duration: CFTimeInterval = 3) {
        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotateAnimation.fromValue = 0.0
        rotateAnimation.toValue = CGFloat(Double.pi * 2)
        rotateAnimation.isRemovedOnCompletion = false
        rotateAnimation.duration = duration
        rotateAnimation.repeatCount=Float.infinity
        self.layer.add(rotateAnimation, forKey: nil)
    }
    
 }
 
 
 
 // *********** ************ *********** ************ *********** ************ *********** ************ *********** ************
 /// #UITextField
 // *********** ************ *********** ************ *********** ************ *********** ************ *********** ************
 
 
 extension UITextField {
    @IBInspectable var placeHolderColor: UIColor? {
        get {
            return self.placeHolderColor
        }
        set {
            self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSAttributedString.Key.foregroundColor: newValue!])
        }
    }
 }
 
 
 extension UITextField {
    public func setLeftMargin(marginWidth:CGFloat = 4)
    {
        let paddingLeft = UIView(frame: CGRect(x: 0, y: 0, width: marginWidth, height: self.frame.size.height))
        self.leftView = paddingLeft
        self.leftViewMode = UITextField.ViewMode.always
    }
    public func setRightMargin(marginWidth:CGFloat = 4)
    {
        let paddingRight = UIView(frame: CGRect(x: 0, y: 0, width: marginWidth, height: self.frame.size.height))
        self.rightView = paddingRight
        self.rightViewMode = UITextField.ViewMode.always
    }
    public func setPlaceholderColor(textColor:UIColor = UIColor.init(white: 0.8, alpha: 0.8))
    {
        //UIColor.whiteColor()
        self.attributedPlaceholder = NSAttributedString(string:self.placeholder ?? "",attributes:[NSAttributedString.Key.foregroundColor: textColor])
        //,NSFontAttributeName:UIFont.fontNamesForFamilyName("Arial")
    }
 }
 
 
 private var __maxLengths = [UITextField: Int]()
 extension UITextField {
    @IBInspectable var maxLength: Int {
        get {
            guard let l = __maxLengths[self] else {
                return Int.max // (global default-limit. 150 or just, Int.max)
            }
            return l
        }
        set {
            __maxLengths[self] = newValue
            addTarget(self, action: #selector(fix), for: .editingChanged)
        }
    }
    @objc func fix(textField: UITextField) {
        let t = textField.text
        textField.text = t?.safelyLimitedTo(length: maxLength)
    }
 }
 
 // *********** ************ *********** ************ *********** ************ *********** ************ *********** ************
 /// #String
 // *********** ************ *********** ************ *********** ************ *********** ************ *********** ************
 
 
 
 extension String
 {
    func safelyLimitedTo(length n: Int)->String {
        let c = self
        if (c.count <= n) { return self }
        return String( Array(c).prefix(upTo: n) )
    }
 }
 
 
 extension String {
    subscript(r: Range<Int>) -> String? {
        get {
            let stringCount = self.count as Int
            if (stringCount < r.upperBound) || (stringCount < r.lowerBound) {
                return nil
            }
            let startIndex = self.index(self.startIndex, offsetBy: r.lowerBound)
            let endIndex = self.index(self.startIndex, offsetBy: r.upperBound - r.lowerBound)
            return String(self[(startIndex ..< endIndex)])
        }
    }
    
    func containsAlphabets() -> Bool {
        //Checks if all the characters inside the string are alphabets
        let set = CharacterSet.letters
        return self.utf16.contains( where: {
            guard let unicode = UnicodeScalar($0) else { return false }
            return set.contains(unicode)
        })
    }
 }
 
 // *********** ************ *********** ************ *********** ************ *********** ************ *********** ************
 /// #UIImage
 // *********** ************ *********** ************ *********** ************ *********** ************ *********** ************
 
 extension UIImage {
    func toBase64() -> String? {
        guard let imageData = UIImage.jpegData(self)(compressionQuality: 0.2) else { return nil }
        return imageData.base64EncodedString(options: Data.Base64EncodingOptions.lineLength64Characters)
    }
 }
 
 // *********** ************ *********** ************ *********** ************ *********** ************ *********** ************
 /// #UILabel
 // *********** ************ *********** ************ *********** ************ *********** ************ *********** ************
 
 extension UILabel {
    func addTextSpacing(spacing: CGFloat){
        let attributedString = NSMutableAttributedString(string: self.text ?? "")
        attributedString.addAttribute(NSAttributedString.Key.kern, value: spacing, range: NSRange(location: 0, length: (self.text ?? "").count))
        self.attributedText = attributedString
    }
 }
 
 
 // *********** ************ *********** ************ *********** ************ *********** ************ *********** ************
 /// #UITableView
 // *********** ************ *********** ************ *********** ************ *********** ************ *********** ************
 
 
 extension UITableView {
    func scrollToFirstRow() {
        self.setContentOffset(CGPoint.zero, animated: false)
    }
 }
 
 
 
 
 // *********** ************ *********** ************ *********** ************ *********** ************ *********** ************
 /// #UIColor
 // *********** ************ *********** ************ *********** ************ *********** ************ *********** ************
 
 
 
 extension UIColor {
    convenience init?(hexRGBA: String?) {
        guard let rgba = hexRGBA, let val = Int(rgba.replacingOccurrences(of: "#", with: ""), radix: 16) else {
            return nil
        }
        self.init(red: CGFloat((val >> 24) & 0xff) / 255.0, green: CGFloat((val >> 16) & 0xff) / 255.0, blue: CGFloat((val >> 8) & 0xff) / 255.0, alpha: CGFloat(val & 0xff) / 255.0)
    }
    convenience init?(hexRGB: String?) {
        guard let rgb = hexRGB else {
            return nil
        }
        self.init(hexRGBA: rgb + "ff") // Add alpha = 1.0
    }
    
 }
 
 extension UIColor{
    static func returnRGBColor(r:CGFloat, g:CGFloat, b:CGFloat, alpha:CGFloat) -> UIColor{
        return UIColor(red: r/255, green: g/255, blue: b/255, alpha: alpha)
    }
 }
 
 extension UIColor {
    convenience init(red: CGFloat, green: CGFloat, blue: CGFloat) {
        self.init(red: red / 255, green: green / 255, blue: blue / 255, alpha: 1)
    }
 }
 
 extension UIColor {
    convenience init(rgb: UInt) {
        self.init(
            red: CGFloat((rgb & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgb & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgb & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
 }
 
 
 // *********** ************ *********** ************ *********** ************ *********** ************ *********** ************
 /// #UIButton
 // *********** ************ *********** ************ *********** ************ *********** ************ *********** ************
 
 extension UIButton {
    
    func alignImageAndTitleVertically(padding: CGFloat = 6.0) {
        let imageSize = self.imageView!.frame.size
        let titleSize = self.titleLabel!.frame.size
        let totalHeight = imageSize.height + titleSize.height + padding
        
        self.imageEdgeInsets = UIEdgeInsets(
            top: -(totalHeight - imageSize.height),
            left: 0,
            bottom: 0,
            right: -titleSize.width
        )
        
        self.titleEdgeInsets = UIEdgeInsets(
            top: 0,
            left: -imageSize.width,
            bottom: -(totalHeight - titleSize.height),
            right: 0
        )
    }
    
    func setImage(image: UIImage?, forState: UIControl.State, animated: Bool) {
        guard let imageView = self.imageView, let currentImage = imageView.image, let newImage = image else {
            return
        }
        CATransaction.begin()
        CATransaction.setCompletionBlock {
            self.setImage(newImage, for: UIControl.State.normal)
        }
        let crossFade: CABasicAnimation = CABasicAnimation(keyPath: "contents")
        crossFade.duration = 0.3
        crossFade.fromValue = currentImage.cgImage
        crossFade.toValue = newImage.cgImage
        crossFade.isRemovedOnCompletion = false
        crossFade.fillMode = CAMediaTimingFillMode.forwards
        imageView.layer.add(crossFade, forKey: "animateContents")
        CATransaction.commit()
        
    }
        
    func pulsate() {
        
        let pulse = CASpringAnimation(keyPath: "transform.scale")
        pulse.duration = 1.2
        pulse.fromValue = 0.8
        pulse.toValue = 1.2
        pulse.autoreverses = true
        pulse.repeatCount = Float.greatestFiniteMagnitude
        pulse.initialVelocity = 0.1
        pulse.damping = 1.0
        
        layer.add(pulse, forKey: "pulse")
    }
    
    func flash() {
        
        let flash = CABasicAnimation(keyPath: "opacity")
        flash.duration = 0.5
        flash.fromValue = 1
        flash.toValue = 0.1
        flash.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        flash.autoreverses = true
        flash.repeatCount = 3
        
        layer.add(flash, forKey: nil)
    }
    
    
    func shake() {
        
        let shake = CABasicAnimation(keyPath: "position")
        shake.duration = 0.1
        shake.repeatCount = 2
        shake.autoreverses = true
        
        let fromPoint = CGPoint(x: center.x - 5, y: center.y)
        let fromValue = NSValue(cgPoint: fromPoint)
        
        let toPoint = CGPoint(x: center.x + 5, y: center.y)
        let toValue = NSValue(cgPoint: toPoint)
        
        shake.fromValue = fromValue
        shake.toValue = toValue
        
        layer.add(shake, forKey: "position")
    }
 }
 
 
 // *********** ************ *********** ************ *********** ************ *********** ************ *********** ************
 /// #UITabBar
 // *********** ************ *********** ************ *********** ************ *********** ************ *********** ************
 
 extension UITabBar {
    override open func sizeThatFits(_ size: CGSize) -> CGSize {
        super.sizeThatFits(size)
        guard let window = UIApplication.shared.keyWindow else {
            return super.sizeThatFits(size)
        }
        var sizeThatFits = super.sizeThatFits(size)
        if #available(iOS 11.0, *) {
            sizeThatFits.height = window.safeAreaInsets.bottom + 54
        } else {
            sizeThatFits.height = 54
        }
        return sizeThatFits
    }
 }
 
 // *********** ************ *********** ************ *********** ************ *********** ************ *********** ************
 /// #Date
 // *********** ************ *********** ************ *********** ************ *********** ************ *********** ************
 
 extension Date {
    static var yesterday: Date { return Date().dayBefore }
    static var tomorrow:  Date { return Date().dayAfter }
    var dayBefore: Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: noon)!
    }
    var dayAfter: Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: noon)!
    }
    var noon: Date {
        return Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: self)!
    }
    var month: Int {
        return Calendar.current.component(.month,  from: self)
    }
    var isLastDayOfMonth: Bool {
        return dayAfter.month != month
    }
    
    func interval(ofComponent comp: Calendar.Component, fromDate date: Date) -> Int {
        
        let currentCalendar = Calendar.current
        
        guard let start = currentCalendar.ordinality(of: comp, in: .era, for: date) else { return 0 }
        guard let end = currentCalendar.ordinality(of: comp, in: .era, for: self) else { return 0 }
        
        return end - start
    }
    
 }
 
 
 
 // *********** ************ *********** ************ *********** ************ *********** ************ *********** ************
 /// #UISearchBar
 // *********** ************ *********** ************ *********** ************ *********** ************ *********** ************
 
 
 
 extension UISearchBar {
    var textField: UITextField? {
        let textFieldInsideSearchBar = self.value(forKey: "searchField") as? UITextField
        return textFieldInsideSearchBar
    }
 }
