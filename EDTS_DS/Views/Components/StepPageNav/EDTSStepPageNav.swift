//
//  StepPageNav.swift
//  Poinku-DS
//
//  Created by Rizka Ghinna Auliya on 12/06/25.
//

import UIKit

public class EDTSStepPageNav: UIView {
    
    @IBOutlet var containerView: UIView!
    @IBOutlet var lblStep1: UILabel!
    @IBOutlet var lblTitle1: UILabel!
    @IBOutlet var lblStep2: UILabel!
    @IBOutlet var lblTitle2: UILabel!
    @IBOutlet var lblStep3: UILabel!
    @IBOutlet var lblTitle3: UILabel!
    @IBOutlet var vStep1: UIStackView!
    @IBOutlet var vStep2: UIStackView!
    @IBOutlet var vStep3: UIStackView!
    @IBOutlet var vDivider1: UIProgressView!
    @IBOutlet var vDivider2: UIProgressView!
    
    private var progressTimer: Timer?
    
    public var title: [String] = [] {
        didSet {
            setupUI()
        }
    }
    public var currentStep: Int = 0 {
        didSet {
            setupUI()
        }
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupStepPageNav()
    }
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        
        setupUI()
    }
    
    private func setupStepPageNav() {
        let bundle = Bundle(for: type(of: self))
        if let nib = bundle.loadNibNamed("EDTSStepPageNav", owner: self, options: nil),
           let view = nib.first as? UIView {
            containerView = view
            containerView.frame = bounds
            containerView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
            addSubview(containerView)
            
            setupUI()
        } else {
            print("Failed to load StepPageNav XIB")
        }
    }
    
    private func setupUI() {
        lblStep1.layer.cornerRadius = 8
        lblStep2.layer.cornerRadius = 8
        lblStep3.layer.cornerRadius = 8
        
        lblStep1.layer.masksToBounds = true
        lblStep2.layer.masksToBounds = true
        lblStep3.layer.masksToBounds = true
        
        if !title.isEmpty && title.count == 3 {
            lblTitle1.text = title[0]
            lblTitle2.text = title[1]
            lblTitle3.text = title[2]
        }
        
        setupStepColor()
    }
    
    private func setupStepColor() {
        progressTimer?.invalidate()
        progressTimer = nil
        
        let scaleTransform = CGAffineTransform(scaleX: 1.15, y: 1.15)
        let originalTransform = CGAffineTransform.identity
        let scaleDuration: TimeInterval = 0.3
        let progressDuration: TimeInterval = 0.6
        let progressInterval: TimeInterval = 0.001
        
        let totalSteps = progressDuration / progressInterval
        let progressIncrement: Float = 1.0 / Float(totalSteps)
        
        if currentStep == 1 {
            vStep1.transform = originalTransform
            
            vDivider1.progress = 0.0
            vDivider2.progress = 0.0
            
            lblStep1.backgroundColor = EDTSColor.blue30
            lblStep2.backgroundColor = EDTSColor.grey40
            lblStep3.backgroundColor = EDTSColor.grey40
            
            lblTitle1.textColor = EDTSColor.blue30
            lblTitle2.textColor = EDTSColor.grey40
            lblTitle3.textColor = EDTSColor.grey40
            
            UIView.animate(withDuration: scaleDuration, delay: 0.3, options: [], animations: {
                self.vStep1.transform = scaleTransform
            }) { (_) in
                UIView.animate(withDuration: scaleDuration) {
                    self.vStep1.transform = originalTransform
                }
            }
            
        } else if currentStep == 2 {
            lblStep1.backgroundColor = EDTSColor.blue30
            lblTitle1.textColor = EDTSColor.blue30
            
            lblStep2.backgroundColor = EDTSColor.grey40
            lblTitle2.textColor = EDTSColor.grey40
            lblStep3.backgroundColor = EDTSColor.grey40
            lblTitle3.textColor = EDTSColor.grey40
            
            vDivider1.progress = 0.0
            vDivider2.progress = 0.0
            
            var currentProgress: Float = 0.0
            progressTimer = Timer.scheduledTimer(withTimeInterval: progressInterval, repeats: true) { [weak self] timer in
                guard let self = self else {
                    timer.invalidate()
                    return
                }
                
                currentProgress += progressIncrement
                if currentProgress >= 1.0 {
                    currentProgress = 1.0
                    timer.invalidate()
                    
                    self.lblStep2.backgroundColor = EDTSColor.blue30
                    self.lblTitle2.textColor = EDTSColor.blue30
                    
                    UIView.animate(withDuration: scaleDuration, animations: {
                        self.vStep2.transform = scaleTransform
                    }) { (_) in
                        UIView.animate(withDuration: scaleDuration) {
                            self.vStep2.transform = originalTransform
                        }
                    }
                }
                self.vDivider1.setProgress(currentProgress, animated: false)
            }
            
            RunLoop.current.add(progressTimer!, forMode: .common)
            
        } else {
            lblStep1.backgroundColor = EDTSColor.blue30
            lblStep2.backgroundColor = EDTSColor.blue30
            lblTitle1.textColor = EDTSColor.blue30
            lblTitle2.textColor = EDTSColor.blue30
            
            lblStep3.backgroundColor = EDTSColor.grey40
            lblTitle3.textColor = EDTSColor.grey40
            
            vDivider1.progress = 1.0
            vDivider2.progress = 0.0
            
            var currentProgress: Float = 0.0
            progressTimer = Timer.scheduledTimer(withTimeInterval: progressInterval, repeats: true) { [weak self] timer in
                guard let self = self else {
                    timer.invalidate()
                    return
                }
                
                currentProgress += progressIncrement
                if currentProgress >= 1.0 {
                    currentProgress = 1.0
                    timer.invalidate()
                    
                    self.lblStep3.backgroundColor = EDTSColor.blue30
                    self.lblTitle3.textColor = EDTSColor.blue30
                    
                    UIView.animate(withDuration: scaleDuration, animations: {
                        self.vStep3.transform = scaleTransform
                    }) { (_) in
                        UIView.animate(withDuration: scaleDuration) {
                            self.vStep3.transform = originalTransform
                        }
                    }
                }
                self.vDivider2.setProgress(currentProgress, animated: false)
            }
            
            RunLoop.current.add(progressTimer!, forMode: .common)
            
        }
    }
}
