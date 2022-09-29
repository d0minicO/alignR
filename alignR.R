
alignR <- function(base="C:/Users/dowens/OneDrive/Postdoc/Projects/GID4/Paper/Bioinformatics/alignR/",
                   uniprot_IDs = NULL,
                   seqs = NULL,
                   n_seqs = NULL,
                   n = "alignR_p53",
                   printPDF=T){
  
  ## function for aligning two or more amino acid sequences in R
  ## uses biostrings and msa packages to do the alignment
  ## will save a pdf of the alignment if tinytex is installed and working
  
  ## inputs
  
  # base = character vector of the route directory to save output eg "/path/to/route/directory/"
  # uniprot_IDs = a character vector of uniprot IDs to align eg c("P04637","P02340","P10361") # leave it blank if you are manually inputting the sequences OR
  # seqs = character vector of custom amino acid sequences to align eg c("MEEPQSDPSV","MTAMEESQSD","MEDSQSDMSI") ## good for aligning shorter peptides or other sequences not on uniprot!
  # n_seqs = character vector of names of amino acid sequences in same order as the custom sequences eg c("P53_HUMAN","P53_MOUSE", "P53_RAT") ## not needed if uniprot IDs given, but can be supplied if a custom naming is preferred which will overwrite the uniprot default name
  # n = suffix name to give the outputs eg "p53" ("alignR_" will be appended to the start)
  
  
  ## outputs
  
  # alignDir = sub directory called "alignR_out/" that contains the alignments, within the base directory specified
  # alFile = a fasta file of the alignment that can be viewed in other software e.g. snapgene
  # texFile = a .tex file that can be used to view the alignment manually using texshade in latex
  # pdfFile = the output pdf alignment made using tinytex. If this file is missing then it is likely that tinytex is not working on your machine.
  # pidFile = text file containing the percent identify between the sequences. Only generated if number of sequences to align is 2.
  
  ## will always try to output a .tex file, and a .fasta file
  ## if printPDF = TRUE, and **tinytex is working** a pdf of the alignment will also be saved
  ## and if only two sequences have been aligned then a text file of the percentage identity between them will also be saved
  ## if having problems trying running with printPDF = F and see if .tex and fasta files output, in that case, it is likely an issue with tinytex. You can view the fasta alignment in snapgene!
  
  
  ##########################
  ## package requirements ##
  ##########################
  
  require(Biostrings)
  require(msa)
  require(tinytex)
  require(stringr)
  
  ############
  ## inputs ##
  ############
  
  # route directory
  #base = "C:/Users/dowens/OneDrive/Postdoc/Projects/GID4/Paper/Bioinformatics/alignR/"
  
  # OR the uniprot IDs of the sequences we want to align
  #uniprot_IDs = c("P04637","P02340","P10361")
  
  ## vector of input sequences to align
  #seqs = c("MEEPQSDPSV","MTAMEESQSD","MEDSQSDMSI")
  
  ## vector of names of the sequences (must be in same order as sequences above
  #n_seqs = c("P53_HUMAN","P53_MOUSE", "P53_RAT")
  
  # name of the alignment
  #n = "alignR_p53"
  
  
  
  #############
  ## outputs ##
  #############
  
  alignDir = paste0(base,"alignR_out/")
  dir.create(alignDir,showWarnings = F)
  
  alFile = paste0(alignDir,"alignR_",n,".fasta")
  texFile = paste0(alignDir,"alignR_",n,".tex")
  pdfFile = paste0(alignDir,"alignR_",n,".pdf")
  pidFile = paste0(alignDir,"percentageIdentity_",n,".txt")
  

  ######################
  ## WORK STARTS HERE ##
  ######################
  
  # quick logical check that sequences or uniprot ids were given
  if(is.null(uniprot_IDs) & is.null(seqs)){
    message("Must provide either uniprot IDs or sequences as characters \n")
    break
  }
  
  
  
  # if we're given uniprot IDs then use this for loop to pull the sequences
  # requires active internet connection
  if(!is.null(uniprot_IDs) & is.null(seqs)){
    
    message("Using provided uniprot IDs \n")
    
    seqs = c()
    for(id in uniprot_IDs){
      ### get the AA sequence from uniprot
      acc_url = paste0("https://www.uniprot.org/uniprot/",id,".fasta")
      info = read.csv(url(acc_url))
      temp_seq=paste0(info[,1],collapse="")
      
      # get the uniprot name by string splitting
      id_name=str_split(colnames(info), "\\.")[[1]][4]
      
      seqs[id_name] = temp_seq
    }
    

    
  } else if(is.null(uniprot_IDs) & !is.null(seqs)) {
    message("Using provided sequences \n")
    seqs = seqs
  }
  
  
  ## clean up the newlines from input sequences
  seqs = gsub("[\r\n]", "", seqs)
  
  ## if custom names were given, rename the sequences
  if(!is.null(n_seqs)){
    names(seqs) = n_seqs
  }
  
  # do the alignment
  aligned = msa(seqs,order="input",type = "protein")
  
  ## calculate percentage identity if only two sequences were aligned
  if (length(seqs)==2){
    
    p_aligned = pairwiseAlignment(seqs[1],seqs[2])
    perc_id = pid(p_aligned, type="PID1")
    
    write.table(perc_id,
                file=pidFile,
                quote=F,
                col.names = F,
                row.names = F)
  }
  
  
  
  # save the alignment in a way texshade can compile
  msaPrettyPrint(aligned,
                 alFile = alFile,
                 output="tex",
                 askForOverwrite=FALSE)
  
  
  ## save the tex file
  ### modify the display options as you please!
  #### easier if you know some latex and requires knowledge of texshade
  writeLines(c(
    "\\documentclass[preview]{standalone}",
    "\\usepackage{texshade}",
    "\\usepackage{inconsolata}",
    "\\usepackage{geometry}%[showframe]",
    
    "\\begin{document}",
    paste0("\\begin{texshade}{",alFile,"}"),
    # IDENTITY HIGHLIGHTING
    "\\shadingmode[allmatchspecial]{identical}",
    "\\nomatchresidues{Gray70}{White}{upper}{bf}",
    "\\conservedresidues{Black}{LightCyan}{upper}{bf}",
    "\\allmatchresidues{White}{Red}{upper}{bf}",
    
    # HIGHLIGHTING THRESHOLD
    "\\threshold[100]{50}",
    
    # LEGEND
    "\\showlegend",
    "\\movelegend{0cm}{0cm}",
    
    # TOP NUMBERING
    "\\showruler{1}{top}",
    #\\hidenumbering
    
    # CONSENSUS
    "\\showconsensus[ColdHot]{bottom}",
    "\\defconsensus{.}{lower}{upper}",
    
    # TEXT SIZE
    "\\namesfootnotesize",
    "\\residuesfootnotesize",
    "\\legendfootnotesize",
    "\\numberingtiny",
    
    # end document
    "\\end{texshade}",
    "\\end{document}"),
    texFile)
  
  
  if(printPDF){
    message("Printing the pdf for you now... \n")
    
    ## save pdf in current working directory
    ## cannot get it to output to base directory directly
    tools::texi2pdf(texFile, clean=TRUE)
    #rename the temp file to move it to the desired output folder
    pdf_file_temp = paste0("~/","alignR_",n,".pdf")
    file.rename(pdf_file_temp, pdfFile)
  }

  
}
  

  

  

  
  
  



