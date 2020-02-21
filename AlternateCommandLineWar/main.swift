//
//  main.swift
//  AlternateCommandLineWar
//
//  Created by Gordon, Russell on 2020-02-12.
//  Copyright © 2020 Gordon, Russell. All rights reserved.
//

import Foundation

class BeggarYourNeighbour {
    
    var player : Hand
    var computer : Hand
    var pot : Hand
    
    var offence : Hand
    var defence : Hand
    
    // Statistics for game
    var hands : Int = 0
    var playerWins : Int = 0
    
    // The deck of cards
    var deck : Deck
    
    init() {
        
        player = Hand(description: "player")
        computer = Hand(description: "computer")
        pot = Hand(description: "pot")
        
        offence = player
        defence = computer
        
        // Make a deck of cards
        deck = Deck()
        
        // Deal to the player
        if let newCards = self.deck.randomlyDealOut(thisManyCards: 26) {
            player.cards = newCards
        }
        
        // Deal to the computer
        if let newCards = self.deck.randomlyDealOut(thisManyCards: 26) {
            computer.cards = newCards
        }
        
        // Pot is empty to begin
        pot.cards = []
        
        play()
        
    }
    
    func switchWhoIsOnOffence() {
        
        if offence === player {
            // Offence is player, so...
            offence = computer
            defence = player
        }
        else {
            // Offence is computer, so...
            offence = player
            defence = computer
        }
        
    }
    
    /// Implement a showdown - the defence must trigger a new showdown or lose the pot to the offence
    /// - Returns: true when the show down completed and offence won cards
    func showDown() -> Bool {
        
        var skipAssigningCardsToWinner: Bool = false
        
        // Repeat based on the raw value of the face card
        // Ace - 4 times
        // King - 3 times
        // etc
        for _ in 1...pot.topCard!.rank.rawValue - 10 {
            // Defense plays top card
            pot.cards.append(defence.dealTopCard()!)
            
            // If defense is able to play a face card
            if pot.topCard!.rank.rawValue > 10 {
                // Switch who is on offence so they play next
                switchWhoIsOnOffence()
                
                // Re-do showdown with reversed roles
                if showDown() == true { //
                    skipAssigningCardsToWinner = true
                    break // stop the loop
                }
            }
        }
        
        // If we get here, the offence has won since the defence did not trigger a new showdown
        // Offence gets all the cards only at the lowest recursion level
        if skipAssigningCardsToWinner == false {
            // Assign the cards to the winner
            defence.cards.append(contentsOf: pot.cards)
        }
        return true // this signals that cards were already assigned to winner
        
    }
    
    private func play() {
        // Offense plays top card
        pot.cards.append(offence.dealTopCard()!)
        
        if pot.topCard!.rank.rawValue > 10 {
            // If the most recently played card is a jack, queen, king, or ace
            // Show down
            showDown()
        } else {
            // Switch who is on offence so they play next
            switchWhoIsOnOffence()
        }
    }
}



//// Create a new datatype to represent a game of war
//class War {
//
//    // Statistics for game
//    var hands : Int = 0
//    var playerWins : Int = 0
//
//    // The deck of cards
//    var deck : Deck
//
//    // The hands for each player
//    var player : WarHand
//    var computer : WarHand
//
//    // The bounty when there is a war
//    var bounty : Hand
//
//    // Whether to show extreme detail
//    var debugMode : Bool
//
//    // Set up and simulate the game
//    init(debugMode: Bool = false) {
//
//        // Make a deck of cards
//        deck = Deck()
//
//        // Initialize the hands
//        player = WarHand(description: "player")
//        computer = WarHand(description: "computer")
//        bounty = Hand(description: "bounty")
//
//        // Deal to the player
//        if let newCards = self.deck.randomlyDealOut(thisManyCards: 26) {
//            player.cards = newCards
//        }
//
//        // Deal to the computer
//        if let newCards = self.deck.randomlyDealOut(thisManyCards: 26) {
//            computer.cards = newCards
//        }
//
//        // Bounty is empty to begin
//        bounty.cards = []
//
//        // Show extreme detail?
//        self.debugMode = debugMode
//
//        // Play the game
//        play()
//
//    }
//
//    // This function implements the primary logic for the game of War
//    private func play() {
//
//        // Game is about to start
//        print("==========")
//        print("Game start")
//        print("==========")
//
//        // This loop will repeat until the player either loses or wins by having all or no cards
//        while player.hasNotWon() {
//
//            // Track result
//            hands += 1
//
//            // Report on hand starting
//            print("-----------------------------")
//            print("Now starting hand \(hands)...")
//
//            // Show player's regular hand
//            player.status(verbose: debugMode)
//
//            // Show computer's regular hand
//            computer.status(verbose: debugMode)
//
//            // Compare the top cards of the two players
//            compareTopCards()
//
//        }
//
//        // Show player's hand
//        player.status(verbose: debugMode)
//
//        // Show computer's hand
//        computer.status(verbose: debugMode)
//
//        // Determine who won in the end
//        if player.cards.count == 0 {
//            print("Computer wins (end of game)")
//        } else {
//            print("Player wins (end of game)")
//        }
//
//        // Print game rseults
//        report()
//    }
//
//
//    // This function handles a war
//    private func aWarHappens() {
//
//        // It's a war!
//        print("It's a war!")
//
//        // First, check to see that another war is even playable...
//
//        // If both players have at least four cards, a war is possible
//        if player.cards.count >= 4 && computer.cards.count >= 4 {
//
//            // Play a war
//
//            // Build the bounty
//            for _ in 0...2 {
//                bounty.cards.append(player.dealTopCard()!)
//                bounty.cards.append(computer.dealTopCard()!)
//            }
//
//            // Report
//            if debugMode {
//                bounty.status(verbose: debugMode)
//            }
//
//            // Compare top cards
//            compareTopCards()
//
//        } else if player.cards.count > computer.cards.count {
//
//            // Player gets all cards, wins, game is over
//            player.cards.append(contentsOf: computer.cards)
//            computer.cards.removeAll()
//            player.cards.append(contentsOf: bounty.cards)
//            bounty.cards.removeAll()
//
//        } else if computer.cards.count > player.cards.count {
//
//            // Computer gets all cards, wins, game is over
//            computer.cards.append(contentsOf: player.cards)
//            player.cards.removeAll()
//            computer.cards.append(contentsOf: bounty.cards)
//            bounty.cards.removeAll()
//
//        } else {
//
//            // Special cases... when players have same number of cards
//            if player.cards.count == 0 {
//
//                // Both players have no cards
//                fatalError("Both players have no cards, this shouldn't be possible.")
//
//            } else if player.cards.count == 1 {
//
//                // Both players have a single card
//                if player.topCard!.beats(computer.topCard!) {
//
//                    // Add remaining cards to bounty
//                    addTopCardsToBounty()
//
//                    // Player gets bounty
//                    player.cards.append(contentsOf: bounty.cards)
//
//                    // Clear the bounty
//                    bounty.cards.removeAll()
//
//                    // Track result
//                    playerWins += 1
//
//                } else {
//
//                    // Add remaining cards to bounty
//                    addTopCardsToBounty()
//
//                    // Computer gets bounty
//                    computer.cards.append(contentsOf: bounty.cards)
//
//                    // Clear the bounty
//                    bounty.cards.removeAll()
//
//                }
//
//            } else {
//
//                // Each player has two cards, or each player has three cards...
//
//                // Add all but final card to the bounty
//                for _ in 0...player.cards.count - 1 {
//                    bounty.cards.append(player.dealTopCard()!)
//                    bounty.cards.append(computer.dealTopCard()!)
//                }
//
//                // Compare the top card to see who wins
//                compareTopCards()
//
//            }
//
//        }
//
//        // War is over
//        return
//
//    }
//
//    // Adds the top cards for both players to the bounty
//    func addTopCardsToBounty() {
//        bounty.cards.append(player.dealTopCard()!)
//        bounty.cards.append(computer.dealTopCard()!)
//    }
//
//    // Compares the two top cards and takes action as needed
//    func compareTopCards() {
//
//        // Compare the two top cards
//        if player.topCard!.beats(computer.topCard!) {
//
//            // Player wins...
//            print("Player won, player top card was \(player.topCard!.simpleDescription()) and computer top card was \(computer.topCard!.simpleDescription()).")
//
//            // Add top cards to the bounty
//            addTopCardsToBounty()
//
//            // Player gets entire bounty
//            player.cards.append(contentsOf: bounty.cards)
//
//            // Clear the bounty
//            bounty.cards.removeAll()
//
//            // Track result
//            playerWins += 1
//
//        } else if computer.topCard!.beats(player.topCard!) {
//
//            // Computer wins...
//            print("Computer won, computer top card was \(computer.topCard!.simpleDescription()) and player top card was \(player.topCard!.simpleDescription()).")
//
//            // Add top cards to the bounty
//            addTopCardsToBounty()
//
//            // Computer gets entire bounty
//            computer.cards.append(contentsOf: bounty.cards.reversed())
//
//            // Clear the bounty
//            bounty.cards.removeAll()
//
//        } else {
//
//            // Tie...
//
//            // Cards that caused war go in the bounty
//            addTopCardsToBounty()
//
//            // It's a war!
//            aWarHappens()
//        }
//
//    }
//
//    // Report results
//    func report() {
//        print("===================")
//        print("Game results are...")
//        print("\(self.hands) total hands played")
//        print("Player won \(self.playerWins) hands")
//        print("Computer won \(self.hands - self.playerWins) hands")
//    }
//}
//
//War(debugMode: false)

