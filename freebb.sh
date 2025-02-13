#!/usr/bin/env bash
#
# FreeBB by benchly
# License: CC BY-NC-SA
# github: https://github.com/benchly/freebb
#
# FreeBB is a VERY simple static blog generator inspired by cfenellosa's superb bashblog.
# If you want a quick and dirty solution to crank out posts for a small blog, FreeBB
# can help.
#
# If you are looking for something more robust with better editing options and a 
# focus on addons like Discus or analytics, you want bashblog, so go check out the
# github here: https://github.com/cfenollosa/bashblog
#
# Usage:
#   1) Give permission:  chmod +x blog.sh
#   2) Run:             ./blog.sh
#
# On first run, creates index.html, about.html, links.html, styles.css, plus an initial blog post.
#
# On subsequent runs, prompts the user to create new posts or update pages.

# ----------------------------------------------------
# | LET'S GET STARTED                                |
# ----------------------------------------------------

# ANSI color codes for the script text/menu
RED="\e[31m"
GREEN="\e[32m"
YELLOW="\e[33m"
BLUE="\e[34m"
BOLD="\e[1m"
RESET="\e[0m"

# Metadata stuff
BLOG_TITLE="A Series of Tubes"
POSTS_DB="posts.txt"    
STYLESHEET="styles.css"

# This marker file tells FreeBB whether or not this is the first run. 
# WARNING: If this file is missing, the initial blog pages will be generated and
# any existing pages will be overwritten. 
INIT_MARKER=".initialized" 

# ----------------------------------------------------
# | CSS & DATE                                       |
# ----------------------------------------------------

# A simple way to write the CSS file. 
# Edit the CSS to your liking BEFORE you run the program for the first time.
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
  echo -e "${GREEN}Created/updated $STYLESHEET.${RESET}"
}

# You can change the date to a format you like.
today_date() {
  date +"%Y-%m-%d"
}

# ----------------------------------------------------
# FOOTER                                             |
# ----------------------------------------------------

# The footer is shared by all pages (called later during page creation).
# Keep that in mind when editing the footer content. 
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
# CREATE/UPDATE Index.html                           |
# ----------------------------------------------------

write_index_html() {
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

  # Use tac to list posts from newest to oldest
  if [[ -f "$POSTS_DB" ]]; then
    tac "$POSTS_DB" | while IFS="|" read -r postfile date title blurb; do
      # Show date, post title (link to file), then the blurb
      echo "      <div style=\"margin-bottom: 1.5rem;\">" >> index.html
      echo "        <p>[$date] - <a href=\"$postfile\">$title</a></p>" >> index.html
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

  echo -e "${GREEN}Updated index.html.${RESET}"
}

# ----------------------------------------------------
# OVERWRITE About.html or Links.html                 |
# ----------------------------------------------------

write_about_html() {
  # Overwrite about.html with new content from user input because I am not smart enough
  # to figure out how to allow the user to edit the current content. Open to suggestions.
  echo -e "${YELLOW}Type your About page content. Press Ctrl+D when finished.${RESET}"
  echo -e "${RED}Warning: existing content will be replaced by new content.${RESET}"
  echo -e "${YELLOW}If you just wish to edit existing content, better to do it in a text editor.${RESET}"
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

  echo -e "${GREEN}about.html updated.${RESET}"
}

write_links_html() {
  # Overwrite links.html with new content from user input - still not smart enough :) 
  echo -e "${YELLOW}Type your links page content (example: <ul><li>Link</li></ul>). Press Ctrl+D when finished.${RESET}"
  echo -e "${RED}Warning: existing content will be replaced by new content.${RESET}"
  echo -e "${YELLOW}If you just wish to edit existing content, better to do it in a text editor.${RESET}"
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

  echo -e "${GREEN}links.html updated.${RESET}"
}

# ----------------------------------------------------
# CREATE FIRST RUN FILES                             |
# ----------------------------------------------------

create_first_run_files() {
  # Called on the first run to create index.html, about.html, links.html, styles.css, plus your first blog post, giving you an initial blog structure to work with.
  echo -e "${BOLD}${BLUE}=== Welcome to FreeBB! Creating initial files... ===${RESET}"
  write_styles_css
  write_index_html

  # the initial about.html will be empty aside from header/footer
  # I recommend editing these with a text editor of your choice once created.
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

  # the initial links.html will be empty aside from header/footer
  # I recommend editing these with a text editor of your choice, once created.
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

  echo -e "${YELLOW}Now let's create your first blog post!${RESET}"
  create_new_post

  touch "$INIT_MARKER"
  echo -e "${GREEN}=== Initialization complete. ===${RESET}"
}

# ----------------------------------------------------
# CREATE FRESH BLOG POST                             |
# ----------------------------------------------------

create_new_post() {
  # Prompt user for post title
  read -rp "Enter post title: " POST_TITLE

  # Ask user to specify a filename (or we can auto-generate a filename from the title)
  FILENAME_DEFAULT=$(echo "$POST_TITLE" | tr ' ' '_' | tr '[:upper:]' '[:lower:]')
  read -rp "Enter filename for the post (e.g. ${FILENAME_DEFAULT}.html): " POST_FILE
  POST_FILE="${POST_FILE:-$FILENAME_DEFAULT.html}"

  echo -e "${YELLOW}Type your post content. Use html tags like <p> and <ul> to format your post.${RESET}"
  echo -e "${YELLOW}Keep in mind this is NOT a robust text editor, so it's best to keep formatting simple.${RESET}"
  echo -e "${YELLOW}Press Ctrl+D when done.${RESET}"
  POST_CONTENT=$(cat)  # read until Ctrl+D

  # Short 256-character blurb
  echo -e "${YELLOW}Enter a short (256 char or less) blurb about this post:${RESET}"
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

  echo -e "${GREEN}Post created: $POST_FILE ${GREEN}"

# Store data to build the index page
  DATE_PUB=$(today_date)
  echo "$POST_FILE|$DATE_PUB|$POST_TITLE|$BLURB" >> "$POSTS_DB"

  # Rebuild index
  write_index_html
}

# ----------------------------------------------------
# MENU LOGIC                                         |
# ----------------------------------------------------

# If not initialized, run the first-run function
if [[ ! -f "$INIT_MARKER" ]]; then
  create_first_run_files
fi

# Show menu on subsequent runs
while true; do
  echo ""
  echo -e "${BOLD}${BLUE}===============================${RESET}"
  echo -e "${BOLD}${BLUE}===         FreeBB          ===${RESET}"
  echo -e "${BOLD}${BLUE}=== A Static Blog Generator ===${RESET}"
  echo -e "${BOLD}${BLUE}===         v1.0.1          ===${RESET}"
  echo -e "${BOLD}${BLUE}===============================${RESET}"
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
      echo -e "${RED}Exiting...${RESET}"
      exit 0
      ;;
    *)
      echo -e "${RED}Invalid choice.${RESET}"
      ;;
  esac
done