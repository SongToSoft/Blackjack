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
    end

    def Start()
        Update()
    end

    def Setup()
        @player.SetScore(0)
        @player.SetCardsNumber(0)
        @dealer.SetScore(0)
        @dealer.SetCardsNumber(0)
        @isSplit = false
    end

    def PlayWithDeck()
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
                if (@player.GetScore > 11)
                    puts "11 turns into 1."
                    card = 1
                end
            end

            @player.SetNewCard(card)
            puts "Your score is: #{@player.GetScore}."
            if (@player.GetScore > 21)
                puts "Defeat, you have more than 21. You lose #{@currentBet}."
                if (!@isSplit)
                    Update()
                else
                    break
                end
            end

            if (@player.GetScore == 21)
                puts "You have 21!"
                if (@player.GetCardsNumber == 2) &&
                    ((@dealer.GetScore != 10) || (@dealer.GetScore != 11))
                    puts "You have BlackJack, and Dealer don't have BlackJack. You win 3 / 2 at your bet."
                    @currentBet *= 1.5
                    puts "You win #{@currentBet}."
                    @player.SetMoney(@player.GetMoney + @currentBet)
                    if (!isSplit)
                        Update()
                    else
                        break
                    end
                end
                break
            end

        end
    end

    #TODO: Make one method with passing value by reference
    def PlayWithSplitDeck()
        puts "Now your move with second Deck."
        puts "Your score is: #{@split.GetScore}."
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
                if (@split.GetScore > 11)
                    puts "11 turns into 1."
                    card = 1
                end
            end

            @split.SetNewCard(card)
            puts "Your score is: #{@split.GetScore}."
            if (@split.GetScore > 21)
                puts "Defeat, you have more than 21. You lose #{@splitBet}."
                break
            end

            if (@split.GetScore == 21)
                puts "You have 21!"
                if (@split.GetCardsNumber == 2) &&
                    ((@dealer.GetScore != 10) || (@dealer.GetScore != 11))
                    puts "You have BlackJack, and Dealer don't have BlackJack. You win 3 / 2 at your bet."
                    @splitBet *= 1.5
                    puts "You win #{@splitBet}."
                    @player.SetMoney(@player.GetMoney + @splitBet)
                    break
                end
                break
            end

        end
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
                    if (@currentBet <= (@player.GetMoney - @currentBet))
                        @isSplit = true
                        @splitBet = @currentBet
                        puts "You make new bet #{@splitBet}."
                        puts "Play with first deck."
                        @player.SetMoney(@player.GetMoney - @splitBet)
                        @split.SetNewCard(@secondCard)
                    else
                        puts "You dont have enouth money for new bet."
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
        puts "Your score is: #{@player.GetScore}."
        PlayWithDeck()

        if (@isSplit)
            puts "Play with second deck."
            PlayWithSplitDeck()
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
        if (@player.GetScore <= 21)
            if (@dealer.GetScore <= 21)
                if (@player.GetScore > @dealer.GetScore)
                    @currentBet *= 2
                    puts "You have more than dealer. You win #{@currentBet}."
                    @player.SetMoney(@player.GetMoney + @currentBet)
                else
                    if (@player.GetScore < @dealer.GetScore)
                        puts "Defeat, your score less than dealer. You lose #{@currentBet}"
                    else
                        if ((@player.GetScore == 21) && (@player.GetCardsNumber == 2) && (@dealer.GetCardsNumber != 2))
                            @currentBet *= 1.5
                            puts "Dealer has 21 but does not have BlackJack. You win #{@currentBet}."
                        else
                            puts "Draw"
                        end
                        @player.SetMoney(@player.GetMoney + @currentBet)
                    end
                end
            end
        end

        if (@isSplit)
            puts "Recap for split deck "
            if (@split.GetScore <= 21)
                if (@dealer.GetScore <= 21)
                    if (@split.GetScore > @dealer.GetScore)
                        @splitBet *= 2
                        puts "You have more thaт dealer. You win #{@splitBet}."
                        @player.SetMoney(@player.GetMoney + @splitBet)
                    else
                        if (@split.GetScore < @dealer.GetScore)
                            puts "Defeat, your score less than dealer. You lose #{@splitBet}"
                        else
                            if ((@split.GetScore == 21) && (@split.GetCardsNumber == 2) && (@dealer.GetCardsNumber != 2))
                                @splitBet *= 1.5
                                puts "Dealer has 21 but does not have BlackJack. You win #{@splitBet}."
                            else
                                puts "Draw"
                            end
                            @player.SetMoney(@player.GetMoney + @splitBet)
                        end
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

        puts "What is your bid?"
        @currentBet = 0
        while ((@currentBet == 0) || (@currentBet > @player.GetMoney))
            @currentBet = gets.to_i
            if ((@currentBet == 0) || (@currentBet > @player.GetMoney))
                puts "Make correct bid."
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
