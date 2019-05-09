
private var stringTagHandle: UInt8 = 0

extension UIView {
    
    @IBInspectable
    var cornerRadiusValue: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
    
    @IBInspectable
    var borderWidthValue: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable
    var borderColorValue: UIColor? {
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
    var shadowRadiusValue: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue
        }
    }
    
    @IBInspectable
    var shadowOpacityValue: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
        }
    }
    
    @IBInspectable
    var shadowOffsetValue: CGSize {
        get {
            return layer.shadowOffset
        }
        set {
            layer.shadowOffset = newValue
        }
    }
    
    @IBInspectable
    var shadowColorValue: UIColor? {
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

    @IBInspectable public var stringTag:String? {
        get {
            if let object = objc_getAssociatedObject(self, &stringTagHandle) as? String {
                return object
            }
            return nil
        }
        set {
            objc_setAssociatedObject(self, &stringTagHandle, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    //this should work in a similar way to viewWithTag:
    public func viewWithStringTag(strTag:String) -> UIView? {

        if stringTag == strTag {
            return self
        }

        for view in subviews as! [UIView] {
            if let matchingSubview = view.viewWithStringTag(strTag: strTag) {
                return matchingSubview
            }
        }

        return nil
    }
}
