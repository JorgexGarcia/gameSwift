//
//  ViewController.swift
//  AimForThat
//
//  Created by Jorge Garcia Gonzalez on 31/10/22.
//

import UIKit
import QuartzCore

class ViewController: UIViewController {

    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var targetLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var roundsLabel: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var maxScoreLabel: UILabel!
    
    var currentValue: Int = 0
    var targetValue: Int = 0
    var roundValue: Int = 0
    var score: Int = 0
    var time: Int = 0
    var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.setupSlider()
        
        resetGame()
        updateLabes()
    }
    
    func setupSlider(){
        let thumbImageNormal = UIImage(named: "SliderThumb-Normal")
        let thumbImageSelected = UIImage(named: "SliderThumb-Highlighted")
        let trackLeftImage = UIImage(named: "SliderTrackLeft")
        let trackRightImage = UIImage(named: "SliderTrackRight")
        
        self.slider.setThumbImage(thumbImageNormal, for: .normal)
        self.slider.setThumbImage(thumbImageSelected, for: .highlighted)
        
        let insects = UIEdgeInsets(top: 0, left: 14, bottom: 0, right: 14)
        
        let trackLeftResizable = trackLeftImage?.resizableImage(withCapInsets: insects)
        let trackRightResizable = trackRightImage?.resizableImage(withCapInsets: insects)
        
        self.slider.setMinimumTrackImage(trackLeftResizable, for: .normal)
        self.slider.setMaximumTrackImage(trackRightResizable, for: .normal)
    }
    
    func startNewRound(){
        
        self.targetValue = 1 + Int(arc4random_uniform(100))
        self.currentValue = 50
        self.slider.value = Float(self.currentValue)
        self.roundValue += 1
    }
    
    func updateLabes(){
        self.targetLabel.text = "\(self.targetValue)"
        self.scoreLabel.text = "\(self.score)"
        self.roundsLabel.text = "\(self.roundValue)"
        self.timerLabel.text = "\(self.time)"
    }
    
    func resetGame(){
        self.score = 0
        self.roundValue = 0
        self.time = 60
        
        let currentMaxScore = UserDefaults.standard.integer(forKey: "max")
        self.maxScoreLabel.text = "\(currentMaxScore)"
        
        if(self.timer != nil) { self.timer?.invalidate() }
        
        self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(tick), userInfo: nil, repeats: true)
        
        self.startNewRound()
    }
    
    @objc func tick(){
        self.time -= 1
        self.timerLabel.text = "\(self.time)"
        if(self.time <= 0){
            
            let max = UserDefaults.standard.integer(forKey: "max")
            
            if(max < self.score) {
                UserDefaults.standard.set(self.score, forKey: "max")
            }
            
            self.resetGame()
            self.updateLabes()
        }
    }
    
    @IBAction func showAlert(_ sender: UIButton) {
        
        let difference: Int = abs(self.currentValue - self.targetValue)
        
        var points = 100 - difference
        
        let title : String
        
        switch difference {
        case 0 :
            title  = "Puntuaci??n perfecta"
            points = Int(10 * points)
        case 1...5:
            title = "Casi perfecto"
            points = Int(1.5 * Float(points))
        case 6...12:
            title = "Ha faltado poco..."
            points = Int(1.2 * Float(points))
        default:
            title = "Vuelve a intentarlo"
        }
        
        self.score += points
        
        let message = "Has marcado \(points) puntos"
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Ok", style: .default,handler: {
                action in
                    self.startNewRound()
                    self.updateLabes()
            }
        )
        
        alert.addAction(action)
        
        present(alert, animated: true)
        
    }
    
    @IBAction func sliderMove(_ sender: UISlider) {
        self.currentValue = lroundf(sender.value)
    }
    
    
    @IBAction func newGame(_ sender: UIButton) {
        self.resetGame()
        self.updateLabes()
        
    }
    
}

