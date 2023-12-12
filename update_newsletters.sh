#!/bin/fish

cp -r ../tridactyl/doc/newsletters content/

# NB - need to stick to "Tridactyl news: season / year"

for f in content/newsletters/*.md
    cd ../tridactyl/doc/newsletters
    set creationtime (git log --format=%aD --date=iso (basename $f) | tail -1)
    cd -
    sed -i 's|^\# Tridactyl news - \(.*\)|---\ntitle: "\1"\ndate: "'$creationtime'"\ndraft: false\n---\n|g' $f
end

# run this in the tips and tricks directory. i mean it doesn't work but maybe it will make you feel productive
# for f in *.md; cd ../../../../tridactyl/doc/newsletters/tips-and-tricks/; set creationtime (git log --format=%aD --date=iso (basename $f) | tail -1); cd -;  sed -i 's|^\# Tridactyl \(.*\)|---\ntitle: "\1"\ndate: "'$creationtime'"\ndraft: false\n---\n|g' $f; end
