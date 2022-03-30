# script for testing different usages of alignR

# load the function from github
devtools::source_url("https://github.com/d0minicO/alignR/blob/main/alignR.R?raw=TRUE")

## using uniprot ID to get sequences to align
alignR(
  base="C:/Users/dowens/OneDrive/Postdoc/Projects/GID4/Paper/Bioinformatics/alignR/testing/",
  uniprot_IDs = c("P04637","P02340","P10361"),
  n = "p53")



## manually providing a short sequence as well as names
alignR(
  base="C:/Users/dowens/OneDrive/Postdoc/Projects/GID4/Paper/Bioinformatics/alignR/testing/",
  seqs = c("MEEPQSDPSV","MTAMEESQSD","MEDSQSDMSI"),
  n_seqs = c("P53_HUMAN_frag","P53_MOUSE_frag", "P53_RAT_frag"),
  n = "p53_frags")


## manually providing two short sequences as well as names, which will output a percent identity
alignR(
  base="C:/Users/dowens/OneDrive/Postdoc/Projects/GID4/Paper/Bioinformatics/alignR/testing/",
  seqs = c("MEEPQSDPSV","MTAMEESQSD"),
  n_seqs = c("P53_HUMAN_frag","P53_MOUSE_frag"),
  n = "p53_frags_percID")



## manually providing two short sequences as well as names, which will output a percent identity
alignR(
  base="C:/Users/dowens/OneDrive/Postdoc/Projects/GID4/Paper/Bioinformatics/alignR/testing/",
  seqs = c("MEEPQSDPSV","MTAMEESQSD"),
  n_seqs = c("P53_HUMAN_frag","P53_MOUSE_frag"),
  n = "p53_frags_percID")



## Not outputting pdf
alignR(
  base="C:/Users/dowens/OneDrive/Postdoc/Projects/GID4/Paper/Bioinformatics/alignR/testing/",
  seqs = c("MEEPQSDPSV","MTAMEESQSD","MEDSQSDMSI"),
  n_seqs = c("P53_HUMAN_frag","P53_MOUSE_frag", "P53_RAT_frag"),
  n = "p53_frags_noPDF",
  printPDF = F)


  

  

  
  
  



