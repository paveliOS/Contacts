import SkyFloatingLabelTextField

final class FloatingLabelField: SkyFloatingLabelTextField {
    
    var textValue: String? {
        return text!.isEmpty ? nil : text
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        selectedLineHeight = 0
        lineHeight = 0
        selectedTitleColor = placeholderColor
        titleFormatter = { $0 }
    }

}
