# crossi-cnv
CNA analysis in HL patietns (Cedric)

# How to download this repo
`git clone https://github.com/aliciapalominomosquera/crossi-cnv.git`

# CNVkit
To run the CNVkit pipeline be sure to activate previously the cnvkit conda enviroment

`conda activate cnvkit`

`bash cnvkit-cedric.sh`

# ichorCNA
To run ichorCNA you need to activate different enviroments. 

1. First step is to create the off-target '.bam' and '.bai' files from the tumor samples and controls. Base enviroment.

  `ichorcna1-offtarget.sh`

  `ichorcna2-offtarget-controls.sh`

2. ACTIVATE hmmcopy enviroment. Create the '.wig' files from the 'off-target.bam' files of tumor and controls samples.

  `ichorcna3-wig.sh`

  `ichorcna4-wig-controls.sh`

3. ACTIVATE the cnvkit enviroment. Create the normal reference from controls wig files.  

  `ichorcna5-normal-ref.sh`

4. ACTIVATE the cnvkit enviroment. Run the final script to genereate the final ichorCNA output.

`ichorcna6-results.sh`

# Common use of git repo
One-time step of cloning the repo to your directory
`git clone git@github.com:aliciapalominomosquera/crossi-cnv.git`

Everyday sequence of git commands: 0. `git pull` (if you know what you're doing)
1. `git add myfile.py`
2. `git commit -m "Added new version of myfile.py"`
3. `git push`
