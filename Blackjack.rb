#!/usr/bin/ruby

class Game
    def initialize()
        @cardsDeck = CardsDeck.new
        @player = Player.new
        @dealer  = Player.new
        @split = Player.new
        @isSplit = false
        @currentBet = 0
        @splitBet = 0
        @currentDeck = Player.new 
    end

    def Start()
        Update()
    end

    def Setup()
        @player.SetScore(0)
        @player.SetCardsNumber(0)
        @dealer.SetScore(0)
        @dealer.SetCardsNumber(0)
        @split.SetScore(0)
        @split.SetCardsNumber(0)
        @isSplit = false
        @splitBet = 0
        @currentBet = 0
    end

    def PlayWithDeck(deck, bet, description)
        puts "Now play: #{description}"
        @currentDeck = deck
        puts "Your score is: #{@currentDeck.GetScore}."
        puts "Now your move."
        choise = 'Y'
        while (choise != 'N')
            puts "Get card? (Y / N)"
            choise = gets.chop
            if (choise != 'Y')
                if (choise != 'N')
                    next
                else
                    break
                end
            end

            card = @cardsDeck.GetCard
            puts "You get the card: #{card}."
            if (card == 11)
                if (@currentDeck.GetScore > 11)
                    puts "11 turns into 1."
                    card = 1
                end
            end

            @currentDeck.SetNewCard(card)
            puts "Your score is: #{@currentDeck.GetScore}."
            if (@currentDeck.GetScore > 21)
                puts "Defeat, you have more than 21. You lose #{bet}."
                if (!@isSplit)
                    Update()
                else
                    break
                end
            end

            if (@currentDeck.GetScore == 21)
                puts "You have 21!"
                if (@currentDeck.GetCardsNumber == 2) && ((@dealer.GetScore != 10) || (@dealer.GetScore != 11))
                    puts "You have BlackJack, and Dealer don't have BlackJack. You win 3 / 2 at your bet."
                    bet *= 1.5
                    puts "You win #{bet}."
                    @player.SetMoney(@currentDeck.GetMoney + bet)
                    if (!@isSplit)
                        Update()
                    else
                        break
                    end
                end
                break
            end
        end
        return @currentDeck
    end

    def PlayerMove()
        @firstCard = @cardsDeck.GetCard
        puts "You get first card: #{@firstCard}."
        @player.SetNewCard(@firstCard)
        puts "Your score is: #{@player.GetScore}."
        @secondCard = @cardsDeck.GetCard
        puts "You get second card: #{@secondCard}."
        if (@firstCard == @secondCard)
            choise = 'Y'
            while (choise != 'N')
                puts "First two cards are equals. Do you want split deck (Y / N)?"
                choise = gets.chop
                if (choise == 'Y')
                    if (@currentBet <= @player.GetMoney)
                        @isSplit = true
                        @splitBet = @currentBet
                        puts "You make new bet #{@splitBet}."
                        puts "Play with first deck."
                        @player.SetMoney(@player.GetMoney - @splitBet)
                        @split.SetNewCard(@secondCard)
                    else
                        puts "You dont have enough money for new bet."
                    end
                    break
                end
            end
        end
        if (!@isSplit)
            if (@secondCard == 11)
                if (@player.GetScore > 11)
                    puts "11 turns into 1."
                    @secondCard = 1
                end
            end
            @player.SetNewCard(@secondCard)
        end
        PlayWithDeck(@player, @currentBet, "Main Deck")

        if (@isSplit)
            PlayWithDeck(@split, @splitBet, "Split Deck")
        end
        puts 
    end

    def DealerMove()
        while (@dealer.GetScore < 17)
            card = @cardsDeck.GetCard
            puts "Dealer gets card #{card}."
            if (card == 11)
                if (@dealer.GetScore > 11)
                    puts "11 turns into 1."
                    card = 1
                end
            end
            @dealer.SetNewCard(card)
            puts "Dealer score is: #{@dealer.GetScore}."
            if (@dealer.GetScore > 21)
                @currentBet *= 2
                @splitBet *= 2
                puts "Dealer has more than 21."
                if (@player.GetScore <= 21)
                    puts "You win #{@currentBet}."
                    @player.SetMoney(@player.GetMoney + @currentBet)
                end
                if (@isSplit)
                    if (@split.GetScore <= 21)
                        puts "You win with second deck: #{@splitBet}"
                        @player.SetMoney(@player.GetMoney + @splitBet)
                    end
                end
                Update()
            end
        end
    end

    def Recap()
        CheckDeck(@player, @currentBet)
        if (@isSplit)
            puts "Recap for split deck "
            CheckDeck(@split, @splitBet)
            end
        end
    end

    def CheckDeck(deck, bet)
        if (deck.GetScore <= 21)
            if (@dealer.GetScore <= 21)
                if (deck.GetScore > @dealer.GetScore)
                    bet *= 2
                    puts "You have more than dealer. You win #{bet}."
                    @player.SetMoney(@player.GetMoney + bet)
                else
                    if (deck.GetScore < @dealer.GetScore)
                        puts "Defeat, your score less than dealer. You lose #{bet}."
                    else
                        if ((deck.GetScore == 21) && (deck.GetCardsNumber == 2) && (@dealer.GetCardsNumber != 2))
                            @bet *= 1.5
                            puts "Dealer has 21 but does not have BlackJack. You win #{bet}."
                        else
                            puts "Draw."
                        end
                        @player.SetMoney(@player.GetMoney + bet)
                    end
                end
            end
        end
    end

    def Update()
        Setup()
        puts "------New Shuffle------"
        if (@player.GetMoney == 0)
            puts "You lose all money!"
            abort "End game."
        end
        puts "You have : #{@player.GetMoney()}."

        puts "What is your bet?"
        while ((@currentBet == 0) || (@currentBet > @player.GetMoney) || (@currentBet < 0))
            @currentBet = gets.to_i
            if ((@currentBet == 0) || (@currentBet > @player.GetMoney) || (@currentBet < 0))
                puts "Make correct bet."
            end
        end
        puts "Your bet is #{@currentBet}."

        @player.SetMoney(@player.GetMoney - @currentBet)
        card = @cardsDeck.GetCard
        puts "Dealer gets first card #{card}."
        @dealer.SetNewCard(card)

        PlayerMove()

        DealerMove()

        Recap()

        Update()
    end

class CardsDeck
    def initialize()
        @cards = [2, 3, 4, 5, 6, 7, 8, 9, 10, 10, 10, 10, 11]
    end

    def GetCard()
        return @cards[rand(12)]
    end
end

class Player
    def initialize()
        @cardsNumber = 0
        @score = 0
        @money = 1000
    end

    def GetCardsNumber()
        return @cardsNumber
    end

    def GetScore()
        return @score
    end

    def GetMoney()
        return @money
    end

    def SetCardsNumber(value)
        @cardsNumber = value
    end
    
    def SetScore(value)
        @score = value
    end

    def SetNewCard(value)
        @score += value
        @cardsNumber += 1
    end

    def SetMoney(value)
        @money = value
    end
end

BEGIN {
    puts "BlackJack game was running"
}

game = Game.new
game.Start
