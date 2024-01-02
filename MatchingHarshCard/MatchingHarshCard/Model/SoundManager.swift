//
//  SoundManager.swift
//  CardGameHarsh
//
//  Created by My Mac Mini on 12/12/23.
//

import Foundation
import AVFoundation

class SoundManager {
    
    var audioPlayer : AVAudioPlayer?
    
    
    enum SoundEffect {
        case flip
        case match
        case nomatch
        case shuffle
    }
    
    
    func playSound(effect : SoundEffect){
        
        var soundFilename = ""
        
        switch effect {
            
        case .flip:
            soundFilename = "myCardFlipSound"
            
        case .match:
            soundFilename = "myCardMatchSound"
            
        case .nomatch:
            soundFilename = "myCardNoMatchSound"
            
        case .shuffle:
            soundFilename = "myCardShufflehSound"
            
        }
        
        let bundlePath = Bundle.main.path(forResource: soundFilename, ofType: ".wav")
        
        guard bundlePath != nil else {
            return
        }
        
        let urlSound = URL(fileURLWithPath: bundlePath ?? "")
        
        do{
            audioPlayer = try AVAudioPlayer(contentsOf: urlSound)
            audioPlayer?.play()
        }catch{
            return
        }
        
        
        
    }
    
}
