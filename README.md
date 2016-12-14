BaySec Website Source
=====================

Source to build the BaySec website.

Instructions
============

1. Clone this repository: git clone git@github.com:baysec/baysec.git
2. Clone this repository a second time in a special directory: git clone git@github.com:baysec/baysec.git baysec.gh-pages
3. Switch the second one to the correct branch: (cd baysec.gh-pages && git checkout gh-pages)
4. Publish the site: (cd baysec && hyde gen && hyde publish)
5. Push the new site: (cd baysec.gh-pages && git push)
