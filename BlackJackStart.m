clc, clear, close

%Initialize scene
card_scene1 = simpleGameEngine('retro_cards.png',16,16,5,[0,130,0]);

%Title card, asks the player if they would like to play or not. Credits
%given to group P.
drawScene(card_scene1,[1,1,1;1,1,1;1,1,1])
title1 = text(12,42,'Blackjack','Color','Black','FontSize',30,'FontName','Poor Richard','FontWeight','bold');
proceed1 = text(12,80,'Press esc to quit.','Color','Black','FontSize',15,'FontName','Poor Richard');
proceed2 = text(12,110,'Press space to proceed.','Color','Black','FontSize',15,'FontName','Poor Richard');
credits = text(12,140,'Game made by ENGR 1181: Group P','Color','Black','FontSize',10,'FontName','Poor Richard');

%Gets input whether they would like to play or not.
playOrNot = getKeyboardInput(card_scene1);

%Loops until space/escape is chosen.
while ~isequal(playOrNot,'space') && ~isequal(playOrNot,'escape')
    xlabel('Invalid input, try again.')
    playOrNot = getKeyboardInput(card_scene1);
end

%Closes the game when escape is chosen, thus, closing the rest of the code.
if isequal(playOrNot,'escape')
    close
end

%Prints the rules of Blackjack in the command window.
if isequal(playOrNot,'space')
    fprintf('The rules of Blackjack! (Singleplayer)\n1. To win, the player must have a score higher than the dealer''s!\n2. If the score is greater than 21, they lose.\n3. The number on a card is worth that number. Face cards are worth 10. Aces are worth 1 or 11.\n4. You can either stand or hit, meaning you can either get no more cards or get a new one.')
end

%When spcae is chosen, it will simply proceed with the rest of the code.
while isequal(playOrNot,'space')
%Declare variables for common sprites and initial variables.
emptySprite = 1;
blankCardSprite = 2;
cardSprites = 21:72;
blankRow = [1,1,1,1];
total = 0;
blankDealerRow = 1;

%Blank cards, acts as a bottom layer for the white card background
blankCards = blankCardSprite * [1,1];

%Randomly shuffles the numbers 1-52, shuffling a "deck." The starting hand is the
%first two cards on the deck. The card values correspond it's card #. 
shuffledDeck = randperm(52);
hand = shuffledDeck([2,4]);
dealerHand = shuffledDeck([1,3]);
cardValues = [11, 2:10, 10, 10, 10, 11, 2:10, 10, 10, 10, 11, 2:10, 10, 10, 10, 11, 2:10, 10, 10, 10];

%Second layer that has the faces of the cards, skips the first 20 sprites
%which aren't cards. The card value is the faceDisplay - 20, indicating the
%value of the card itself.
faceDisplay = cardSprites(hand);
dealerDisplay = cardSprites(dealerHand);
playerCard = cardValues(faceDisplay - 20);
dealerCard = cardValues(dealerDisplay - 20);
dealerTotal = getScore(dealerCard);

%Shows the cards
drawScene(card_scene1,blankCards,faceDisplay) %Shows the two cards that were drawn.
xlabel('Player is looking at 2 cards. Press spacebar.')

%Asks for input (spacebar)
hit = getKeyboardInput(card_scene1);

%Loops until the player presses spacebar to proceed.
while ~isequal(hit,'space')
    drawScene(card_scene1,2,3) %Shows the top of the deck
    xlabel('Invalid input. Press spacebar.')
    hit = getKeyboardInput(card_scene1);
    
end


%When the input is 'space', it asks for another input for another card.
if isequal(hit,'space')
    drawScene(card_scene1,[1,2,2,1; blankRow; 1,2,2,1],[1,dealerDisplay(1),3,1; blankRow; 1, faceDisplay,1])
    
    %Adds up the playerCard vector to produce the player's current score.
    total = getScore(playerCard);

    if total == 21
        xlabel('You got Blackjack!')
        option = 'n';
        
    else
    xlabel({['Your sum is, ',num2str(total)],'Would you like another card? Press Y/N.',})
    end
end


%If the total is not 21, the rest of the code will continue. This is
%because the player did not get a Blackjack. (The first two cards dealt
%must be equal to 21, for it to be a Blackjack)
if total ~= 21
option = getKeyboardInput(card_scene1);
end

%Loops until a valid input is chosen.
while ~isequal(option,'y') && ~isequal(option,'n')
    drawScene(card_scene1,[2,2,1,2],[faceDisplay, 1, 3]);
    xlabel({['Your sum is, ',num2str(total)],'Invalid input, press Y/N'})
    option = getKeyboardInput(card_scene1);
end

%Creates an index, looping until another card isn't wanted. 
newCardIndex = 4; %Starts at 4, because of the 4 cards already drawn: 2 for the dealer and 2 for the player.
while isequal(option,'y')
    newCardIndex = newCardIndex + 1;
    blankCards = blankCardSprite .* ones(1,(newCardIndex-2));
    blankRow = ones(1,(newCardIndex));
    blankDealerRow = ones(1,(newCardIndex-3));
    newCard = shuffledDeck(newCardIndex);
    newCardDisplay = cardSprites(newCard); 
    drawScene(card_scene1,[1,2,2,blankDealerRow;blankRow;1,blankCards,1],[1,dealerDisplay(1),3,blankDealerRow;blankRow;1, faceDisplay, newCardDisplay,1]); %Shows the previously cards drawn, and the new card
    faceDisplay = [faceDisplay, newCardDisplay];
    playerCard = cardValues(faceDisplay - 20); %Redefines playerCard to correspond with the changing vector.

    total = getScore(playerCard);

    %If the sum is less than 21, it will continue to ask if the player
    %would like another card.
    if total < 21
    xlabel({['Your score is, ' num2str(total)],'Would you like another card? Press Y/N.'})
    option = getKeyboardInput(card_scene1);
    end

    %If neither the 'y' or 'n' options have been chosen, it will loop until
    %either one has been chosen.
    while ~isequal(option,'y') && ~isequal(option,'n')
        drawScene(card_scene1, [1,2,2,blankDealerRow;blankRow;1,blankCards,1],[1,dealerDisplay(1),3,blankDealerRow; blankRow; 1, faceDisplay,1])
        xlabel('Invalid input, press Y/N.')
        option = getKeyboardInput(card_scene1); 
    end
 

    %If the sum is over or equal 21, the option to get another card will not be
    %available.
    if total >= 21
        option = 'n';
    end 

end

%If the total sum of the cards is over 21, it will prompt a losing message.
if total > 21
    drawScene(card_scene1,blankCards,faceDisplay) %Reshows the two cards previously drawn.
    xlabel({['Your total is, ', num2str(total)],'Sorry, you got over 21! You busted!'});
    result = 0;
end

%If the total sum of the cards is less than 21, it will show the player's
%cards and proceed to show the dealer's cards.
if total <= 21
%When no new card is wanted, the player's cards will be shown.
if isequal(option,'n')
    drawScene(card_scene1, [1,2,2,blankDealerRow;blankRow;1,blankCards,1],[1,dealerDisplay(1),3,blankDealerRow; blankRow; 1, faceDisplay,1]) %Reshows the cards previously drawn.
    xlabel({['Your sum is, ', num2str(total)],'Press space to continue.'});
    resume = getKeyboardInput(card_scene1);
end


%When space is not hit, it will prompt the user to hit the spacebar.
while resume ~= 'space'
    drawScene(card_scene1,2,3)
    xlabel('Invalid input, hit spacebar.')
    resume = getKeyboardInput(card_scene1);
end

if isequal(resume,'space')
    drawScene(card_scene1, [1,2,2,blankDealerRow;blankRow;1,blankCards,1],[1,dealerDisplay,blankDealerRow; blankRow; 1, faceDisplay,1]) %Reshows the cards previously drawn.
    dealerTotal = getScore(dealerCard);
    xlabel(['The dealer''s score is, ' num2str(dealerTotal)])
    pause(1.5)
end

%dealerCardIndex assumes the last position of the cards from the deck.
dealerCardIndex = newCardIndex;
dealerBlanks = 2;

%Loops until the dealer's score is higher than 17. It breaks when the
%dealer's total is greater than or equal to the player's.
while dealerTotal < 17
    if dealerTotal >= total && dealerTotal > 17
        break
    end

    dealerCardIndex = dealerCardIndex + 1;
    dealerBlanks = dealerBlanks + 1;
    blankDealerCards = 2 .* ones(1,dealerBlanks);
    newDealerCard = shuffledDeck(dealerCardIndex);
    newDealerCardDisplay = cardSprites(newDealerCard);
    dealerDisplay = [dealerDisplay, newDealerCardDisplay];
    dealerCard = cardValues(dealerDisplay - 20);
    drawScene(card_scene1, [1,blankDealerCards,1], [1, dealerDisplay,1])

    dealerTotal = getScore(dealerCard);
    xlabel(['The dealer''s score is, ', num2str(dealerTotal)]);
    title('Dealer''s cards')
    pause(1.5)

end

%Compares the scores of the dealer and the player. 0 means a loss, 1 means
%a win, and 2 means a tie.
if dealerTotal < total || dealerTotal > 21
    result = 1;
elseif dealerTotal > total && dealerTotal <= 21
    result = 0;
elseif dealerTotal == total
    result = 2;
end

end

%If results are accordingly, will draw a new scene. It will display the
%player's and the dealer's totals and prompt a win/lose/draw message. Asks
%if the player would like to play again. 
if result == 1
    drawScene(card_scene1, [1,1,1,1,1; 1,1,2,1,1;1,1,1,1,1], [1,1,1,1,1; 1, 1, 3, 1, 1; 1,1,1,1,1])
    xlabel({['Dealer''s total: ', num2str(dealerTotal), ' v.s. Player''s total: ', num2str(total)],'You win!'})
    title('Press space to play again. Press escape to quit.')
    playOrNot = getKeyboardInput(card_scene1);
elseif result == 0
    drawScene(card_scene1, [1,1,1,1,1; 1,1,2,1,1;1,1,1,1,1], [1,1,1,1,1; 1, 1, 3, 1, 1; 1,1,1,1,1])
    xlabel({['Dealer''s total: ', num2str(dealerTotal), ' v.s. Player''s total: ', num2str(total)],'You lose!'})
    title('Press space to play again. Press escape to quit.')
    playOrNot = getKeyboardInput(card_scene1);
elseif result == 2
    drawScene(card_scene1, [1,1,1,1,1; 1,1,2,1,1;1,1,1,1,1], [1,1,1,1,1; 1, 1, 3, 1, 1; 1,1,1,1,1])
    xlabel({['Dealer''s total: ', num2str(dealerTotal), ' v.s. Player''s total: ', num2str(total)],'It''s a tie!'})
    title('Press space to play again. Press escape to quit.')
    playOrNot = getKeyboardInput(card_scene1);
end

%If the player doesn't click on either space or escape, an invalid input
%message will loop until the player does choose to play or not.
while ~isequal(playOrNot,'space') && ~isequal(playOrNot,'escape')
    title('Invalid input. Press space to play again. Press escape to quit.')
    playOrNot = getKeyboardInput(card_scene1);
end

%When escape is chosen, will close the game.
if isequal(playOrNot,'escape')
    close
end

end

%User-function that gets the total of the player's cards. If the total of
%the cards is greater than 21, it will go through each card and if it is
%an Ace, which has a value of 11, it will change that value to 1.
function total = getScore(x)
total = sum(x);
    for idx = 1:length(x)
        if total > 21
            if x(idx) == 11
                x(idx) = 1;
                total = sum(x);
            end
        end
    end
    total = sum(x);
end



