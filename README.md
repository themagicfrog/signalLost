# signal lost

i'm spending 100 hrs over the next 2 months to make this 2d platformer in Godot as part of [Juice](https://github.com/hackclub/juice)!

- the premise
    
    you are an astronaut who crash landed on an alien planet! to return home, you must retrieve the parts of your spaceship that were scattered around the planet and learn the language of the aliens so they can help you!
    

- key mechanics
    - #1. learning the alien language
        
        there are glyphs that mean different words (ex. “stop”, “danger”, “safety”, “yes”, “no”, etc) the player will need to recognize the symbols, remember their meanings, and choose the right words to say to the aliens. if you can communicate with them and understand what they say, they can help you know which path to take, open locked doors, and help kill deadly plants blocking the way. all aliens are friendly and they are there to help you, but if you say the wrong thing to them, they might get angry and harm you. there will also be signs on the map that have alien words on them.
        
        the player walks up to an alien, presses E to interact, and a speech bubble will appear from the alien. there will be a couple symbols they are saying. then the player will have the option to choose to respond from a few different symbols. if they answer correctly, the alien will respond, and have a short animation to complete the task to help the player continue. if they answer wrong, they will need to try again or if they choose the worst possible answer (ex. the alien asks “why are you here?” and the choices are “food,” “kill”, “spaceship”, etc. if they choose “kill”, then the alien will probably attack them)
        
    - #2 limited oxygen and oxygen bubbles to stay alive
        
        the player needs a certain amount of air to survive, and if they run out of that, then their health goes down. around the planet, there are bubbles of oxygen that float in different places. the player needs to capture these as they go through the map. once the bubbles are captured, they will take a few seconds to regenerate. the astronaut will have to move quickly between each bubble to stay alive.
        
    - #3 magnet walls
        
        on this planet, many of the walls are just big magnets. in some places, the astronaut can walk on the walls or the ceiling and each magnet wall has a different amount of strength. the player will be able to tell if a wall is a magnet or not, and how strong it is, based on its appearence. they’ll need to keep in mind the gravity changes as they go through the map. in different places, the strength, direction of it.
        
    - #4 bonus if time, jetpack
        
        the player has a jetpack and they can use it to boost themselves in any direction when they are in the air. they refuel by standing on the ground.
        

- goals, levels & obstacles
    
    the main goal is to retrieve the 4 parts of your spaceship and put them all back together to return home.
    
    obstacles include deadly alien plants that will try to kill you. (ex. gaseous mushrooms, big carnivorious plants, etc.) and if you answer wrong to the aliens, they might attack you. if you don’t capture enough oxygen bubbles in time, you will die. if you die in a level, you respawn at the checkpoints.
    
    there are 4 levels, the first 3 each have 1 spaceship part, and the last one you must navigate the alien city to the workshop, where your spaceship will be put back together. each level slowly helps you learn more of the alien language and gets harder. each level also has a different environment.
    
    - #1 alien sky
        1. player has just crash landed and there is a short animation intro showing the pieces of their spaceship scattering around the planet (the nose cone, the body, and the rocket fins)
        2. this is a pretty easy and short level where the astronaut just gets used to the magnet walls, oxygen bubbles, and starts learning very basic alien words (”yes”, “no”, “danger”, “home”)
        3. the level design is pretty open, there are bright cloud-like platforms, and the player will float around a lot. there is only one path
        4. at the end, they find the nose cone of the rocket and store it in their bag!
    
    - #2 alien forest
        1. the player has descended from the sky and reached the forest.
        2. level design is more closed and there are lots of strange alien plants. many of the plants are harmful, like sentient carnivorious plants, big gaseous mushrooms, or strangling vines.
        3. there are multiple paths, and the player needs to choose the right one. an alien will be standing at each intersection and you must ask and understand them. 
        4. the player learns more alien words (”right”, “left”, “up”, “down”, “fast”, “kill”)
        5. at the end, they find the body of the rocket and put it in their bag!
    
    - #3 alien cave
        1. level design is pretty closed and dark and the paths are like tunnels. there are many different paths, and it is sort of mazelike. 
        2. you will need to interact with the aliens a lot. the aliens are grumpy, so you need to talk very polite with them, and if you make a mistake, it is more likely they will attack you.
        3. player learns more words (”please”, “thank you”, “hi”, “bye”) and they need to say all of those to the alien, or it will be very unhappy. 
        4. the plants are glowing moss, mushrooms, and glowworms and they will suck away your oxygen bubble if you get too close. in the cave, there is very limited oxygen, so capturing enough air is super important to stay alive!
        5. at the end, they find the rocket fins and store it away!
    
    - #4 alien city
        1. the player now has all the parts they need to reassemble their rocket ship, but they don’t have the tools it. they must travel through the alien city to the workshop to build it.
        2. the city has the most magnet walls, each with extreme pulls and lots of different directions that the player must deal with.
        3. the level design is a mix of closed and open. 
        4. there are many strange alien skyscrapers and LOTS of aliens that you need to interact with. remembering all the words will be one of the most difficult parts of this level. the aliens are also super aggressive if you answer wrong. the player doesn’t learn too many new words, because they already have a lot of keep track of.
        5. the door to the workshop has a final puzzle of all the words and the player must solve to win. once they get to the workshop, the aliens help them reassemble all the pieces of the rocket ship and the player gets in the rocket and flies back home!! they win!

- style
    
    art style is pixel neon sci-fi aesthetic and everything is very funky and glowy
  hyper light drifter
