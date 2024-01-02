//
//  CardCVC.swift
//  CardGameHarsh
//
//  Created by My Mac Mini on 11/12/23.
//

import UIKit

class CardCVC: UICollectionViewCell {
    
    // MARK: - @IBOutlet
    
    @IBOutlet weak var imgFront: UIImageView!
    
    @IBOutlet weak var imgBack: UIImageView!
    
    
    // MARK: - PROPERTIES
    
    //var myCard = CardProperties()
    var myCard:CardProperties?
    
    
    // MARK: - CONFIGURE CELL
    
    func configureCell(card : CardProperties){
        self.imgFront.contentMode = .scaleAspectFit
        self.imgBack.contentMode = .scaleAspectFit
        self.myCard = card
        
        // Set the front image view to the image that represents the card
        imgFront.image = UIImage(named: myCard!.imgName)
        
        
        // Reset the state of the cell by checking the flipped status of the card and then showing the front or the back imageview accordingly
        if myCard?.isMatched == true{
            
            // show front image - from back to front image
            imgBack.alpha = 0
            imgFront.alpha = 0
            return
            
        }else{
            
            // show back image
            imgBack.alpha = 1
            imgFront.alpha = 1
            
        }
        
        
        // Set flip properties
        if myCard?.isFlipped == true{
            flipUpCard(speed: 0)
        }else{
            flipDownCard(speed: 0, delay: 0)
        }
        
    }
    
    func flipUpCard(speed : TimeInterval = 0.3){
        UIView.transition(from: imgBack, to: imgFront, duration: speed,options: [.showHideTransitionViews,.transitionFlipFromLeft])
        myCard?.isFlipped = true
    }
    
    func flipDownCard(speed : TimeInterval = 0.3,delay:TimeInterval = 0.5){
        
        myCard?.isFlipped = false
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delay) {
            UIView.transition(from: self.imgFront, to: self.imgBack, duration: speed,options: [.showHideTransitionViews,.transitionFlipFromLeft])
        }
        
        
    }
    
    func removeCard(){
        
        // Make the image views invisible
        imgBack.alpha = 0
        UIView.animate(withDuration: 0.3, delay: 0.5,options: .curveEaseOut) {
            self.imgFront.alpha = 0
        }
        
    }
    
    
}
