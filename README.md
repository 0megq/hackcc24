# Fret Fighters

## Inspiration

We were inspired by our shared love for music and game development, as well as our experience with the challenges of starting your path learning an instrument. Many aspiring musicians get discouraged by the overwhelming difficulty of learning, but we sought to bridge this gap by creating a fun and engaging app for people to stay motivated. By merging our two passions, we hope to empower future musicians to explore their own passions through Fret Fighters. 

## What it does

Fret Fighters gamifies the process of learning guitar, making it both rewarding and exciting to practice, while being simplistic enough for guitar players of all backgrounds. Our app processes an audio input from the user’s microphone and compares the frequency of the note played to the ideal frequency in order to determine if the note is correct. Players then receive immediate feedback with a “pass” or “fail” system, encouraging them to improve their accuracy while progressing through fun and interactive levels.

## How we built it

We built Fret Fighters by combining a large selection of various tools and programs. At its core, we developed an AI-based note detection system to analyze audio input, paired with a game system developed in Godot. We primarily used Python and GDScript to build our application, allowing us to leverage Python’s rich ecosystem while still utilizing GDScrpt’s efficiency and intuitive design. Integrating these two languages was challenging, but was made possible through Godot Extensions, which enabled the use of foreign libraries and languages in our project. 

All of our visuals were intricately hand drawn in a pixel-art style using Krita, with sprites then being exported into Godot. The game’s interface and interactive UI/UX were all created and built within the Godot to ensure a more cohesive experience for the users. As for sound effects, we used Audacity to edit audio, incorporating real guitar sounds to enhance the authenticity and immersion. Together, these elements helped to bring our vision of a polished and enjoyable game into a reality.

## Challenges we ran into

Accurate and fast audio analysis is a difficult problem to solve. We initially tried a Fourier transformation. However, this did not meet our standard of accuracy. We then attempted a convolutional artificial intelligence model (CREPE). While it was extremely accurate, it was too slow for the fast paced game we were making. We settled on a combination of an FFT and Audio Autocorrelation algorithm called YinFFT. This algorithm was accurate enough to be suitable for our usecase while still being extremely fast - it can often detect a correct note in under a tenth of a second. Combined with a multithreading approach, this beats existing solutions to analyze real time user musical audio in the gaming industry. We also came across many technical issues such as some of us not being able to install certain python libraries, and the implementation of making a rest api with flask to send values between Godot and python.

## Accomplishments that we're proud of

We are incredibly proud of creating a top-of-the-line audio analysis tool tailored for game developers. The note detection in our app outperforms the competition in both speed and accuracy, which we believe can set a new standard in audio-based gaming technology. Beyond the technical achievement, we have also crafted an exceptionally fun and educational game designed to help anyone learn or improve their guitar skills. Additionally, the game's framework is easily extendable to support other instruments and even vocals, making it versatile for a wide range of musical learning experiences. With stunning visuals and engaging gameplay, we poured our passion into every aspect of development. We hope you enjoy playing Fret Fighters as much as we enjoyed creating it!

## What we learned

Through this project, we gained a deep understanding of audio analysis and its application. We explored both monophonic and polyphonic AI models, analyzing their trade-offs to find the best fit for our needs. Additionally, we delved into more classical algorithms like Fourier transformations and autocorrelation techniques, learning about their optimizations that include FFT, Sliding DFT, and optimized manually compiled libraries. By integrating these algorithms into the game engine with multithreading, we gained a deeper understanding of how to balance performance and accuracy effectively. Beyond audio analysis, we also expanded our skills in web development and API creation, particularly through Flask, enabling us to design an efficient backend for our application. While our game is designed to make learning easier and more enjoyable for aspiring musicians, the development process has been an incredible learning journey for us as well.

## What's next for Fret Fighters

We plan on expanding the game to other instruments - while the computational side works for any instrument, the UI should be tailored to anything a user wants to use in order to keep them engaged and learning. We are also planning on adding chord support with the addition of longer songs. Additionally, we plan on integrating harder difficulties for more experienced players, quality of life changes, and polishing the combat system! Stay tuned to our itch.io page for upcoming announcements!
