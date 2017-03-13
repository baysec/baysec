BaySec Website Source
=====================

Source to build the BaySec website.

This is now hosted on AWS CloudFront + S3.  The move off github pages
was required due to the lack of SSL support for custom domains.

Instructions
============

1. Clone this repository: git clone git@github.com:baysec/baysec.git
2. Change directory in the cloned repo: cd baysec
3. Make sure deploy directory is clean: rm -rf deploy
4. Generate new content: hyde gen
5. Make sure AWS keys are in environment: . ./.key.txt
6. Publish to S3: hyde publish
