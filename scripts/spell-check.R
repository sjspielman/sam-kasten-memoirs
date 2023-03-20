#!/usr/bin/env Rscript
#
# Run spell check and save results
# Adapted from: https://github.com/AlexsLemonade/refinebio-examples/blob/33cdeff66d57f9fe8ee4fcb5156aea4ac2dce07f/scripts/spell-check.R
# And then adapted from: https://github.com/AlexsLemonade/training-modules/blob/3f438fe5d497efc45af5f0ebda08fef5e15b909e/scripts/spell-check.R


# Find .git root directory
root_dir <- rprojroot::find_root(rprojroot::has_dir(".git"))

# Read in dictionary
dictionary <- readLines(file.path(root_dir, 'components', 'dictionary.txt'))

# The only files we want to check are Quarto (.qmd) and Markdown files
files <- list.files(pattern = '\\.(qmd|md)$', recursive = TRUE, full.names = TRUE)

# Remove the LICENSE from the spell check
files <- grep('LICENSE.md', files, invert = TRUE, value = TRUE)

# Run spell check
spelling_errors <- spelling::spell_check_files(files, ignore = dictionary) |>
  data.frame() |>
  tidyr::unnest(cols = found) |>
  tidyr::separate(found, into = c("file", "lines"), sep = ":")

# Print out how many spell check errors
write(nrow(spelling_errors), stdout())

# Save spell errors to file temporarily
readr::write_tsv(spelling_errors, 'spell_check_errors.tsv')
