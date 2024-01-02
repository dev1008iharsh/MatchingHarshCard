//
//  ViewController.swift
//  CardGameHarsh
//
//  Created by My Mac Mini on 11/12/23.
//

import UIKit

class HomeVC: UIViewController {
    
    // MARK: - @IBOutlet
    
    @IBOutlet weak var lblTimer: UILabel!
    
    @IBOutlet weak var cvCard: UICollectionView!
    
    
    // MARK: - PROPERTIES
    
    var model = CardModel()
    
    var marrCardToDisplay = [CardProperties]()
    
    var timer:Timer?
    
    var milliseconds:Int = 0
    
    var firstFlippedCardIndex:IndexPath?
   
    var soundPlayer = SoundManager()
    
    var isPortrait = true
    
    var spaceBetweenCell : CGFloat = 10
    
    // MARK: - LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        startGame()
        
        cvCard.dataSource = self
        cvCard.delegate = self
        lblTimer.textColor = .black
        
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        // Play shuffle sound
        soundPlayer.playSound(effect: .shuffle)
        
        
    }
    
    
    func startGame(){
        
        //10 SECOND TIMER
        milliseconds = 99 * 1000
        marrCardToDisplay = model.getCards()
        timer = Timer.scheduledTimer(timeInterval: 0.001, target: self, selector: #selector(timerFired), userInfo: nil, repeats: true)
        RunLoop.main.add(timer!, forMode: .common)
        //RUNLOOP FOR TIMER CONTINUTY DURING THE SCROLLING
        
    }
    
    
    // MARK: - Timer Methods
    
    @objc func timerFired(){
        milliseconds = milliseconds - 1
        //milliseconds -= 1
        
        let seconds : Double = Double(milliseconds)/1000.0
        
        lblTimer.text = String(format: "  Time Remaining : %.2f", seconds)
        
        if milliseconds == 0 {
            
            lblTimer.textColor = UIColor.red
            timer?.invalidate()
            
            // Check if the user has cleared all the pairs
            checkForGameEnd()
            
        }
        
    }
    
    
    
    
}
// MARK: - Collection View Delegate Datasourse Methods
extension HomeVC : UICollectionViewDelegate,UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        // Return total number of cards
        return marrCardToDisplay.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cellCard = collectionView.dequeueReusableCell(withReuseIdentifier: "CardCVC", for: indexPath) as! CardCVC
         
         let currentCard = marrCardToDisplay[indexPath.row]
         cellCard.configureCell(card : currentCard)
          
        return cellCard
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        /*
        let cellCardCurrent = cell as? CardCVC
        
        // Get the card from the card array
        let currentCard = self.marrCardToDisplay[indexPath.row]
        
        // Finish configuring the cell
        cellCardCurrent?.configureCell(card: currentCard)
        */
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if milliseconds <= 0 {
            return
        }
        
        // Get a reference to the cell that was tapped
        let cell = collectionView.cellForItem(at: indexPath) as? CardCVC
        
        if cell?.myCard?.isFlipped == false && cell?.myCard?.isMatched == false {
            
            cell?.flipUpCard()
            
            soundPlayer.playSound(effect: .flip)
            
            
            // Check if this is the first card that was flipped or the second card
            if firstFlippedCardIndex == nil{
                
                firstFlippedCardIndex = indexPath
                
            }else{
                
                // Get the two card objects for the two indices and see if they match
                let firstFlippedCard = marrCardToDisplay[firstFlippedCardIndex!.row]
                let secondFlippedCard = marrCardToDisplay[indexPath.row]
                
                // Get the two collection view cells that represent card one and two
                let firstFlippedCell = collectionView.cellForItem(at: firstFlippedCardIndex!) as? CardCVC
                let secondFlippedCell = collectionView.cellForItem(at: indexPath) as? CardCVC
                
                
                if firstFlippedCard.imgName ==  secondFlippedCard.imgName{
                    
                    // It's a match
                    
                    soundPlayer.playSound(effect: .match)
                    
                    // Set the status and remove them
                    firstFlippedCard.isMatched = true
                    secondFlippedCard.isMatched = true
                    
                    firstFlippedCell?.removeCard()
                    secondFlippedCell?.removeCard()
                    
                    checkForGameEnd()
                    
                }else{
                    
                    //dont match - Resett - flip them back to normal position
                    
                    soundPlayer.playSound(effect: .nomatch)
                    
                    firstFlippedCard.isFlipped = false
                    secondFlippedCard.isFlipped = false
                    
                    firstFlippedCell?.flipDownCard()
                    secondFlippedCell?.flipDownCard()
                }
                firstFlippedCardIndex = nil
            }
            
        }
        
    }
    
    func checkForGameEnd() {
        
        // Check if there's any card that is unmatched
        // Assume the user has won, loop through all the cards to see if all of them are matched
        var isWonGame = true
        
        for card in marrCardToDisplay {
            
            if card.isMatched == false {
                // We've found a card that is unmatched
                isWonGame = false
                break
            }
        }
        
        if isWonGame == true {
            
            // User has won, show an alert
            //showAlert(title: "Congratulations!", message: "You've won the game!")
            
            let sucessControl = UIAlertController(title: "Congratulations!", message: "You've won the game!", preferredStyle: .alert)
            let byeAction = UIAlertAction(title: "BYE-BYE", style: .default) { byeAction in
                exit(0)
            }
            sucessControl.addAction(byeAction)
            present(sucessControl, animated: true, completion: nil)
            
        }
        else {
            
            // User hasn't won yet, check if there's any time left
            if milliseconds <= 0 {
                //showAlert(title: "Time's Up", message: "Sorry, better luck next time!")
                
                let alertControl = UIAlertController(title: "Time's Up", message: "Sorry,You lost the Game. Better luck next time! Restarting GAME...", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .cancel) { okAction in
                    self.startGame()
                    self.lblTimer.textColor = .black
                    self.cvCard.reloadData()
                }
                alertControl.addAction(okAction)
                present(alertControl, animated: true, completion: nil)
            }
            
        }
        
    }
    
    
}



extension HomeVC: UICollectionViewDelegateFlowLayout {
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        
        if let layout = cvCard.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.invalidateLayout()
        }
    }
    
    func setCollectionViewItemSize(size: CGSize) -> CGSize {
        
        /*if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene, windowScene.activationState == .foregroundActive, let window = windowScene.windows.first {
        }*/
        
        let windowScene = UIApplication.shared.connectedScenes.first as! UIWindowScene
        if windowScene.interfaceOrientation.isPortrait {
            let width = ((size.width - (2 * spaceBetweenCell)) / 3) - 13
            print("width Portrait : \(width)")
            return CGSize(width: width, height: 170)
        } else {
            let width = ((size.width - (4 * spaceBetweenCell)) / 5) - 10
            print("width Landscape : \(width)")
            return CGSize(width: width, height: 170)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
     
        let safeFrame = view.safeAreaLayoutGuide.layoutFrame
        let size = CGSize(width: safeFrame.size.width, height: safeFrame.size.height)
        return setCollectionViewItemSize(size: size)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        let windowScene = UIApplication.shared.connectedScenes.first as! UIWindowScene
        if windowScene.interfaceOrientation.isPortrait {
            return 18
        }else{
            return 23
        }
         
    }
     
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        //return .zero
        return UIEdgeInsets(top: 45, left: 15, bottom: 10, right: 15)
        
    }
    
    
}
 
