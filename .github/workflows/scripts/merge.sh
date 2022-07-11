# Get the current commit hash so we can compare later
oldCommit=$(git log --pretty=format:'%h' -n 1)

# Set username and email vars
git config --global user.name $GHUSER
git config --global user.email $GHEMAIL
git pull --unshallow  # this option is very important, you would get
                      # complains about unrelated histories without it.
                      # (but actions/checkout@v2 can also be instructed
                      # to fetch all git depth right from the start)
# Set the upstream repo, fetch, merge, and push
git remote add upstream https://github.com/froggleston/freqtrade-frogtrade9000
git fetch upstream
git merge upstream/main
git push origin main
# Get the new commit hash to compare
newCommit=$(git log --pretty=format:'%h' -n 1)
# Delete the next 3 lines if you don't have any other forks.
# Rename "short" if you do
#git checkout short
#git merge upstream/main
#git push origin short

#git checkout swing
#git merge upstream/main
#git push origin swing

if [[ "$oldCommit" == "$newCommit" ]]
then
  echo Commit $newCommit is unchanged!!!
  exit
fi

if [[ "$oldCommit" != "$newCommit" ]]
then
  echo Commit is updated!!! New commit hash is $newCommit
  git clone https://github.com/clutch70/pushover
  cd pushover
  echo $POTOKEN > pushover_api
  python3 pushover.py --title "Frogtrade Fork Updated" --message "GH workflows have automatically merged upstream Frogtrade changes to the CN fork." --priority -1 --userAddress $POUSER
  exit
fi