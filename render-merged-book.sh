#!/bin/bash 

# first, enwiden but keep it safe in case i've done qqch
git stash _quarto.yml
cp _quarto-render-merged-book.yml _quarto.yml

# render the book with quarto
quarto render

# use chromeprint to pdf-ify each part
Rscript scripts/create-book-pdfs.R

# combine pdfs
system("pdftk _book/index.pdf _book/chapters/*.pdf _book/appendices/timeline.pdf _book/appendices/plays.pdf _book/appendices/people.pdf cat output merged-book.pdf")

# restore yml
git checkout _quarto.yml
git stash pop