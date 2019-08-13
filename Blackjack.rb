#!/usr/bin/ruby

class Game
    def initialize()
        @cardsDeck = CardsDeck.new
        @player = Player.new
        @dealer  = Player.new
        @currentBid = 0
    end

    def Start()
        Update()
    end

    def Update()
        puts "------New Shuffle------"
        if (@player.GetMoney == 0)
            puts "You lose all money!"
            abort "End game"
        end
        @player.SetScore(0)
        @player.SetCardsNumber(0)
        @dealer .SetScore(0)
        @dealer .SetCardsNumber(0)
        puts "You have : #{@player.GetMoney()}"
        puts "What is your bid?"
        @currentBid = gets.to_i

        puts "Your bid is #{@currentBid}"
        if ((@currentBid == 0) || (@currentBid > @player.GetMoney))
            puts "Make correct bid"
            Update()
        end

        @player.SetMoney(@player.GetMoney - @currentBid)
        card = @cardsDeck.GetCard
        puts "Dealer gets first card #{card}"
        @dealer.SetNewCard(card)

        puts "Now your move"
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
            puts "You get the card: #{card}"
            if (card == 11)
                if (@player.GetScore > 11)
                    puts "11 turns into 1"
                    card = 1
                end
            end
            @player.SetNewCard(card)
            puts "Your score is: #{@player.GetScore}"
            if (@player.GetScore > 21)
                puts "Defeat, you have more than 21. You lose #{@currentBid}"
                Update()
            end
            if (@player.GetScore == 21)
                puts "You have 21. You are winner"
                if (@player.GetCardsNumber == 2)
                    @currentBid *= 1.5
                else
                    @currentBid *= 2
                end
                puts "You win #{@currentBid}"
                @player.SetMoney(@player.GetMoney + @currentBid)
                Update
            end
        end

        while (@dealer.GetScore < 17)
            card = @cardsDeck.GetCard
            puts "Dealer gets card #{card}"
            @dealer.SetNewCard(card)
            puts "Dealer score is: #{@dealer.GetScore}"
            if (@dealer.GetScore > 21)
                @currentBid *= 2
                puts "Dealer have more than 21. You win #{@currentBid}"
                @player.SetMoney(@player.GetMoney + @currentBid)
                Update()
            end
        end

        if (@player.GetScore > @dealer.GetScore)
            @currentBid *= 2
            puts "You have more thaт dealer. You win #{@currentBid}"
            @player.SetMoney(@player.GetMoney + @currentBid)
        else
            if (@player.GetScore < @dealer.GetScore)
                puts "Defeat, you less than dealer. You lose #{@currentBid}"
            else
                puts "Draw"
                @player.SetMoney(@player.GetMoney + @currentBid)
            end
        end
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

game = Game.new
game.Start
