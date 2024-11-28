#!/usr/bin/env Rscript

# this script renders the book to pdf, screw you latex

#quarto::quarto_render()


book_dir <- "_book"
chap_dir <- file.path(book_dir, "chapters")
img_dir <- file.path(book_dir, "img")
app_dir <- file.path(book_dir, "appendices")
site_libs <- file.path(book_dir, "site_libs")


# chrome_print options
options_list <- list(scale= 0.7, marginTop=0.1,marginBottom=0.1,marginLeft=0,marginRight=0)

fs::dir_copy(site_libs, file.path(app_dir, "site_libs"), overwrite = TRUE)
fs::dir_copy(site_libs, file.path(chap_dir, "site_libs"), overwrite = TRUE)
fs::dir_copy(img_dir,   file.path(chap_dir, "img"), overwrite = TRUE)

all_files <- c(
  "_book/index.html",
  list.files(chap_dir, pattern = "*\\.html", full.names = TRUE),
  list.files(app_dir, pattern = "*\\.html", full.names = TRUE)
)

all_files |>
  purrr::map(
    pagedown::chrome_print,
    options = options_list,
    timeout = 200
  )

system("pdftk _book/index.pdf _book/chapters/*.pdf _book/appendices/timeline.pdf _book/appendices/plays.pdf _book/appendices/people.pdf cat output merged-book.pdf")