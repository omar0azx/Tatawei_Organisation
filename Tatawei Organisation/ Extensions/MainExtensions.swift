//
//  MainExtensions.swift
//  Tatawei Student
//
//  Created by omar alzhrani on 24/03/1446 AH.
//

import UIKit

@IBDesignable
class DesignableView: UIView {
    
    let gradientLayer = CAGradientLayer()
    let shapeLayer = CAShapeLayer()
    
    @IBInspectable
    var topGradientColor: UIColor? {
        didSet {
            setGradient(topGradientColor: topGradientColor, bottomGradientColor: bottomGradientColor)
        }
    }
    
    @IBInspectable
    var bottomGradientColor: UIColor? {
        didSet {
            setGradient(topGradientColor: topGradientColor, bottomGradientColor: bottomGradientColor)
        }
    }
    
    private func setGradient(topGradientColor: UIColor?, bottomGradientColor: UIColor?) {
        if let topGradientColor = topGradientColor, let bottomGradientColor = bottomGradientColor {
            gradientLayer.frame = bounds
            gradientLayer.colors = [topGradientColor.cgColor, bottomGradientColor.cgColor]
            gradientLayer.borderColor = layer.borderColor
            gradientLayer.borderWidth = layer.borderWidth
            gradientLayer.cornerRadius = layer.cornerRadius
            layer.insertSublayer(gradientLayer, at: 0)
        } else {
            gradientLayer.removeFromSuperlayer()
        }
    }
}

@IBDesignable
class DesignableTableView: UITableView {
    
    let gradientLayer = CAGradientLayer()
    
    @IBInspectable
    var topGradientColor: UIColor? {
        didSet {
            setGradient(topGradientColor: topGradientColor, bottomGradientColor: bottomGradientColor)
        }
    }
    
    @IBInspectable
    var bottomGradientColor: UIColor? {
        didSet {
            setGradient(topGradientColor: topGradientColor, bottomGradientColor: bottomGradientColor)
        }
    }
    
    private func setGradient(topGradientColor: UIColor?, bottomGradientColor: UIColor?) {
        if let topGradientColor = topGradientColor, let bottomGradientColor = bottomGradientColor {
            gradientLayer.frame = bounds
            gradientLayer.colors = [topGradientColor.cgColor, bottomGradientColor.cgColor]
            gradientLayer.borderColor = layer.borderColor
            gradientLayer.borderWidth = layer.borderWidth
            gradientLayer.cornerRadius = layer.cornerRadius
            layer.insertSublayer(gradientLayer, at: 0)
        } else {
            gradientLayer.removeFromSuperlayer()
        }
    }
    
}

@IBDesignable
class DesignableButton: UIButton {
    
    let gradientLayer = CAGradientLayer()
    
    @IBInspectable
    var topGradientColor: UIColor? {
        didSet {
            setGradient(topGradientColor: topGradientColor, bottomGradientColor: bottomGradientColor)
        }
    }
    
    @IBInspectable
    var bottomGradientColor: UIColor? {
        didSet {
            setGradient(topGradientColor: topGradientColor, bottomGradientColor: bottomGradientColor)
        }
    }
    
    private func setGradient(topGradientColor: UIColor?, bottomGradientColor: UIColor?) {
        if let topGradientColor = topGradientColor, let bottomGradientColor = bottomGradientColor {
            gradientLayer.frame = bounds
            gradientLayer.colors = [topGradientColor.cgColor, bottomGradientColor.cgColor]
            gradientLayer.borderColor = layer.borderColor
            gradientLayer.borderWidth = layer.borderWidth
            gradientLayer.cornerRadius = layer.cornerRadius
            layer.insertSublayer(gradientLayer, at: 0)
        } else {
            gradientLayer.removeFromSuperlayer()
        }
    }
}

@IBDesignable
class DesignableLabel: UILabel {
}

@IBDesignable
class DesignableImage: UIImageView {
    @IBInspectable
    override var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue
        }
    }
    
    @IBInspectable
    override var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
        }
    }
    
    @IBInspectable
    override var shadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        set {
            layer.shadowOffset = newValue
        }
    }
}

@IBDesignable
class DesignableTextField: UITextField {
    
    @IBInspectable
    var underline: CGFloat = 0 {
        didSet {
            if underline > 0 { addUnderlineLayer(lineWidth: underline) }
        }
    }
    
    @IBInspectable
    var lineColor: UIColor = .black {
        didSet {
            if underline > 0 { addUnderlineLayer(lineWidth: underline) }
        }
    }
    
    @IBInspectable
    override var placeHolderColor: UIColor? {
        get {
            return self.placeHolderColor
        }
        set {
            self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSAttributedString.Key.foregroundColor: newValue!])
        }
    }
    
    func addUnderlineLayer(lineWidth: CGFloat) {
        let bottomLayer = CALayer()
        bottomLayer.frame = CGRect(x: 0, y: frame.height, width: frame.width , height: lineWidth)
        bottomLayer.backgroundColor = lineColor.cgColor
        layer.addSublayer(bottomLayer)
    }
    
}

extension UITextField {
    func convertToDate() {
            let datePicker = UIDatePicker()
            datePicker.datePickerMode = .date
            datePicker.addTarget(self, action: #selector(dateChange(datePicker:)), for: .valueChanged)
            datePicker.preferredDatePickerStyle = .wheels
            datePicker.minimumDate = Date() // Set minimum date to today
            datePicker.maximumDate = Calendar.current.date(byAdding: .year, value: 1, to: Date()) // Set max date to 1 year from now
            
            self.inputView = datePicker
        }
        
        @objc private func dateChange(datePicker: UIDatePicker) {
            self.text = formatDate(date: datePicker.date)
        }
        
        private func formatDate(date: Date) -> String {
            let formatter = DateFormatter()
            formatter.dateFormat = "dd/MM/yyyy"
            return formatter.string(from: date)
        }
        
        func convertToTime() {
            let timePicker = UIDatePicker()
            timePicker.datePickerMode = .time
            timePicker.addTarget(self, action: #selector(timeChange(timePicker:)), for: .valueChanged)
            timePicker.preferredDatePickerStyle = .wheels
            
            self.inputView = timePicker
        }
        
        @objc private func timeChange(timePicker: UIDatePicker) {
            self.text = formatTime(date: timePicker.date)
        }
        
        private func formatTime(date: Date) -> String {
            let formatter = DateFormatter()
            formatter.dateFormat = "h:mm a" // Format for AM/PM time
            return formatter.string(from: date)
        }
}

extension UIView {
    
    func bindToKeyBoard() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(_:)) , name: UIResponder.keyboardWillChangeFrameNotification , object: nil)
        
    }
    
    @objc func keyboardWillChange(_ notification: NSNotification ) {
        
        let duration = notification.userInfo![UIResponder.keyboardAnimationDurationUserInfoKey] as! Double
        let curve = notification.userInfo![UIResponder.keyboardAnimationCurveUserInfoKey] as! UInt
        let beginningFrame = (notification.userInfo![UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        let endFrame = (notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let deltaY = endFrame.origin.y - beginningFrame.origin.y
        UIView.animateKeyframes(withDuration: duration, delay: 0.0, options: UIView.KeyframeAnimationOptions(rawValue: curve), animations: {
            self.frame.origin.y += deltaY
        }, completion: nil)
        
    }
    
    
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
    var rotation: Int {
        get {
            return 0
        } set {
            let radians = CGFloat(CGFloat(Double.pi) * CGFloat(newValue) / CGFloat(180.0))
            self.transform = CGAffineTransform(rotationAngle: radians)
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
    
    @IBInspectable
    var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue
        }
    }
    
    @IBInspectable
    var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
        }
    }
    
    @IBInspectable
    var shadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        set {
            layer.shadowOffset = newValue
        }
    }
    
    @IBInspectable
    var shadowColor: UIColor? {
        get {
            if let color = layer.shadowColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.shadowColor = color.cgColor
            } else {
                layer.shadowColor = nil
            }
        }
    }
}

@IBDesignable
class EdgeInsetLabel: UILabel {
    var textInsets = UIEdgeInsets.zero {
        didSet { invalidateIntrinsicContentSize() }
    }
    
    override func textRect(forBounds bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
        let insetRect = bounds.inset(by: textInsets)
        let textRect = super.textRect(forBounds: insetRect, limitedToNumberOfLines: numberOfLines)
        let invertedInsets = UIEdgeInsets(top: -textInsets.top,
                                          left: -textInsets.left,
                                          bottom: -textInsets.bottom,
                                          right: -textInsets.right)
        return textRect.inset(by: invertedInsets)
    }
    
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: textInsets))
    }
}

private var __maxLengths = [UITextField: Int]()
extension UITextField {
    
    @IBInspectable var maxLength: Int {
        get {
            guard let l = __maxLengths[self] else {
                return 150 // (global default-limit. or just, Int.max)
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
    @IBInspectable var placeHolderColor: UIColor? {
        get {
            return self.placeHolderColor
        }
        set {
            self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSAttributedString.Key.foregroundColor: newValue!])
        }
    }
}

extension String {
    func safelyLimitedTo(length n: Int)->String {
        let c = self
        if (c.count <= n) { return self }
        return String( Array(c).prefix(upTo: n) )
    }
    func isNum(text: String) -> Bool{
        var o = text
        for char in o {
            if char.isNumber {
                continue
            } else {
                return false
            }
        }
        return true
    }
}

//Get nth character of a string in Swift programming language (return's String)
extension String {
    
    var length: Int {
        return count
    }
    
    subscript (i: Int) -> String {
        return self[i ..< i + 1]
    }
    
    func substring(fromIndex: Int) -> String {
        return self[min(fromIndex, length) ..< length]
    }
    
    func substring(toIndex: Int) -> String {
        return self[0 ..< max(0, toIndex)]
    }
    
    subscript (r: Range<Int>) -> String {
        let range = Range(uncheckedBounds: (lower: max(0, min(length, r.lowerBound)),
                                            upper: min(length, max(0, r.upperBound))))
        let start = index(startIndex, offsetBy: range.lowerBound)
        let end = index(start, offsetBy: range.upperBound - range.lowerBound)
        return String(self[start ..< end])
    }
    
}

// add strikethrough line style to String
extension String {
    func strikeThrough(range: NSRange? = nil) -> NSAttributedString {
        let attributeString =  NSMutableAttributedString(string: self)
        attributeString.addAttribute(
            NSAttributedString.Key.strikethroughStyle,
            value: NSUnderlineStyle.single.rawValue,
            range: range ?? NSMakeRange(0,attributeString.length) )
        return attributeString
    }
}

// add strikethrough line style to UILabel text
extension UILabel {
    
    func strikeThrough(_ isStrikeThrough: Bool = true) {
        if isStrikeThrough {
            if let lblText = self.text {
                let attributeString =  NSMutableAttributedString(string: lblText)
                attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: NSUnderlineStyle.single.rawValue, range: NSMakeRange(0,attributeString.length))
                self.attributedText = attributeString
            }
        } else {
            if let attributedStringText = self.attributedText {
                let txt = attributedStringText.string
                self.attributedText = nil
                self.text = txt
                return
            }
        }
    }
}

extension EdgeInsetLabel {
    @IBInspectable
    var leftTextInset: CGFloat {
        set { textInsets.left = newValue }
        get { return textInsets.left }
    }
    
    @IBInspectable
    var rightTextInset: CGFloat {
        set { textInsets.right = newValue }
        get { return textInsets.right }
    }
    
    @IBInspectable
    var topTextInset: CGFloat {
        set { textInsets.top = newValue }
        get { return textInsets.top }
    }
    
    @IBInspectable
    var bottomTextInset: CGFloat {
        set { textInsets.bottom = newValue }
        get { return textInsets.bottom }
    }
}

//this dismiss Keyboard
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

//fade out animation while dismissing a view controller
extension CATransition {
    func fadeTransition() -> CATransition {
        let transition = CATransition()
        transition.duration = 0.2
        transition.type = CATransitionType.fade
        transition.subtype = CATransitionSubtype.fromRight
        
        return transition
    }
}

extension UITextField: UIPickerViewDelegate, UIPickerViewDataSource {
    
    // A closure to notify when an option is selected
    var didSelectOption: ((Int) -> Void)? {
        get {
            return objc_getAssociatedObject(self, &UITextField.didSelectOptionKey) as? ((Int) -> Void)
        }
        set {
            objc_setAssociatedObject(self, &UITextField.didSelectOptionKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    // Function to convert the text field to a generic picker
    func convertToPicker(options: [String]) {
        let picker = UIPickerView()
        picker.delegate = self
        picker.dataSource = self
        
        self.inputView = picker // Set the picker as inputView
        
        // Store options in the text field's tag property for simplicity
        self.tag = options.count // Store options count for use in the delegate methods
        objc_setAssociatedObject(self, &UITextField.pickerOptionsKey, options, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    // MARK: - UIPickerViewDataSource methods
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1 // Single column picker
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerOptions?.count ?? 0 // Return the count of options
    }
    
    // MARK: - UIPickerViewDelegate methods
    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerOptions?[row] // Return the title for each row
    }
    
    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.text = pickerOptions?[row] // Update text field when an option is selected
        
        // Notify the view controller about the selected index
        didSelectOption?(row)
    }
    
    // Function to dismiss the keyboard
    @objc private func dismissKeyboard() {
        self.resignFirstResponder()
    }
    
    // Helper to retrieve options from associated objects
    private var pickerOptions: [String]? {
        return objc_getAssociatedObject(self, &UITextField.pickerOptionsKey) as? [String]
    }
    
    private static var pickerOptionsKey: UInt8 = 0
    private static var didSelectOptionKey: UInt8 = 0
}


extension UICollectionView {
    @IBInspectable
    override var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
}
