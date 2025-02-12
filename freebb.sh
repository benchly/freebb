#!/usr/bin/env bash
#
# blog.sh - A simple bash-based static blog generator
#
# Usage:
#   1) Give permission:  chmod +x blog.sh
#   2) Run:             ./blog.sh
#
# On first run, creates index.html, about.html, links.html, styles.css, plus an initial blog post.
# On subsequent runs, prompts the user to create new posts or update pages.

# ----------------------------------------------------
# CONFIGURATION
# ----------------------------------------------------

BLOG_TITLE="A Series of Tubes"
POSTS_DB="posts.txt"    # stores metadata about blog posts
STYLESHEET="styles.css"

# By default, we assume we have not initialized unless we see a marker file
INIT_MARKER=".initialized" 

# ----------------------------------------------------
# UTILITY FUNCTIONS
# ----------------------------------------------------

# Writes the styles.css file (simple design you can customize).
write_styles_css() {
  cat <<EOF > "$STYLESHEET"
html {
  font-size: 100%;
}
body {
  max-width: 650px;
  font-family: monospace;
  font-size: 1rem;
  margin: 0; 
  padding: 0; 
  background-color: #3b3c36; 
  color: #fdf5e6; 
}
header, nav, main{
  padding: 1rem;
}
nav, a {
  margin-right: 1rem; 
  color: #ffa07a; 
}
.post-links {
  margin-top: 1rem; 
  color: #ffa07a; 
}
h1, h2, h3 {
  font-size: 2em;
  margin: 0.5rem 0;
}
p {
  font-size: 1em;
  color: #fdf5e6;
}

footer {
  padding: 1rem;
  margin: 0.25rem 0;
  text-align: right;
}
EOF
  echo "Created/updated $STYLESHEET."
}

# A helper to get today's date in YYYY-MM-DD format
today_date() {
  date +"%Y-%m-%d"
}

# ----------------------------------------------------
# FOOTER (USED BY ALL PAGES)
# ----------------------------------------------------
# We store a function that outputs the HTML for the footer.
footer_html() {
  cat <<EOF
    <footer>
      <p>&copy; 2025 benchly@aseriesoftubes.lol</p>
	  <p>CC BY-NC-SA 4.0</p>
	  <p>I am open for writing work. Email me!</p>
    </footer>
EOF
}

# ----------------------------------------------------
# FUNCTIONS TO CREATE / UPDATE PAGES
# ----------------------------------------------------

write_index_html() {
  # Writes an index.html file compiled from BLOG_TITLE and any existing posts in $POSTS_DB
  cat <<EOF > index.html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>$BLOG_TITLE</title>
  <link rel="stylesheet" href="$STYLESHEET" />
</head>
<body>
  <header>
    <h1>A Series of Tubes</h1>
    <p>musty musings about interesting things</p>
  </header>
  <nav>
    <a href="index.html">Home</a>
    <a href="about.html">About</a>
    <a href="links.html">Links</a>
  </nav>
  <hr>
  <main>
    <h2>Latest Posts</h2>
    <div class="post-links">
EOF

  # If $POSTS_DB exists, let's list them from newest to oldest using tac (reverse cat)
  if [[ -f "$POSTS_DB" ]]; then
    tac "$POSTS_DB" | while IFS="|" read -r postfile date title blurb; do
      # Show date, post title (link to file), then the blurb
      echo "      <div style=\"margin-bottom: 1.5rem;\">" >> index.html
      echo "        <p><strong>[$date]</strong> <a href=\"$postfile\">$title</a></p>" >> index.html
      echo "        <p>$blurb</p>" >> index.html
      echo "      </div>" >> index.html
    done
  else
    # No posts yet
    echo "      <p>No posts yet!</p>" >> index.html
  fi

  cat <<EOF >> index.html
    </div>
  </main>
  <hr>
$(footer_html)
</body>
</html>
EOF

  echo "Updated index.html."
}

write_about_html() {
  # Overwrite about.html with new content from user input
  echo "Type your About page content. Press Ctrl+D when finished."
  CONTENT=$(cat)  # read all lines until Ctrl+D

  cat <<EOF > about.html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>About</title>
  <link rel="stylesheet" href="$STYLESHEET" />
</head>
<body>
  <header>
    <h1>About Me</h1>
  </header>
  <nav>
    <a href="index.html">Home</a>
    <a href="about.html">About</a>
    <a href="links.html">Links</a>
  </nav>
  <hr>
  <main>
    <p>$CONTENT</p>
  </main>
  <hr>
$(footer_html)
</body>
</html>
EOF

  echo "about.html updated."
}

write_links_html() {
  # Overwrite links.html with new content from user input
  echo "Type your links page content (example: <ul><li>Link</li></ul>). Press Ctrl+D when finished."
  CONTENT=$(cat)  # read all lines until Ctrl+D

  cat <<EOF > links.html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>Links</title>
  <link rel="stylesheet" href="$STYLESHEET" />
</head>
<body>
  <header>
    <h1>Useful Links</h1>
  </header>
  <nav>
    <a href="index.html">Home</a>
    <a href="about.html">About</a>
    <a href="links.html">Links</a>
  </nav>
  <hr>
  <main>
    $CONTENT
  </main>
  <hr>
$(footer_html)
</body>
</html>
EOF

  echo "links.html updated."
}

create_first_run_files() {
  # Called on the first run to create index.html, about.html, links.html, styles.css, plus your first blog post
  echo "=== Welcome to FreeBB! Creating initial files... ==="
  write_styles_css
  write_index_html

  # about.html initially not much content
  cat <<EOF > about.html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>About</title>
  <link rel="stylesheet" href="$STYLESHEET" />
</head>
<body>
  <header>
    <h1>About Me</h1>
  </header>
  <nav>
    <a href="index.html">Home</a>
    <a href="about.html">About</a>
    <a href="links.html">Links</a>
  </nav>
  <hr>
  <main>
    <p>This is the about page. Update it anytime with the menu!</p>
  </main>
  <hr>
$(footer_html)
</body>
</html>
EOF

  # links.html
  cat <<EOF > links.html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>Links</title>
  <link rel="stylesheet" href="$STYLESHEET" />
</head>
<body>
  <header>
    <h1>Useful Links</h1>
  </header>
  <nav>
    <a href="index.html">Home</a>
    <a href="about.html">About</a>
    <a href="links.html">Links</a>
  </nav>
  <hr>
  <main>
    <p>List your favorite links here!</p>
  </main>
  <hr>
$(footer_html)
</body>
</html>
EOF

  echo "Now let's create your first blog post!"
  create_new_post

  touch "$INIT_MARKER"
  echo "=== Initialization complete. ==="
}

create_new_post() {
  # Prompt user for post title
  read -rp "Enter post title: " POST_TITLE

  # Ask user to specify a filename (or we can auto-generate a filename from the title)
  FILENAME_DEFAULT=$(echo "$POST_TITLE" | tr ' ' '_' | tr '[:upper:]' '[:lower:]')
  read -rp "Enter filename for the post (e.g. ${FILENAME_DEFAULT}.html): " POST_FILE
  POST_FILE="${POST_FILE:-$FILENAME_DEFAULT.html}"

  echo "Type your post content. Use html tags like <p> and <ul> to format your post."
  echo "Keep in mind this is NOT a robust text editor, so it's best to keep formatting simple."
  echo "Press Ctrl+D when done."
  POST_CONTENT=$(cat)  # read until Ctrl+D

  # Short 256-character blurb
  echo "Enter a short (256 char or less) blurb about this post:"
  read -r BLURB
  # Truncate if needed
  BLURB="${BLURB:0:256}"

  # Build the post file
  cat <<EOF > "$POST_FILE"
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>$POST_TITLE</title>
  <link rel="stylesheet" href="$STYLESHEET" />
</head>
<body>
  <header>
    <h1>$POST_TITLE</h1>
  </header>
  <nav>
    <a href="index.html">Home</a>
    <a href="about.html">About</a>
    <a href="links.html">Links</a>
  </nav>
  <hr>
  <main>
$POST_CONTENT
  </main>
  <hr>
$(footer_html)
</body>
</html>
EOF

  echo "Post created: $POST_FILE"

  # Store metadata so we can build index page from it
  # We'll append a line: "postfile|date|title|blurb"
  DATE_PUB=$(today_date)
  echo "$POST_FILE|$DATE_PUB|$POST_TITLE|$BLURB" >> "$POSTS_DB"

  # Rebuild index
  write_index_html
}

# ----------------------------------------------------
# MAIN LOGIC
# ----------------------------------------------------

# If not initialized, run the first-run function
if [[ ! -f "$INIT_MARKER" ]]; then
  create_first_run_files
fi

# Show menu on subsequent runs
while true; do
  echo ""
  echo "==============================="
  echo "===         FreeBB          ==="
  echo "=== A Static Blog Generator ==="
  echo "===          v0.3           ==="
  echo "==============================="
  echo ""
  echo "1) Create a new blog post"
  echo "2) Update the about page"
  echo "3) Update the links page"
  echo "4) Rebuild index (in case you edited $POSTS_DB manually)"
  echo "0) Exit"
  read -rp "Enter your choice: " choice

  case "$choice" in
    1)
      create_new_post
      ;;
    2)
      write_about_html
      ;;
    3)
      write_links_html
      ;;
    4)
      write_index_html
      ;;
    0)
      echo "Exiting..."
      exit 0
      ;;
    *)
      echo "Invalid choice."
      ;;
  esac
done