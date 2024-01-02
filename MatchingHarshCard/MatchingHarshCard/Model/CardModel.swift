//
//  CardModel.swift
//  CardGameHarsh
//
//  Created by My Mac Mini on 11/12/23.
//

import Foundation
import UIKit

var orientationLock = true
class CardModel{
    
    func getCards() -> [CardProperties]{
        
        var arrRandomNumber = [Int]()
        var arrCardProperties = [CardProperties]()
        
        // Randomly generate 8 pairs of cards
        while arrRandomNumber.count < 12 {
            
            let randomNumber = Int.random(in: 1...13)
            
            //if generatedNumbers.contains(randomNumber) == false {
            if !(arrRandomNumber.contains(randomNumber)){
                
                //create same card to match them
                let firstCard = CardProperties()
                let secondCard = CardProperties()
                
                firstCard.imgName = "card\(randomNumber)"
                secondCard.imgName = "card\(randomNumber)"
                
                arrCardProperties += [firstCard,secondCard]
                
                arrRandomNumber.append(randomNumber)
                
                print("arrGeneratedNumber : ",arrRandomNumber)
                
            }
            
        }
        
        arrCardProperties.shuffle()
        
        return arrCardProperties
    }
    
}


