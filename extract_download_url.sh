# Make a GET request and store the JSON response in a variable
response=$(curl -s "https://api.github.com/repos/libreddit/libreddit/releases/latest")

# Extract all browser_download_urls using regex
download_urls=$(echo "$response" | grep -o -E "https://github.com/libreddit/libreddit/releases/download/[^/]+/libreddit")

# Select a single URL from the matches
selected_url=$(echo "$download_urls" | head -n 1)

# Print the selected download URL
echo "Download URL: $selected_url"

curl -LO $selected_url