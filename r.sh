#!/bin/bash

# Set your OLD email that you previously used in commits
OLD_EMAIL="code.maestro64@gmail.com"

# Get the currently configured name and email from local repo
NEW_NAME=$(git config user.name)
NEW_EMAIL=$(git config user.email)

if [ -z "$NEW_NAME" ] || [ -z "$NEW_EMAIL" ]; then
  echo "❌ Git user.name or user.email not set. Please configure it using:"
  echo "   git config user.name 'Your Name'"
  echo "   git config user.email 'your@email.com'"
  exit 1
fi

echo "🔁 Rewriting history:"
echo "   Replacing author: $OLD_EMAIL"
echo "        with name: $NEW_NAME"
echo "             email: $NEW_EMAIL"
echo

read -p "Proceed? (y/N): " confirm
if [[ "$confirm" != "y" ]]; then
  echo "Aborted."
  exit 0
fi

git filter-branch --env-filter "
if [ \"\$GIT_COMMITTER_EMAIL\" = \"$OLD_EMAIL\" ]
then
    export GIT_COMMITTER_NAME=\"$NEW_NAME\"
    export GIT_COMMITTER_EMAIL=\"$NEW_EMAIL\"
fi
if [ \"\$GIT_AUTHOR_EMAIL\" = \"$OLD_EMAIL\" ]
then
    export GIT_AUTHOR_NAME=\"$NEW_NAME\"
    export GIT_AUTHOR_EMAIL=\"$NEW_EMAIL\"
fi
" --tag-name-filter cat -- --branches --tags

echo "✅ Done. Don't forget to force-push if needed:"
echo "   git push --force --all"
echo "   git push --force --tags"
