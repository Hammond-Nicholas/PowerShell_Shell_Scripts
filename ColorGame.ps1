<#
Program Name : color.ps1
Date: 10-5-2021
Author: Nick Hammond
Corse: CIT361
I, Nick Hammond, affirm that I wrote this script as original work completed by me.
#> 

# Define Variables
$AllColors=[System.Enum]::getvalues([System.ConsoleColor]) 
$RandomColor
$UserGuess
$Time
$StartMenu = 0
$RoundMenu = 0
$PlayAgainMenu = 0
$PreviousGuesses = [System.Collections.ArrayList]@()
$IntroMessage = @"

=============================
  - Color  Guessing  Game -
   Can you guess the color?
=============================
"@
$StartMessage = @"

=============================
       Ready to play?
=============================
1. Yes!
2. Quit
>
"@
$RoundMessage = @"

Pick an option:
1. Guess a color
2. Color list
3. Hint
4. Previous guesses
5. Quit
>
"@
$PlayAgainMessage = @"

Would you like to play again?
1. Yes
2. No
>
"@

# Start Game Function
Function StartGame {
    Write-Host $IntroMessage

    while ($StartMenu -eq 0) {
        $StartMenu = Read-Host $StartMessage
        switch -Wildcard ($StartMenu){
            {$_ -eq '1' -or $_ -like 'y*'} {$StartMenu = PlayGame}
            {$_ -eq '2' -or $_ -like 'q*'} {$startMenu = 1}
            default {"`nPlease enter Yes or Quit`n"}
        }
    }

    Write-Host "`nThanks for playing!`n"
}

# Play Game Function
Function PlayGame {
    # Set random color 0-15
    $RandomColor = [System.ConsoleColor](0..15 | Get-Random)

    # Start Clock
    $Time = (Get-Date)

    # Clear previus guesses list
    $PreviousGuesses.Clear()

    while ($RoundMenu -eq 0) {
        $RoundMenu = Read-Host $RoundMessage
        switch -Wildcard ($RoundMenu){
            {$_ -eq '1' -or $_ -like 'g*'} {$RoundMenu = GuessingRound}
            {$_ -eq '2' -or $_ -like 'c*'} {ColorList; $RoundMenu = 0}
            {$_ -eq '3' -or $_ -like 'h*'} {Hint; $RoundMenu = 0}
            {$_ -eq '4' -or $_ -like 'p*'} {Previous; $RoundMenu = 0}
            {$_ -eq '5' -or $_ -like 'q*'} {$RoundMenu = 1}
            default {"`n$RoundMenu is not a valid option.  Try again.`n"}
        }
    }

    # Reset Function variable and exit, returning 1 for quit
    if ($RoundMenu -eq 1) {
        $RoundMenu = 0
        Return 1
    } else {
        $RoundMenu = 0
        Return 0
    }
}

# Round Function
Function GuessingRound {
    $UserGuess = Read-Host "`nEnter your guess`n"

    # check if theres a match. 
    if ($RandomColor -eq $UserGuess) {
        $time = ((get-date) - $time)

        Write-Host "`nYes! $UserGuess is the correct color!`n"
        Write-Host "It took you"$time.minutes"min,"$time.seconds"seconds and"($PreviousGuesses.count +1)"tries."
        Return PlayAgain
    } 

    # check is guess is a valid color
    foreach ($i in $AllColors) {
        if ($i -eq $UserGuess) {
            [void]$PreviousGuesses.add($UserGuess)
            Write-Host "`nSorry, $UserGuess is not the right color.`n"
            Return 0
        }
    }

    [void]$PreviousGuesses.add($UserGuess)
    Write-Host "`n$UserGuess is not a valid color.  Pick again.`n"
    Return 0

}

# Play again? Function return 1 no, 2 yes
Function PlayAgain {
    while ($PlayAgainMenu -eq 0) {
        $PlayAgainMenu = Read-Host $PlayAgainMessage
        switch -Wildcard ($PlayAgainMenu){
            {$_ -eq '1' -or $_ -like 'y*'} {$PlayAgainMenu = 0; Return 2}
            {$_ -eq '2' -or $_ -like 'n*'} {$PlayAgainMenu = 0; Return 1}
            default {"`n$PlayAgainMenu is not a valid option.  Try again.`n"}
        }
    }
}

# Hint Function
Function Hint {
    # If color starts with dark, display first 5 characters, else display just first single
    if ($RandomColor -like 'dark*') {
        Write-Host "`nThe color starts with " ([string]$RandomColor).Substring(0,5) "`n"
    } else {
        Write-Host "`nThe color starts with " ([string]$RandomColor).Substring(0,1) "`n"
    }
}

# Color List Function
Function ColorList {
    Write-Host "`n" $AllColors
}

# Previous Guesses Function
Function Previous {
    Write-Host "`n" $PreviousGuesses 
}

#Start The Game
StartGame
