#!/usr/bin/env fish

# Populate the quotes database with motivational content

set CACHE_DIR "$HOME/.cache/inspiration"
set DB_FILE "$CACHE_DIR/quotes.db"

mkdir -p $CACHE_DIR

# Remove old database if it exists
rm -f $DB_FILE

# Create fresh database
sqlite3 $DB_FILE "
CREATE TABLE quotes (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  quote TEXT NOT NULL,
  author TEXT,
  tag TEXT NOT NULL,
  type TEXT NOT NULL
);
CREATE INDEX idx_tag ON quotes(tag);
CREATE INDEX idx_type ON quotes(type);
"

echo "Populating database with quotes..."

# Function to add a quote
function add_quote
    set -l quote $argv[1]
    set -l author $argv[2]
    set -l tag $argv[3]
    set -l type $argv[4]

    # Escape single quotes for SQL
    set quote (string replace -a "'" "''" $quote)
    set author (string replace -a "'" "''" $author)

    sqlite3 $DB_FILE "INSERT INTO quotes (quote, author, tag, type) VALUES ('$quote', '$author', '$tag', '$type');"
end

# ============ ENCOURAGEMENTS (for starship - short, personal, no author) ============
add_quote "You've got this! Every step forward counts." "" "action" "encouragement"
add_quote "Today is full of possibilities. Make it count." "" "present" "encouragement"
add_quote "Believe in yourself. You're capable of more than you know." "" "mindset" "encouragement"
add_quote "Progress over perfection. Keep moving forward." "" "growth" "encouragement"
add_quote "Your effort matters. Keep pushing." "" "persistence" "encouragement"
add_quote "Small steps lead to big changes." "" "action" "encouragement"
add_quote "You're doing better than you think." "" "mindset" "encouragement"
add_quote "Trust the process. Growth takes time." "" "growth" "encouragement"
add_quote "Every challenge is a chance to grow stronger." "" "resilience" "encouragement"
add_quote "Your potential is limitless. Keep going." "" "mindset" "encouragement"
add_quote "Focus on progress, not perfection." "" "focus" "encouragement"
add_quote "You're exactly where you need to be." "" "present" "encouragement"
add_quote "Consistency beats intensity. Show up today." "" "discipline" "encouragement"
add_quote "Your future self will thank you." "" "action" "encouragement"
add_quote "Doubt kills more dreams than failure ever will." "" "courage" "encouragement"
add_quote "You're building something great. Stay focused." "" "focus" "encouragement"
add_quote "The hard days make you stronger." "" "resilience" "encouragement"
add_quote "You're not behind. You're on your own timeline." "" "mindset" "encouragement"
add_quote "Keep going. You're closer than you think." "" "persistence" "encouragement"
add_quote "Your best work is still ahead of you." "" "purpose" "encouragement"
add_quote "Embrace the challenge. You'll emerge stronger." "" "courage" "encouragement"
add_quote "Celebrate small wins. They compound." "" "growth" "encouragement"
add_quote "You're writing your story. Make it count." "" "purpose" "encouragement"
add_quote "Courage over comfort. You've got this." "" "courage" "encouragement"
add_quote "Stay hungry. Stay humble. Stay focused." "" "discipline" "encouragement"

# ============ MOTIVATIONS (for nvim - longer quotes with authors) ============

# Growth & Progress
add_quote "The only way to do great work is to love what you do." "Steve Jobs" "growth" "motivation"
add_quote "Success is not final, failure is not fatal: it is the courage to continue that counts." "Winston Churchill" "perseverance" "motivation"
add_quote "The expert in anything was once a beginner." "Helen Hayes" "growth" "motivation"
add_quote "Don't watch the clock; do what it does. Keep going." "Sam Levenson" "persistence" "motivation"
add_quote "The future belongs to those who believe in the beauty of their dreams." "Eleanor Roosevelt" "dreams" "motivation"

# Action & Discipline
add_quote "Action is the foundational key to all success." "Pablo Picasso" "action" "motivation"
add_quote "Discipline is the bridge between goals and accomplishment." "Jim Rohn" "discipline" "motivation"
add_quote "You don't have to be great to start, but you have to start to be great." "Zig Ziglar" "action" "motivation"
add_quote "The secret of getting ahead is getting started." "Mark Twain" "action" "motivation"
add_quote "What you do today can improve all your tomorrows." "Ralph Marston" "action" "motivation"

# Courage & Fear
add_quote "Courage is not the absence of fear, but the triumph over it." "Nelson Mandela" "courage" "motivation"
add_quote "Everything you want is on the other side of fear." "Jack Canfield" "courage" "motivation"
add_quote "Do one thing every day that scares you." "Eleanor Roosevelt" "courage" "motivation"
add_quote "The cave you fear to enter holds the treasure you seek." "Joseph Campbell" "courage" "motivation"

# Mindset & Attitude
add_quote "Whether you think you can or you think you can't, you're right." "Henry Ford" "mindset" "motivation"
add_quote "The only person you are destined to become is the person you decide to be." "Ralph Waldo Emerson" "mindset" "motivation"
add_quote "Life is 10% what happens to you and 90% how you react to it." "Charles R. Swindoll" "mindset" "motivation"
add_quote "The mind is everything. What you think you become." "Buddha" "mindset" "motivation"

# Excellence & Mastery
add_quote "Excellence is not a destination; it is a continuous journey that never ends." "Brian Tracy" "excellence" "motivation"
add_quote "We are what we repeatedly do. Excellence, then, is not an act, but a habit." "Aristotle" "excellence" "motivation"
add_quote "Strive not to be a success, but rather to be of value." "Albert Einstein" "excellence" "motivation"
add_quote "The way to get started is to quit talking and begin doing." "Walt Disney" "action" "motivation"

# Resilience & Adversity
add_quote "The greatest glory in living lies not in never falling, but in rising every time we fall." "Nelson Mandela" "resilience" "motivation"
add_quote "It does not matter how slowly you go as long as you do not stop." "Confucius" "perseverance" "motivation"
add_quote "Fall seven times, stand up eight." "Japanese Proverb" "resilience" "motivation"
add_quote "Strength does not come from winning. Your struggles develop your strengths." "Arnold Schwarzenegger" "resilience" "motivation"

# Focus & Priorities
add_quote "Focus on being productive instead of busy." "Tim Ferriss" "focus" "motivation"
add_quote "The successful warrior is the average man, with laser-like focus." "Bruce Lee" "focus" "motivation"
add_quote "What you stay focused on will grow." "Roy T. Bennett" "focus" "motivation"
add_quote "Concentrate all your thoughts upon the work at hand. The sun's rays do not burn until brought to a focus." "Alexander Graham Bell" "focus" "motivation"

# Learning & Wisdom
add_quote "An investment in knowledge pays the best interest." "Benjamin Franklin" "learning" "motivation"
add_quote "The capacity to learn is a gift; the ability to learn is a skill; the willingness to learn is a choice." "Brian Herbert" "learning" "motivation"
add_quote "Live as if you were to die tomorrow. Learn as if you were to live forever." "Mahatma Gandhi" "learning" "motivation"
add_quote "The beautiful thing about learning is that nobody can take it away from you." "B.B. King" "learning" "motivation"

# Innovation & Creativity
add_quote "Innovation distinguishes between a leader and a follower." "Steve Jobs" "innovation" "motivation"
add_quote "Creativity is intelligence having fun." "Albert Einstein" "creativity" "motivation"
add_quote "The best way to predict the future is to invent it." "Alan Kay" "innovation" "motivation"
add_quote "Logic will get you from A to B. Imagination will take you everywhere." "Albert Einstein" "creativity" "motivation"

# Purpose & Meaning
add_quote "The two most important days in your life are the day you are born and the day you find out why." "Mark Twain" "purpose" "motivation"
add_quote "Your work is to discover your work and then with all your heart to give yourself to it." "Buddha" "purpose" "motivation"
add_quote "The meaning of life is to find your gift. The purpose of life is to give it away." "Pablo Picasso" "purpose" "motivation"
add_quote "He who has a why to live can bear almost any how." "Friedrich Nietzsche" "purpose" "motivation"

# Today & Present
add_quote "Yesterday is history, tomorrow is a mystery, but today is a gift. That is why it is called the present." "Master Oogway" "present" "motivation"
add_quote "The best time to plant a tree was 20 years ago. The second best time is now." "Chinese Proverb" "action" "motivation"
add_quote "Do not dwell in the past, do not dream of the future, concentrate the mind on the present moment." "Buddha" "present" "motivation"
add_quote "Today is your opportunity to build the tomorrow you want." "Ken Poirot" "action" "motivation"
add_quote "The only impossible journey is the one you never begin." "Tony Robbins" "action" "motivation"

# Persistence & Determination
add_quote "I have not failed. I've just found 10,000 ways that won't work." "Thomas Edison" "persistence" "motivation"
add_quote "Success is stumbling from failure to failure with no loss of enthusiasm." "Winston Churchill" "persistence" "motivation"
add_quote "Persistence guarantees that results are inevitable." "Paramahansa Yogananda" "persistence" "motivation"
add_quote "It always seems impossible until it's done." "Nelson Mandela" "persistence" "motivation"

# Change & Growth
add_quote "Change is the law of life. And those who look only to the past or present are certain to miss the future." "John F. Kennedy" "change" "motivation"
add_quote "Progress is impossible without change, and those who cannot change their minds cannot change anything." "George Bernard Shaw" "change" "motivation"
add_quote "The only way to make sense out of change is to plunge into it, move with it, and join the dance." "Alan Watts" "change" "motivation"
add_quote "Be the change that you wish to see in the world." "Mahatma Gandhi" "change" "motivation"

set total (sqlite3 $DB_FILE 'SELECT COUNT(*) FROM quotes;')
set encouragement_count (sqlite3 $DB_FILE "SELECT COUNT(*) FROM quotes WHERE type='encouragement';")
set motivation_count (sqlite3 $DB_FILE "SELECT COUNT(*) FROM quotes WHERE type='motivation';")

echo "Database populated with $total quotes!"
echo "  • $encouragement_count encouragements (for starship)"
echo "  • $motivation_count motivations (for nvim)"
