#!/usr/bin/env fish

# Add new quotes to the existing database (grows the collection)
# Adds 3 random quotes per run from the staging pool

set CACHE_DIR "$HOME/.cache/inspiration"
set DB_FILE "$CACHE_DIR/quotes.db"
set QUOTES_PER_RUN 3

mkdir -p $CACHE_DIR

# Create database if it doesn't exist
if not test -f $DB_FILE
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
end

# Function to add a quote (checks for duplicates)
function add_quote
    set -l quote $argv[1]
    set -l author $argv[2]
    set -l tag $argv[3]
    set -l type $argv[4]

    # Escape single quotes for SQL
    set quote_escaped (string replace -a "'" "''" $quote)
    set author_escaped (string replace -a "'" "''" $author)

    # Check if quote already exists
    set existing (sqlite3 $DB_FILE "SELECT COUNT(*) FROM quotes WHERE quote='$quote_escaped';")

    if test $existing -eq 0
        sqlite3 $DB_FILE "INSERT INTO quotes (quote, author, tag, type) VALUES ('$quote_escaped', '$author_escaped', '$tag', '$type');"
        return 0
    else
        return 1
    end
end

# ============ STAGING POOL - Quotes to be added over time ============

# Create arrays for quotes (quote|author|tag|type)
set -l staging_pool

# Encouragements (short, personal)
set staging_pool $staging_pool "Tomorrow's success starts with today's effort.||action|encouragement"
set staging_pool $staging_pool "Small wins create big momentum.||growth|encouragement"
set staging_pool $staging_pool "You're stronger than your excuses.||discipline|encouragement"
set staging_pool $staging_pool "Done is better than perfect.||action|encouragement"
set staging_pool $staging_pool "Your consistency will compound.||persistence|encouragement"
set staging_pool $staging_pool "Choose growth over comfort.||growth|encouragement"
set staging_pool $staging_pool "Every expert started as a beginner.||mindset|encouragement"
set staging_pool $staging_pool "Your focus determines your reality.||focus|encouragement"
set staging_pool $staging_pool "Show up even when it's hard.||resilience|encouragement"
set staging_pool $staging_pool "The best investment is in yourself.||growth|encouragement"
set staging_pool $staging_pool "Progress isn't linear. Keep going.||persistence|encouragement"
set staging_pool $staging_pool "Your goals are waiting. Start now.||action|encouragement"
set staging_pool $staging_pool "Discipline today, freedom tomorrow.||discipline|encouragement"
set staging_pool $staging_pool "Make yourself proud.||purpose|encouragement"
set staging_pool $staging_pool "You're planting seeds for your future.||growth|encouragement"
set staging_pool $staging_pool "Momentum builds with each step.||action|encouragement"
set staging_pool $staging_pool "Your effort is never wasted.||persistence|encouragement"
set staging_pool $staging_pool "Clarity comes through action.||action|encouragement"
set staging_pool $staging_pool "Rest, but never quit.||resilience|encouragement"
set staging_pool $staging_pool "You're capable of more than you realize.||mindset|encouragement"
set staging_pool $staging_pool "Create the life you want to live.||purpose|encouragement"
set staging_pool $staging_pool "Every day is a fresh start.||present|encouragement"
set staging_pool $staging_pool "You control your effort. That's enough.||discipline|encouragement"
set staging_pool $staging_pool "Build habits that serve your future.||growth|encouragement"
set staging_pool $staging_pool "Your breakthrough is closer than you think.||persistence|encouragement"
set staging_pool $staging_pool "Be patient with your progress.||growth|encouragement"
set staging_pool $staging_pool "Your story isn't over yet.||resilience|encouragement"
set staging_pool $staging_pool "Commit to the process.||discipline|encouragement"
set staging_pool $staging_pool "You don't need permission to start.||courage|encouragement"
set staging_pool $staging_pool "Focus on what you can control.||focus|encouragement"
set staging_pool $staging_pool "Your work matters. Keep building.||purpose|encouragement"
set staging_pool $staging_pool "Choose discipline over regret.||discipline|encouragement"
set staging_pool $staging_pool "The journey is the reward.||present|encouragement"
set staging_pool $staging_pool "You're writing your legacy daily.||purpose|encouragement"
set staging_pool $staging_pool "Push through the resistance.||persistence|encouragement"
set staging_pool $staging_pool "Your mindset shapes your reality.||mindset|encouragement"
set staging_pool $staging_pool "Start where you are. Use what you have.||action|encouragement"
set staging_pool $staging_pool "Greatness is built in small moments.||growth|encouragement"
set staging_pool $staging_pool "Your dedication will pay off.||persistence|encouragement"
set staging_pool $staging_pool "Be the reason you succeed.||mindset|encouragement"
set staging_pool $staging_pool "Today's struggle is tomorrow's strength.||resilience|encouragement"
set staging_pool $staging_pool "Trust your journey. Trust yourself.||mindset|encouragement"
set staging_pool $staging_pool "Your potential is waiting to be unlocked.||growth|encouragement"
set staging_pool $staging_pool "Stay committed to your vision.||focus|encouragement"
set staging_pool $staging_pool "You're one decision away from change.||action|encouragement"

# Motivations (longer, with authors)
set staging_pool $staging_pool "The only limit to our realization of tomorrow will be our doubts of today.|Franklin D. Roosevelt|mindset|motivation"
set staging_pool $staging_pool "Do not go where the path may lead, go instead where there is no path and leave a trail.|Ralph Waldo Emerson|courage|motivation"
set staging_pool $staging_pool "Success usually comes to those who are too busy to be looking for it.|Henry David Thoreau|action|motivation"
set staging_pool $staging_pool "Opportunities don't happen. You create them.|Chris Grosser|action|motivation"
set staging_pool $staging_pool "Don't be afraid to give up the good to go for the great.|John D. Rockefeller|excellence|motivation"
set staging_pool $staging_pool "I find that the harder I work, the more luck I seem to have.|Thomas Jefferson|discipline|motivation"
set staging_pool $staging_pool "Success is not how high you have climbed, but how you make a positive difference to the world.|Roy T. Bennett|purpose|motivation"
set staging_pool $staging_pool "The road to success and the road to failure are almost exactly the same.|Colin R. Davis|persistence|motivation"
set staging_pool $staging_pool "If you are not willing to risk the usual, you will have to settle for the ordinary.|Jim Rohn|courage|motivation"
set staging_pool $staging_pool "Take up one idea. Make that one idea your life. Think of it, dream of it, live on that idea.|Swami Vivekananda|focus|motivation"
set staging_pool $staging_pool "All our dreams can come true, if we have the courage to pursue them.|Walt Disney|courage|motivation"
set staging_pool $staging_pool "The future depends on what you do today.|Mahatma Gandhi|action|motivation"
set staging_pool $staging_pool "Don't count the days, make the days count.|Muhammad Ali|present|motivation"
set staging_pool $staging_pool "If you want to achieve greatness, stop asking for permission.|Anonymous|courage|motivation"
set staging_pool $staging_pool "The only way to do great work is to love what you do. If you haven't found it yet, keep looking.|Steve Jobs|purpose|motivation"
set staging_pool $staging_pool "What lies behind us and what lies before us are tiny matters compared to what lies within us.|Ralph Waldo Emerson|mindset|motivation"
set staging_pool $staging_pool "Believe you can and you're halfway there.|Theodore Roosevelt|mindset|motivation"
set staging_pool $staging_pool "The only impossible journey is the one you never begin.|Tony Robbins|action|motivation"
set staging_pool $staging_pool "In the middle of difficulty lies opportunity.|Albert Einstein|resilience|motivation"
set staging_pool $staging_pool "What we think, we become.|Buddha|mindset|motivation"
set staging_pool $staging_pool "Quality is not an act, it is a habit.|Aristotle|excellence|motivation"
set staging_pool $staging_pool "The difference between ordinary and extraordinary is that little extra.|Jimmy Johnson|excellence|motivation"
set staging_pool $staging_pool "You miss 100% of the shots you don't take.|Wayne Gretzky|action|motivation"
set staging_pool $staging_pool "Either you run the day or the day runs you.|Jim Rohn|discipline|motivation"
set staging_pool $staging_pool "Build your own dreams, or someone else will hire you to build theirs.|Farrah Gray|purpose|motivation"
set staging_pool $staging_pool "The best revenge is massive success.|Frank Sinatra|excellence|motivation"
set staging_pool $staging_pool "People who are crazy enough to think they can change the world, are the ones who do.|Rob Siltanen|courage|motivation"
set staging_pool $staging_pool "Knowing is not enough; we must apply. Wishing is not enough; we must do.|Johann Wolfgang von Goethe|action|motivation"
set staging_pool $staging_pool "Imagine your life is perfect in every respect; what would it look like?|Brian Tracy|purpose|motivation"
set staging_pool $staging_pool "We become what we think about most of the time.|Earl Nightingale|mindset|motivation"
set staging_pool $staging_pool "Do one thing every day that scares you.|Eleanor Roosevelt|courage|motivation"
set staging_pool $staging_pool "Twenty years from now you will be more disappointed by the things that you didn't do.|Mark Twain|courage|motivation"
set staging_pool $staging_pool "A person who never made a mistake never tried anything new.|Albert Einstein|growth|motivation"
set staging_pool $staging_pool "The person who says it cannot be done should not interrupt the person who is doing it.|Chinese Proverb|action|motivation"
set staging_pool $staging_pool "There are no traffic jams along the extra mile.|Roger Staubach|excellence|motivation"
set staging_pool $staging_pool "You learn more from failure than from success. Don't let it stop you.|Anonymous|resilience|motivation"
set staging_pool $staging_pool "If you are working on something that you really care about, you don't have to be pushed.|Steve Jobs|passion|motivation"
set staging_pool $staging_pool "People rarely succeed unless they have fun in what they are doing.|Dale Carnegie|passion|motivation"
set staging_pool $staging_pool "Your time is limited, don't waste it living someone else's life.|Steve Jobs|purpose|motivation"
set staging_pool $staging_pool "If the wind will not serve, take to the oars.|Latin Proverb|action|motivation"
set staging_pool $staging_pool "You can't build a reputation on what you are going to do.|Henry Ford|action|motivation"
set staging_pool $staging_pool "Nothing will work unless you do.|Maya Angelou|discipline|motivation"
set staging_pool $staging_pool "Some people want it to happen, some wish it would happen, others make it happen.|Michael Jordan|action|motivation"
set staging_pool $staging_pool "Success is walking from failure to failure with no loss of enthusiasm.|Winston Churchill|persistence|motivation"
set staging_pool $staging_pool "If you really look closely, most overnight successes took a long time.|Steve Jobs|persistence|motivation"
set staging_pool $staging_pool "The way to get started is to quit talking and begin doing.|Walt Disney|action|motivation"
set staging_pool $staging_pool "Don't let yesterday take up too much of today.|Will Rogers|present|motivation"
set staging_pool $staging_pool "You don't have to be great to start, but you have to start to be great.|Zig Ziglar|action|motivation"
set staging_pool $staging_pool "If you cannot do great things, do small things in a great way.|Napoleon Hill|excellence|motivation"
set staging_pool $staging_pool "Hardships often prepare ordinary people for an extraordinary destiny.|C.S. Lewis|resilience|motivation"
set staging_pool $staging_pool "Start where you are. Use what you have. Do what you can.|Arthur Ashe|action|motivation"
set staging_pool $staging_pool "Don't watch the clock; do what it does. Keep going.|Sam Levenson|persistence|motivation"
set staging_pool $staging_pool "A year from now you may wish you had started today.|Karen Lamb|action|motivation"
set staging_pool $staging_pool "Everything you've ever wanted is on the other side of fear.|George Addair|courage|motivation"
set staging_pool $staging_pool "Success is not final, failure is not fatal: it is the courage to continue that counts.|Winston Churchill|perseverance|motivation"
set staging_pool $staging_pool "It is never too late to be what you might have been.|George Eliot|growth|motivation"
set staging_pool $staging_pool "Dream big and dare to fail.|Norman Vaughan|courage|motivation"
set staging_pool $staging_pool "Our greatest weakness lies in giving up. The most certain way to succeed is always to try just one more time.|Thomas Edison|persistence|motivation"
set staging_pool $staging_pool "Act as if what you do makes a difference. It does.|William James|purpose|motivation"
set staging_pool $staging_pool "Success is the sum of small efforts repeated day in and day out.|Robert Collier|discipline|motivation"
set staging_pool $staging_pool "Do not wait to strike till the iron is hot; but make it hot by striking.|William Butler Yeats|action|motivation"

# Select random quotes to add
set added_count 0
set attempted_count 0
set max_attempts (math "$QUOTES_PER_RUN * 3") # Try 3x the target to handle duplicates

# Shuffle staging pool
set staging_pool (printf '%s\n' $staging_pool | shuf)

echo "Adding up to $QUOTES_PER_RUN new quotes..."

for item in $staging_pool
    if test $added_count -ge $QUOTES_PER_RUN
        break
    end

    if test $attempted_count -ge $max_attempts
        break
    end

    set attempted_count (math "$attempted_count + 1")

    # Parse the item (quote|author|tag|type)
    set parts (string split '|' $item)
    set quote $parts[1]
    set author $parts[2]
    set tag $parts[3]
    set type $parts[4]

    if add_quote "$quote" "$author" "$tag" "$type"
        echo "  ✓ Added: $quote"
        set added_count (math "$added_count + 1")
    end
end

if test $added_count -eq 0
    echo "  ⊘ No new quotes added (all quotes from staging pool are already in database)"
    echo "  💡 Time to add more quotes to the staging pool!"
end

set total (sqlite3 $DB_FILE 'SELECT COUNT(*) FROM quotes;')
set encouragement_count (sqlite3 $DB_FILE "SELECT COUNT(*) FROM quotes WHERE type='encouragement';")
set motivation_count (sqlite3 $DB_FILE "SELECT COUNT(*) FROM quotes WHERE type='motivation';")

echo ""
echo "Database now contains $total quotes!"
echo "  • $encouragement_count encouragements (for starship)"
echo "  • $motivation_count motivations (for nvim)"
