-- project: talkative bots
-- v1.3 by Chalwk

-- Variables that can be used in general chatter:
-- %bot%, %random_player_name%

-- Variables that can be used in death messages:
-- %bot%, %killer%, %victim%, %v_kills%, %k_kills%

local ChatBot = {

    -- A message relay function temporarily removes the "msg_prefix"
    -- and will restore it to this when the relay is finished:
    server_prefix = "**SAPP**",
    --

    ["M0n3y16'$"] = {
        ip = "127.0.0.1",
        general_chatter = {
            duration = { 60, 300 },
            messages = {
                "%bot%: I like shorts! They're comfy and easy to wear!",
                "%bot%: Hello, %random_player_name%",
                "%bot%: I'm hungry. brb",
                "%bot%: oh fuck this shit",
                "%bot%: Is that a gun in your pocket, or are you just pleased to see me?",
                "%bot%: I hate the fact that you will never accept me for who I am.",
                "%bot%: Why do men like bathing suits so much?",
                "%bot%: They said that if it weren't for this ferris wheel, I wouldn't exist.",
                "%bot%: You need to stop, %random_player_name%!",
                "%bot%: These are dark times indeed.",
                "%bot%: Why do you linger?",
            }
        },
        death_messages = {
            chance = 80,
            messages = {
                "%bot%: Nice kill bro",
                "%bot%: you suck %victim%",
                "%bot%: Whoops.",
                "%bot%: That wasn't supposed to happen",
                "%bot%: My bad.",
                "%bot%: %killer% approves this victory message.",
                "%bot%: %killer% can flex.",
                "%bot%: %killer% caught a shiny Pokémon",
            }
        }
    },
    ["D0uBleKiLl "] = {
        ip = "127.0.0.1",
        general_chatter = {
            duration = { 60, 300 },
            messages = {
                "%bot%: Son of a submariner!",
                "%bot%: im gonna leave",
                "%bot%: It's a ME, your uncle Mario.",
                "%bot%: What? Lead? Me? No, no, no. No leading",
                "%bot%: Unlock God Mode for $49.99.",
                "%bot%: Vibe check.",
                "%bot%: Oops.",
                "%bot%: That was a mistake %random_player_name%",
                "%bot%: Kneecaps!",
                "%bot%: Oh, you're disgusting %random_player_name%",
                "%bot%: The air is tasty here.",
            }
        },
        death_messages = {
            chance = 40,
            messages = {
                "%bot%: what is this bullshittery?",
                "%bot%: Get one shotted lol",
                "%bot%: Git gud %victim%",
                "%bot%: Please try again later.",
                "%bot%: Skill issue?",
                "%bot%: I guess I forgot to remove that.",
                "%bot%: Good game.",
                "%bot%: Simon says... rejoin!",
                "%bot%: Got you!",
                "%bot%: %killer% collected the infinity stones",
                "%bot%: %killer% completed the obby",
                "%bot%: %killer% deserved the win!",
            }
        }
    },
    ["TriPleKi11"] = {
        ip = "127.0.0.1",
        general_chatter = {
            duration = { 60, 300 },
            messages = {
                "%bot%: Oh, Please,PLEASE TELL ME YOU got me some coffe mugs!",
                "%bot%: You should get Chimera %random_player_name%",
                "%bot%: It’s time to kick ass and chew bubble gum... and I’m all outta gum.",
                "%bot%: sabes cuanto me costo llegar",
                "%bot%: I need new underwear",
                "%bot%: i had an amiga computer once",
                "%bot%: I SWALLOW SLUDGE TO TRANSFORM MYSELF",
                "%bot%: I'm a cool guy, I have a girlfriend!",
            }
        },
        death_messages = {
            chance = 70,
            messages = {
                "%bot%: this is some salmon ass reg",
                "%bot%: i suck today",
                "%bot%: You look dumb now, don't you?",
                "%bot%: Dev needs to fix this",
                "%bot%: GG ez",
                "%bot%: I'm honestly running out of ideas.",
                "%bot%: What do I put here again?",
                "%bot%: Sample text here",
                "%bot%: %killer% didn't even try.",
                "%bot%: %killer% ended someone's whole career",
                "%bot%: %killer% got an ez dub.",
            }
        }
    },
    ["KiLLtAcUlaR"] = {
        ip = "127.0.0.1",
        general_chatter = {
            duration = { 60, 300 },
            messages = {
                "%bot%: STOP RIGHT THERE CRIMINAL SCUM!!!!!",
                "%bot%: so hostile %random_player_name%",
                "%bot%: that is a man? A Miserable little pile of secrets!",
                "%bot%: that buttplug is trying to kill me",
                "%bot%: drinking coffee. who wants some?",
                "%bot%: Are you feeling the itch to kill %random_player_name%?",
                "%bot%: MY TOES ARE FROZEN",
                "%bot%: Dropped my balls!",
            }
        },
        death_messages = {
            chance = 35,
            messages = {
                "%bot%: That's all?",
                "%bot%: Time to repeat the process.",
                "%bot%: Here we go again...",
                "%bot%: Try not to do that again next time.",
                "%bot%: Looking for something?",
                "%bot%: You're back!",
                "%bot%: Sorry.",
                "%bot%: You died.",
                "%bot%: %killer% got some free pizza!",
                "%bot%: %killer% got the epic victory royale!!!",
            }
        }
    },
    ["TRyHaRd"] = {
        ip = "127.0.0.1",
        general_chatter = {
            duration = { 60, 300 },
            messages = {
                "%bot%: whats ur frame rate set at %random_player_name%?",
                "%bot%: the fuck is that",
                "%bot%: Oh my god dude!",
                "%bot%: You were almost a Jill sandwich!",
                "%bot%: Man... Cool just can't be taught...",
                "%bot%: How can I get you to understand my hobby? Which is... talking in a deep voice!",
                "%bot%: Ahahaha! It's itching! It's itching!",
            }
        },
        death_messages = {
            chance = 75,
            messages = {
                "%bot%: eww laggg",
                "%bot%: Clearly, something happened that lead to your death.",
                "%bot%: Are you okay?",
                "%bot%: You'll recover. Someday.",
                "%bot%: This is the part where you yell at your screen.",
                "%bot%: You'd still be alive if it weren't for [INSERT TEXT HERE]",
                "%bot%: FYI, you didn't have to die.",
                "%bot%: bad",
                "%bot%: noob",
                "%bot%: Next time.",
                "%bot%: suck my nutsack",
            }
        }
    },
    ["RAGEQUIT"] = {
        ip = "127.0.0.1",
        general_chatter = {
            duration = { 60, 300 },
            messages = {
                "%bot%: IDK WHY IT DOESNT LET ME RUN 1080",
                "%bot%: the cake is a lie %random_player_name%",
                "%bot%: FINISH HIM!",
                "%bot%: Would you kindly...",
                "%bot%: You're here for me, aren't you?",
                "%bot%: I feel safe when you're around!",
                "%bot%: Watch this! Urggh! Oooarrgh!",
                "%bot%: Eek! Don't try anything funny in the dark!",
            }
        },
        death_messages = {
            chance = 15,
            messages = {
                "%bot%: This is some bullshit",
                "%bot%: Why did you do that?",
                "%bot%: Bro...",
                "%bot%: Seriously?",
                "%bot%: Well...",
                "%bot%: Yikes.",
                "%bot%: Looks like somebody isn't getting their Winner Winner Chicken Dinner.",
                "%bot%: Alright, what happened now?",
                "%bot%: Get up on your feet.",
                "%bot%: %killer% had gfuel in their system.",
                "%bot%: %killer% has ultra instinct.",
            }
        }
    },
    ["Fr3nZy"] = {
        ip = "127.0.0.1",
        general_chatter = {
            duration = { 60, 300 },
            messages = {
                "%bot%: Someone's doin' stuff they shouldn't, %random_player_name%",
                "%bot%: The nosk",
                "%bot%: *shrugs*",
                "%bot%: It's alive!",
                "%bot%: War... war never changes",
                "%bot%: I had some trouble pwning n00bs here last week",
                "%bot%: Come up and sushi me sometime %random_player_name%",
                "%bot%: I like shooting...",
                "%bot%: Y' know... My Emolga really wants to shock your Dedenne.",
            }
        },
        death_messages = {
            chance = 55,
            messages = {
                "%bot%: You disappoint me, %victim%.",
                "%bot%: This is embarrassing.",
                "%bot%: Try not to ragequit.",
                "%bot%: Lol",
                "%bot%: Hahaha",
                "%bot%: Sigh... do you want me to turn on Baby Mode?",
                "%bot%: 'Tis but a wound.",
                "%bot%: %killer%: hold my bloxy cola.",
            }
        }
    },
    ["RaMp4ge"] = {
        ip = "127.0.0.1",
        general_chatter = {
            duration = { 60, 300 },
            messages = {
                "%bot%: Why don't you act your age, what are you 46?! 48?!",
                "%bot%: %random_player_name% is a virgin for sure",
                "%bot%: Cant Kill Me",
                "%bot%: i play unreal tournament, join me!",
                "%bot%: You guys are good",
                "%bot%: idk why but you are funny",
                "%bot%: Shhhh... Don't tell anyone, just take it",
                "%bot%: Hey you're not wearing shorts, what's wrong with you?",
                "%bot%: Oh, no. I dropped the LIFT KEY!",
            }
        },
        death_messages = {
            chance = 25,
            messages = {
                "%bot%: Sell your PC. Just do it.",
                "%bot%: That didn't work out.",
                "%bot%: Learn from your mistakes.",
                "%bot%: Mission failed. We'll get 'em next time.",
                "%bot%: Spartans never die. They just go M.I.A.",
                "%bot%: Ouch.",
                "%bot%: From zero to hero and then back to zero.",
                "%bot%: How... unfortunate.",
                "%bot%: I am inevitable.",
                "%bot%: Cut!",
                "%bot%: %killer% is #1",
                "%bot%: %killer% is a level 100 mafia boss",
                "%bot%: %killer% is a pro",
            }
        }
    },
    ["OvErKiLL"] = {
        ip = "127.0.0.1",
        general_chatter = {
            duration = { 60, 300 },
            messages = {
                "%bot%: Hey, come quick, I think I just found a dead body",
                "%bot%: i love this server",
                "%bot%: ONLY A COMPLETE RETARD WOULD HIDE IN THERE",
                "%bot%: Great Scott, %random_player_name%!",
                "%bot%: It's your kids, Marty!",
                "%bot%: Who's Vice President, Jerry Lewis?",
                "%bot%: I should have brought my Game Boy Advance so I wouldn't get bored",
                "%bot%: AAAH! I am sooo scared! I will never do it again... Sorry!",
            }
        },
        death_messages = {
            chance = 35,
            messages = {
                "%bot%: fill me in!",
                "%bot%: That's... bad...",
                "%bot%: Task failed successfully.",
                "%bot%: K.O.!",
                "%bot%: %killer% played well.",
                "%bot%: %killer% survived!",
            }
        }
    },
    ["Killi0n4re"] = {
        ip = "127.0.0.1",
        general_chatter = {
            duration = { 60, 300 },
            messages = {
                "%bot%: OMG!!!.. I CAN'T... I CAN'T DEAL WITH THIS, I HAVE MY PILATES CLASS!!",
                "%bot%: penis pumper %random_player_name% is",
                "%bot%: lip smacking",
                "%bot%: someone joined",
                "%bot%: Who's server is this?",
                "%bot%: Im from the US OF Netherlands hear me ROAR!",
                "%bot%: WRONG server asshole!",
                "%bot%: Ah! I sense it! I sense your hypersensitive sensitivity!",
                "%bot%: Lalalala... Lalalala... I am a loner...",
            }
        },
        death_messages = {
            chance = 45,
            messages = {
                "%bot%: You have perished. What a Shame.",
                "%bot%: Wipeout!",
                "%bot%: FATALITY",
                "%bot%: Oof",
                "%bot%: %killer% thought that was easy.",
                "%bot%: %killer% used their reverse uno card.",
                "%bot%: %killer% went home with a trophy!",
            }
        }
    },
    ["Kill7r0cItY"] = {
        ip = "127.0.0.1",
        general_chatter = {
            duration = { 60, 300 },
            messages = {
                "%bot%: SANTA'S NOT REAL. IT'S ALL COMMERCIALISM",
                "%bot%: its us again %random_player_name%",
                "%bot%: You like cock amirite?",
                "%bot%: Gaze upon mine and weep you pilgrim",
                "%bot%: thatsa a good ping",
                "%bot%: It takes a strong man to deny what's in front of him.",
                "%bot%: No...wait... Don't run away... You're supposed to be my Butler...",
                "%bot%: No one but my master will ever make me bow!",
            }
        },
        death_messages = {
            chance = 65,
            messages = {
                "%bot%: You must be new at this...",
                "%bot%: Dun dun dun... them %k_kills% kills though!",
                "%bot%: Why?",
                "%bot%: Stop. Doing. That.",
                "%bot%: -15 respect",
                "%bot%: H2OMG",
                "%bot%: %killer% wins a golden toilet as their prize!",
                "%bot%: %killer% wins!",
                "%bot%: %killer% won the lottery!",
            }
        }
    },
    ["H34dSh0t"] = {
        ip = "127.0.0.1",
        general_chatter = {
            duration = { 60, 300 },
            messages = {
                "%bot%: Jesus is the coolest!",
                "%bot%: hold on im disabling the devcam",
                "%bot%: Uuuuuuuh, I heard something crack!",
                "%bot%: Look how the turn tables %random_player_name%",
                "%bot%: I guess that's it for today.",
                "%bot%: See you later.",
                "%bot%: I like instant needles",
                "%bot%: What do you think of my Pokémon? They're fresh!",
                "%bot%: I wish I could live in the worlds that I see in games, anime, and comics.",
                "%bot%: They say with age comes wisdom, but that never seems to have worked for me.",
            }
        },
        death_messages = {
            chance = 20,
            messages = {
                "%bot%: Nope. Just Nope.",
                "%bot%: Ouch! That's gratitude for you!",
                "%bot%: That must've hurt.",
                "%bot%: What an ePiC fAiL",
                "%bot%: Return by death.",
                "%bot%: What The Acid",
            }
        }
    },
    ["$napTr0pic"] = {
        ip = "127.0.0.1",
        general_chatter = {
            duration = { 60, 300 },
            messages = {
                "%bot%: Jesus rocks!",
                "%bot%: /login hawaii5oh",
                "%bot%: /login %random_player_name%",
                "%bot%: aimbot enabled",
                "%bot%: Suprised Adio isn't here",
                "%bot%: this map is the dumbest shit ever",
                "%bot%: Fooooo!",
                "%bot%: Gaaahhh, that bugs the snot out of me!",
                "%bot%: I was born to do battle, ya hear?! I'm a darn tootin' Trainer! I am!",
                "%bot%: Ha? He ohay heh ha hoo ee haheh!",
            }
        },
        death_messages = {
            chance = 75,
            messages = {
                "%bot%: Couldn't charm your way out of that one, %victim%.",
                "%bot%: %killer% has hives",
                "%bot%: Were you expecting something?",
                "%bot%: What did you expect?",
                "%bot%: You died.",
                "%bot%: WASTED",
                "%bot%: Haven't you forget something?",
                "%bot%: Mind yourself, %random_player_name%!",
                "%bot%: Not very intelligent, are you?",
                "%bot%: Run away pest!",
            }
        }
    },
    ["P3rFeCtI0n"] = {
        ip = "127.0.0.1",
        general_chatter = {
            duration = { 60, 300 },
            messages = {
                "%bot%: Uhh...Need help with that?",
                "%bot%: fuck you shitlord %random_player_name%",
                "%bot%: why am i having fun",
                "%bot%: who the fuck are you",
                "%bot%: cual hacks",
                "%bot%: So! What do you think of the largeness of my area %random_player_name%?",
                "%bot%: IT'S WAY TOO HOT HERE",
                "%bot%: Today, we're dancing for no reason. Someday, we'll disappear for no reason.",
            }
        },
        death_messages = {
            chance = 60,
            messages = {
                "%bot%: Ha ha ha ha ha. You're dead, moron!",
                "%bot%: %victim% found out the void has nothing in it",
                "%bot%: %victim% just voided there warranty",
                "%bot%: OBLITERATED",
                "%bot%: BRUTALITY",
                "%bot%: Objective failed.",
                "%bot%: Try again, Oh nevermind you're already dead!",
            }
        }
    },
    ["Di$c0rDi4"] = {
        ip = "127.0.0.1",
        general_chatter = {
            duration = { 60, 300 },
            messages = {
                "%bot%: Oh my god, he's going for our heads - pull your shirts up!",
                "%bot%: Think of something clever to say, uh-- YOU'RE TRESPASSING ASSHOLE",
                "%bot%: I am gonna stream this",
                "%bot%: do you know who I am shitlord?",
                "%bot%: Losing to you...generated dark feelings in me!",
                "%bot%: I lost because I didn't eat enough pizza.",
                "%bot%: Y'all are stupid!",
            }
        },
        death_messages = {
            chance = 50,
            messages = {
                "%bot%: Boy, are you stupid. And dead.",
                "%bot%: Here's a picture of your corpse. Not pretty.",
                "%bot%: That happened.",
                "%bot%: Things aren't looking so bright.",
                "%bot%: Not everything is sunshine and rainbows, by the way.",
                "%bot%: Eliminated.",
                "%bot%: Don't rage please, And have a cup of tea",
            }
        }
    },
    ["RuNNiNgRi0t"] = {
        ip = "127.0.0.1",
        general_chatter = {
            duration = { 60, 300 },
            messages = {
                "%bot%: /login admin001",
                "%bot%: nigga balls",
                "%bot%: batshit crazy",
                "%bot%: shitter than shitternet",
                "%bot%: I get this uncontrollable urge to steal other people's POKéMON.",
                "%bot%: I WILL BEAT UP MY SURF BOARD",
            }
        },
        death_messages = {
            chance = 55,
            messages = {
                "%bot%: Time to reload, %victim%.",
                "%bot%: You're dead as a doornail.",
                "%bot%: %victim% choked to death on a fortune cookie",
                "%bot%: Respawning...",
                "%bot%: AAAAHHHHHHHHH",
                "%bot%: Welp.",
                "%bot%: Teleporting Lava Sucks",
            }
        }
    },
    ["pHpCod3"] = {
        ip = "127.0.0.1",
        general_chatter = {
            duration = { 60, 300 },
            messages = {
                "%bot%: aki es mas divertido :S",
                "%bot%: i run this shit bitch ",
                "%bot%: Wanna hear a joke %random_player_name%?",
                "%bot%: %random_player_name% fell off the map cuz the gay porter is gay",
                "%bot%: You only live once, so I live",
                "%bot%: You're pretty hot, %random_player_name%, but not as hot as BROCK!",
            }
        },
        death_messages = {
            chance = 30,
            messages = {
                "%bot%: You're dead. Again, %victim%!",
                "%bot%: You have no kills! Noob!",
                "%bot%: Relax sonny! %k_kills% kills, and you be like... mad bro!",
                "%bot%: There is an unnecessary amount of death lines in this game.",
                "%bot%: Tip: Don't die.",
                "%bot%: Have you tried NOT dying?",
                "%bot%: Oh noes",
            }
        }
    },
    ["C#M4sTer"] = {
        ip = "127.0.0.1",
        general_chatter = {
            duration = { 60, 300 },
            messages = {
                "%bot%: aprende a jugar?",
                "%bot%: timelimit?",
                "%bot%: i am going to win %random_player_name%",
                "%bot%: i have absolutely no idea what i am doing",
                "%bot%: IF I LOSE I PRETEND I AM A MILTANK",
                "%bot%: I wish my boyfriend was as good as you.",
                "%bot%: we're already as hard as bone out here, homie.",
                "%bot%: What are you babbling about, %random_player_name%?",
                "%bot%: I do not suffer fools easily.",
                "%bot%: I had no idea what you talking about!",
                "%bot%: I had little patience to begin with!",
            }
        },
        death_messages = {
            chance = 30,
            messages = {
                "%bot%: You fought valiantly... but to no avail.",
                "%bot%: Rest in peace, %victim%.",
                "%bot%: %victim% tried to see what was under the world",
                "%bot%: %victim% discovered there was nothing to see under the world",
                "%bot%: :god me",
                "%bot%: /kill * ... Oh, it worked.",
                "%bot%: The end.",
                "%bot%: FIN",
                "%bot%: Hello, player.",
                "%bot%: RIP you 0 Streak",
            }
        }
    },
    ["KilliNgSpr33"] = {
        ip = "127.0.0.1",
        general_chatter = {
            duration = { 60, 300 },
            messages = {
                "%bot%: is there a meaning behind that?",
                "%bot%: tell me your skype id %random_player_name%?",
                "%bot%: what's your discord %random_player_name%?",
                "%bot%: why is ur score so high %random_player_name%?",
                "%bot%: are you on steam?",
                "%bot%: um what just happend",
                "%bot%: This is my first time in 20 days. Leave me in peace, can ye?",
                "%bot%: Magmar pulled out a nice, toasty Quick Ball from...well...somewhere!",
            }
        },
        death_messages = {
            chance = 45,
            messages = {
                "%bot%: Your life ends in the wasteland...",
                "%bot%: You have a date with the undertaker!!",
                "%bot%: You died.",
                "%bot%: Get shrekt",
                "%bot%: Better luck next time",
                "%bot%: That's one more death added...",
                "%bot%: Counting failures...",
            }
        }
    },
    ["J4vaScRiP7"] = {
        ip = "127.0.0.1",
        general_chatter = {
            duration = { 60, 300 },
            messages = {
                "%bot%: bueno chao tengo vs",
                "%bot%: get a life retard",
                "%bot%: wtf %random_player_name%",
                "%bot%: gg",
                "%bot%: played for a long time",
                "%bot%: mcc is the devil",
                "%bot%: If you don't make it, I'll be sure your remains at least get back home.",
                "%bot%: EEK! Did you touch me?",
                "%bot%: How's that? Owned, suckah!",
            }
        },
        death_messages = {
            chance = 75,
            messages = {
                "%bot%: Time to fit you for a coffin %victim%",
                "%bot%: Damn you and the horse you rode in on!!",
                "%bot%: %victim% took a peak into the fourth dimension",
            }
        }
    },
    ["N00bC0mb0"] = {
        ip = "127.0.0.1",
        general_chatter = {
            duration = { 60, 300 },
            messages = {
                "%bot%: im bad at sniping",
                "%bot%: no fucking way",
                "%bot%: LONG TIME NO SEE %random_player_name%",
                "%bot%: This guy would make a great punching bag",
                "%bot%: Sometimes the best thing to do… is to walk away.",
                "%bot%: I AM GOING TO ENJOY AN EGG",
                "%bot%: ...My bat is crying because it wants a hit so badly.",
                "%bot%: Yeah, you really do need some length, right?",
            }
        },
        death_messages = {
            chance = 35,
            messages = {
                "%bot%: Hope ya plant better than ya shoot!!",
                "%bot%: Had enough yet?!",
                "%bot%: %victim% might have fallen into the void",
                "%bot%: %victim% had its legacy in the void",
                "%bot%: %victim% took a peak into the fourth dimension",
            }
        }
    },
    ["JotoBACULOS"] = {
        ip = "127.0.0.1",
        general_chatter = {
            duration = { 60, 300 },
            messages = {
                "%bot%: I got a new vehicle this year!",
                "%bot%: I am a douche",
                "%bot%: Let them burn. This is God’s will. This is their punishment.",
                "%bot%: No one is coming to save you.",
                "%bot%: The reckoning is at hand!",
                "%bot%: Time is of the essense.",
                "%bot%: We will have justice!",
                "%bot%: Ah, you have a death wish. ",
            }
        },
        death_messages = {
            chance = 35,
            messages = {
                "%bot%: I'm going to send ya to an early grave!!",
                "%bot%: You insult me, %killer%!!",
                "%bot%: Take #2!",
                "%bot%: Alt+F4 to close your game. Just a useful reminder.",
                "%bot%: Time to unplug the router...",
            }
        }
    },
    ["Cy$era++"] = {
        ip = "127.0.0.1",
        general_chatter = {
            duration = { 60, 300 },
            messages = {
                "%bot%: bien aciendo matadero un ratito",
                "%bot%: I got a new phone and apple watch :D",
                "%bot%: Giving a eulogy for John Seed....",
                "%bot%: Sela'ma ashal'anore!",
                "%bot%: Shorel'aran.",
                "%bot%: Stay the course",
                "%bot%: Sometimes it’s best to leave well enough alone.",
                "%bot%: Everything has a price.",
                "%bot%: I have one of a kind weapons",
                "%bot%: What do you seek, %random_player_name%?",
                "%bot%: Your gold is welcome here.",
            }
        },
        death_messages = {
            chance = 40,
            messages = {
                "%bot%: Huh, too slow!!",
                "%bot%: Today is a good day to die %victim%!!",
                "%bot%: You died...",
                "%bot%: Haha noob",
                "%bot%: Get rekt",
            }
        }
    },
    ["Lu4$cRiPt"] = {
        ip = "127.0.0.1",
        general_chatter = {
            duration = { 60, 300 },
            messages = {
                "%bot%: join osh (press f2)",
                "%bot%: I missed you!",
                "%bot%: I love Chalwk",
                "%bot%: Hold your head high, %random_player_name%",
                "%bot%: Keep your wits about you.",
                "%bot%: Remember the Sunwell.",
                "%bot%: Get your finger on the pussy trigger!",
                "%bot%: I've spent my entire life, looking for things to say yes to.",
                "%bot%: You waste my time.",
                "%bot%: Choose wisely, %random_player_name%",
                "%bot%: Do not loiter.",
            }
        },
        death_messages = {
            chance = 40,
            messages = {
                "%bot%: Hell - I can already smell your rotting corpse.",
                "%bot%: Not good enough %victim%, not good enough!",
                "%bot%: You died!",
                "%bot%: You died?",
            }
        }
    },
    ["C++Ma$t3R"] = {
        ip = "127.0.0.1",
        general_chatter = {
            duration = { 60, 300 },
            messages = {
                "%bot%: join osh %random_player_name% (press f2)",
                "%bot%: I love you %random_player_name%",
                "%bot%: marry me",
                "%bot%: Adio is a boss ass nigger",
                "%bot%: Don't be presumptuous, or I'll banish you.",
                "%bot%: i erect the spine of praise",
                "%bot%: What business have you, %random_player_name%?",
                "%bot%: Yes?",
                "%bot%: Death to all who oppose us!",
                "%bot%: Farewell.",
            }
        },
        death_messages = {
            chance = 50,
            messages = {
                "%bot%: Hell! My horse pisses straighter than you shoot!!",
                "%bot%: Can't you do better than that! I've seen worms move faster!",
                "%bot%: Please don't smash your monitor.",
                "%bot%: Your safety isn't guaranteed",
            }
        }
    },
    ["Py7h0NC0d3"] = {
        ip = "127.0.0.1",
        general_chatter = {
            duration = { 60, 300 },
            messages = {
                "%bot%: join osh %random_player_name% (press f2)",
                "%bot%: si no tuvieras ese ping fuera otra histoeia",
                "%bot%: Chalwk is my best friend",
                "%bot%: suck it %random_player_name%",
                "%bot%: Vote for Ron Paul",
                "%bot%: Don't get cocky, you Johto punk!",
                "%bot%: Glub-glub-glub...",
                "%bot%: The Eternal Sun guides us.",
                "%bot%: Victory lies ahead!",
                "%bot%: We will persevere!",
            }
        },
        death_messages = {
            chance = 70,
            messages = {
                "%bot%: Ees too bad you got manure for brains!!",
                "%bot%: Hell's full a' retired Gamers, %victim%, And it's time you join em!",
                "%bot%: You are awesome %killer%",
                "%bot%: Not everything goes well in this game.",
                "%bot%: Perhaps I should nerf that...",
                "%bot%: Wrong button %victim%",
                "%bot%: Misclick?",
            }
        }
    },
    ["Op3nC4rNaGe"] = {
        ip = "127.0.0.1",
        general_chatter = {
            duration = { 60, 300 },
            messages = {
                "%bot%: osh for the win",
                "%bot%: ok noob usted que se cree todo por tener ese ping",
                "%bot%: Push the button!",
                "%bot%: Chalwk is the best person ever!!!!!!",
                "%bot%: I tested positive for AIDS",
                "%bot%: I am having a bad day",
                "%bot%: Our enemies will fall!",
                "%bot%: State your business.",
                "%bot%: The dark times will pass.",
            }
        },
        death_messages = {
            chance = 75,
            messages = {
                "%bot%: get rekt",
                "%bot%: owned punk",
                "%bot%: Aw, %victim%, I seen better shooting at the county fair!",
                "%bot%: I know. It's not your computer. It's not lag. Or is it?",
                "%bot%: Pfft.",
                "%bot%: You died that easily?",
                "%bot%: I expected a little more, but okay.",
                "%bot%: Aaaaand that's a wrap.",
                "%bot%: That's all, folks!",
            }
        }
    },
}

api_version = "1.12.0.0"

-- config ends --

local time_scale = 1 / 30

function OnScriptLoad()
    register_callback(cb["EVENT_TICK"], "OnTick")
    register_callback(cb["EVENT_JOIN"], "OnJoin")
    register_callback(cb["EVENT_LEAVE"], "OnQuit")
    register_callback(cb["EVENT_DIE"], "OnPlayerDeath")
    register_callback(cb["EVENT_GAME_END"], "OnGameEnd")
    register_callback(cb["EVENT_GAME_START"], "OnGameStart")
    OnGameStart()
end

function ChatBot:OnGameStart()
    self.init = false
    self.players = { }
    if (get_var(0, "$gt") ~= "n/a") then
        self.init = true
        self.delayed_messages = self.delayed_messages or {}
        for i = 1, 16 do
            if player_present(i) then
                self:InitPlayer(i, false)
            end
        end
    end
end

function ChatBot:InitPlayer(Ply, Reset)
    local name = get_var(Ply, "$name")
    if (not Reset) then

        local player = self[name]

        local ip = get_var(Ply, "$ip"):match("%d+.%d+.%d+.%d+")
        if (player and player.ip == ip) then

            self.players[name] = player
            self.players[name].timer = 0

            local duration = player.general_chatter.duration
            self.players[name].time_until_next_talk = rand(duration[1], duration[2] + 1)

            return
        end
    end

    self.players[name] = nil
    self.delayed_messages[name] = nil
end

function OnGameEnd()
    ChatBot.init = false
end

function OnJoin(Ply)
    ChatBot:InitPlayer(Ply, false)
end

function OnQuit(Ply)
    ChatBot:InitPlayer(Ply, true)
end

local function Say(String)
    execute_command("msg_prefix \"\"")
    say_all(String)
    execute_command("msg_prefix \" " .. ChatBot.server_prefix .. "\"")
end

function ChatBot:OnTick()
    if (self.init) then
        for name, v in pairs(self.players) do

            v.timer = v.timer + time_scale
            if (v.timer >= v.time_until_next_talk) then

                local t = v.general_chatter
                v.time_until_next_talk = rand(t.duration[1], t.duration[2] + 1)
                v.timer = 0

                local names = { }
                local random_name = "server"
                for i = 1, 16 do
                    if player_present(i) then
                        local random_player_name = get_var(i, "$name")
                        if (random_player_name ~= name) then
                            names[#names + 1] = random_player_name
                        end
                    end
                end

                random_name = names[rand(1, #names + 1)]
                local txt = t.messages[rand(1, #t.messages + 1)]
                txt = txt:gsub("%%bot%%", name):gsub("%%random_player_name%%", random_name)
                Say(txt:gsub("%%bot%%", name))
            end
        end

        for name, v in pairs(self.delayed_messages) do
            if (name) then
                v.timer = v.timer + time_scale
                if (v.timer >= v.delay) then
                    self.delayed_messages[name] = nil
                    Say(v.txt)
                end
            end
        end
    end
end

local function RepalceStr(n, kn, vn, vk, kk)
    return {
        ["%%bot%%"] = n, -- bot name
        ["%%killer%%"] = kn, -- killer name
        ["%%victim%%"] = vn, -- victim name
        ["%%v_kills%%"] = vk, -- victim kills
        ["%%k_kills%%"] = kk, -- killer kills
    }
end

function ChatBot:OnPlayerDeath(Victim, Killer)
    if (self.init and self.players) then
        local killer, victim = tonumber(Killer), tonumber(Victim)
        if (killer > 0 and killer ~= victim) then
            for name, v in pairs(self.players) do

                local k_name = get_var(killer, "$name")
                local v_name = get_var(victim, "$name")

                if (k_name ~= name and v_name ~= name) then

                    math.randomseed(os.clock())
                    math.random();
                    math.random();
                    math.random();

                    local txt
                    local chance = v.death_messages.chance
                    if (math.random() < chance / 100) then
                        local t = v.death_messages.messages
                        txt = t[rand(1, #t + 1)]

                        local v_kills = get_var(victim, "$kills")
                        local k_kills = get_var(killer, "$kills")

                        local str = RepalceStr(name, k_name, v_name, v_kills, k_kills)
                        for a, b in pairs(str) do
                            txt = txt:gsub(a, b)
                        end
                    end

                    if (txt) then
                        self.delayed_messages[name] = {
                            txt = txt,
                            timer = 0,
                            delay = math.random(0, 5)
                        }
                    end
                end
            end
        end
    end
end

function OnTick()
    return ChatBot:OnTick()
end

function OnPlayerDeath(V, K)
    return ChatBot:OnPlayerDeath(V, K)
end

function OnGameStart()
    return ChatBot:OnGameStart()
end

function OnScriptUnload()
    -- N/A
end

return ChatBot