#!/bin/bash
echo "Installing VS Code extensions..."
for i in `cat ./extensions.txt`
do
    code --install-extension $i
done
echo "Done."