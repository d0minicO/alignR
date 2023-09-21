# alignR
## _Multiple sequence alignment tool for aligning protein sequences in R_

alignR is a custom R function that takes uniprot IDs or custom sequences and outputs a nicely formatted pdf for each gene showing a pretty alignment of the amino acid sequences ([![example output](https://ibb.co/RYNdk5r)](https://github.com/d0minicO/alignR/blob/main/examples_output/p53_example.PNG))

---
# Install
### Part 1 -- install package dependencies if you have not already got them
```sh
if (!requireNamespace("BiocManager", quietly = TRUE))
    install.packages("BiocManager")
BiocManager::install("msa")
BiocManager::install("Biostrings")
install.packages("stringr")
```
### Part 2 -- source unicoRn from github
```sh
devtools::source_url("https://github.com/d0minicO/alignR/blob/main/alignR.R?raw=TRUE")
```

# Arguments
- base = character vector of the route directory to save output eg "/path/to/route/directory/"
- uniprot_IDs = a character vector of uniprot IDs to align eg c("P04637","P02340","P10361") # leave it blank if you are manually inputting the sequences OR
- seqs = character vector of custom amino acid sequences to align eg c("MEEPQSDPSV","MTAMEESQSD","MEDSQSDMSI") ## good for aligning shorter peptides or other sequences not on uniprot!
- n_seqs = character vector of names of amino acid sequences in same order as the custom sequences eg c("P53_HUMAN_frag","P53_MOUSE_frag", "P53_RAT_frag") ## not needed if uniprot IDs given, but can be supplied if a custom naming is preferred which will overwrite the uniprot default name
- n = suffix name to give the outputs eg "p53" ("alignR_" will be appended to the start, so output files will look like "alignR_p53")

# Outputs
- alignDir = sub directory called "alignR_out/" that contains the alignments, within the base directory specified
- alFile = a fasta file of the alignment that can be viewed in other software e.g. snapgene
- texFile = a .tex file that can be used to view the alignment manually using texshade in latex
- pdfFile = the output pdf alignment compiled using tinytex. If the pdf file is missing then it is likely that tinytex is not working on your machine. It is a bit tricky to get it to work. See help below for more information.
- pidFile = text file containing the percent identify between the sequences. Only generated if number of sequences to align is 2.



# Example usage

load the function from github
```sh
devtools::source_url("https://github.com/d0minicO/alignR/blob/main/alignR.R?raw=TRUE")
```

using uniprot ID to get sequences to align
```sh
alignR(
  base="C:/Users/dowens/OneDrive/Postdoc/Projects/GID4/Paper/Bioinformatics/alignR/testing/",
  uniprot_IDs = c("P04637","P02340","P10361"),
  n = "p53")
```


manually providing a short sequence as well as names
```sh
alignR(
  base="C:/Users/dowens/OneDrive/Postdoc/Projects/GID4/Paper/Bioinformatics/alignR/testing/",
  seqs = c("MEEPQSDPSV","MTAMEESQSD","MEDSQSDMSI"),
  n_seqs = c("P53_HUMAN_frag","P53_MOUSE_frag", "P53_RAT_frag"),
  n = "p53_frags")
```

manually providing two short sequences as well as names, which will output a percent identity
```sh
alignR(
  base="C:/Users/dowens/OneDrive/Postdoc/Projects/GID4/Paper/Bioinformatics/alignR/testing/",
  seqs = c("MEEPQSDPSV","MTAMEESQSD"),
  n_seqs = c("P53_HUMAN_frag","P53_MOUSE_frag"),
  n = "p53_frags_percID")
```


manually providing two short sequences as well as names, which will output a percent identity
```sh
alignR(
  base="C:/Users/dowens/OneDrive/Postdoc/Projects/GID4/Paper/Bioinformatics/alignR/testing/",
  seqs = c("MEEPQSDPSV","MTAMEESQSD"),
  n_seqs = c("P53_HUMAN_frag","P53_MOUSE_frag"),
  n = "p53_frags_percID")
```

Same as above, outputting pdf
```sh
alignR(
  base="C:/Users/dowens/OneDrive/Postdoc/Projects/GID4/Paper/Bioinformatics/alignR/testing/",
  seqs = c("MEEPQSDPSV","MTAMEESQSD","MEDSQSDMSI"),
  n_seqs = c("P53_HUMAN_frag","P53_MOUSE_frag", "P53_RAT_frag"),
  n = "p53_frags_noPDF",
  printPDF = F)
```

# Output
([![Example image](https://ibb.co/RYNdk5r)](https://github.com/d0minicO/alignR/blob/main/examples_output/p53_example.PNG))

See https://github.com/d0minicO/alignR/tree/main/examples_output/ for examples of the .fasta alignment, .tex file, and alignment.pdf generated with the above examples

---

# How does it work?

The package msa (https://bioconductor.org/packages/release/bioc/html/msa.html) is used to generate a multiple sequence alignment. The alignment is saved (.fasta format) and a custom .tex file is created utilising the texshade package (https://www.ctan.org/pkg/texshade) inspired by this example (https://www.overleaf.com/latex/templates/standalone-msa-figure/rbgrxrmctccc). Finally, the tinytex implimentation of latex (https://www.rdocumentation.org/packages/tinytex/versions/0.32) is used to compile and save a pdf of the alignment.

---

# Limitations

A limitation of this function is that tinytex can be difficult to get to work with RStudio. I had a lot of problems. A workaround is to set printPDF=FALSE and then use snapgene to view the .fasta alignment file. This is acceptable but not as pretty and less compatible with figure making.


---

# Troubleshooting

dominic.owens@utoronto.ca

## Tinytex
Latex must be installed and communicating properly with R in order to compile and save the pdf. Tinytex (https://www.rdocumentation.org/packages/tinytex/versions/0.32) should be a fairly straightforward way to get Rstudio and latex to communicate. If the pdf output step fails then it is likely that Rstudio is not able to communicate properly with tinytex/latex. You can set printPDF=FALSE try testing out the following code to see where the problem lies

```sh
## See if tinytex can compile this basic test pdf
writeLines(c(
   '\\documentclass{article}',
   '\\begin{document}',
   "Help, get it to work!",
   '\\end{document}'
 ), "test.tex")
tinytex::pdflatex("test.tex")

# now test if tinytex can properly use texshade
## first make an example alignment file
writeLines(c(
  ">DDX21_Human",
  "MPGKLRSDAG--",
  ">DDX21_Mouse",
  "MPGKLRSGAK--",
  ">DDX21_Dog",
  "MPGKLLSDAG--",
  ">DDX21_Zebrafish",
  "--EKWQDSRRWT"),
  "example.fasta")

## then write a minimal .tex file
writeLines(c(
  '\\documentclass{article}',
  "\\usepackage{texshade}",
  '\\begin{document}',
  "\\begin{texshade}",
  "{example.fasta}",
  "\\end{texshade}",
  '\\end{document}'
), "example.tex")

# test out compiling
tinytex::pdflatex("example.tex")

## if this doesn't work try this method to compile instead
## This is what alignR actually uses as tinytex::pdflatex did not work for me
tools::texi2pdf("example.tex", clean=TRUE)
```

If these didn't both work, then you will have to keep trying make sure tinytex and texshade are properly installed

```sh
# reinstall the tinytex package
install.packages("tinytex")
library(tinytex)

# install the full version of the package
tinytex:::install_prebuilt('TinyTeX')

# list installed packages available to tinytex
# check that "texshade" is listed
tl_pkgs()

# install a lot of the additional common packages
tinytex:::install_yihui_pkgs()

# force installation of texshade
tlmgr_install("texshade")

# If having problems use this to try to get more informative error messages
options(tinytex.verbose = TRUE)

## Alternative way to install tinytex with texshade
install_tinytex(
  force = FALSE,
  dir = "auto",
  version = "daily",
  repository = "ctan",
  extra_packages = "texshade",
  add_path = TRUE
)
```

For more help with tinytex/latex issues check out the developer's debugging instructions (https://yihui.org/tinytex/r/#debugging)
