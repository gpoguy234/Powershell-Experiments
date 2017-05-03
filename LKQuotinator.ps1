$LKquotes = @("And you green-lit that tomfuckery?", 
                "Agricultural Halls are for agricultural music! Not for fuckin' raves! ", 
                "Why donts yous guys wears belts? Because we buy pants that fucking fit. ", 
                "That is a Hard no.", 
                "That is a Texas sized 10 4 there super chief",
                "Does a duck with a boner drag weeds?",
                "Is a duck's ass water tight?",
                "I'm just going to pump the brakes on that one",
                "Oh I'm stomping the brakes, put that idea through the fucking windshield!",
                "Different strokes for different folks. But watch space balls, big shootsy wootsy. Unless it was star wars you haven't seen, in which case watch all the star wars", 
                "Nice work schmeltz!", 
                "This right here, is the perfect stump for a stump hump", 
                "Pitter patter, let's get at her.",
                "How are ya now? ", 
                "It's complicated, like algebra: Why you gotta put numbers and letters together? Why can't you just go fuck yourself?",
                "Thirsty Thursdays boys, might as well get balls deep in a bottle of Gussenbrew tonight",
                "It's a four leaf clover! Make a wish! I wish you weren't so fuckin' awkward, bud",
                "Either way, I's impressed, and I let out an audible gasp, so he hears me, spins around, aims the TAYZER up at me and lets fire and if that thing doesn't latch on to my nipple ring, which I'm pretty sure amplified the electric current he sent coursing through my entire body. Then they just walked over and yanked that thing out of my nipple like it was a god damn fish hook. At least that's according to my cousin. Well, ya know, my second cousin. ", 
                "Nice onesie! Does it come in men's? Oh, I think you come in men enough for all of us. ",
                "Tarps off Boys!",
                "Do you know what dick dingers are? No. It's when they snort drugs off each other's erect penises"
                "Tinder? Did you know that was originally called Grinder, and it was made for gay men to sodomize each other?"
                "So, as the story goes: Dwayne hucks an egg at a truck with a Confederate Flag in the back windshield and the driver's fuming pissed. So we flee the scene go full tilt like a Peterbilt, right? Well the feder alleys catch up to us and chase us through a few backyards before we scamper up into some trees. And all Wayne's got on is a pair of cut off jean-shorts, so he ain't exactly super jazzed about the situation, was you Wayne? "
                "Put some fucking clothes on! Not my forte. Unfortunate! ",
                "Dirty fuckin' dangles boys!",
                "We studied the tapes and got in shape",
                "Whats the matter?  Did you check the skeddee there schmeltz",
                "Let's have a donnybrook!",
                "Except kids falling off bikes, fuck i could watch kids fall of bikes all day, i don't give a shit about your kids",
                "He was talking to this girl with such a butt on her. It's like, girl, you shit with that thing?",
                "What's the nature of that, David Suzuki?",
                "One time my cousin, he tore open his ballsack tryin' to do a skateboard trick, and he had to show it to his mum.",
                "You can kiss my aesthetician",
                "You're made of spare parts aren't you, bud?",
                "Just call me cake, cause I'm going straight to your ass.",
                "Pump the brakes; you take your shirt off but leave your sunglasses on?",
                "What sort of backwards fucking padgentry is that?",
                "You going to fight with those shades or play pokerstars dot com?",
                "I haven't seen this sort of fuckin' bedlam since we fired candles at coyotes that night and caught one right in the butthole fuck, ran out the back porch and dropped seven shades of shit in dad's workboots",
                "That's the best ass-wash of your life right there boys. Good work Shoresy! Look at the hustle on Shoresy! Best ass-wash of your life.",
                "Your friend says his sled has so much torque he can't keep the front end down. K bud. You want to blow smoke. Go have a dart."
)
while(1-eq 1){
#$speak = ($LKquotes | Get-Random)
$LKlength = ($LKQuotes.Length) -1
[int]$pick = Read-host "Enter a number from 0 to ($LKlength) - or 999 to quit"
    if(($pick -lt $LKLength+1) -and ($pick -gt -1)){
        $speak = ($LKquotes[$pick]);
        write-host "selected $pick"
        }
    elseif($pick -eq 999){
        break
        }
    else{
        $speak = ($LKquotes | Get-Random)
        Write-Host "selection out of bounds - picking random quote"
        #break
        }

Add-Type -AssemblyName System.Speech 
$synth = New-Object -TypeName System.Speech.Synthesis.SpeechSynthesizer

#now we use our variable to finally hear something:
$synth.Speak($speak)
}