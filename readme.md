Simple HTML Analysis
=======
Parses HTML files indexed by a CSV file and generates XPATH-like expressions for each element.

Assumes that the files are in a moodle type structure, i.e:

filename: `a6deac9f5e6e9b17c1dd1013288078837680e601` - a hash of the file
at path `a6/de/a6deac9f5e6e9b17c1dd1013288078837680e601`


Running
---

    git clone https://github.com/ryangadams/simple-html-analysis.git
    cd simple-html-analysis
    gem install bundler
    bundle install
    ./analyse.rb 