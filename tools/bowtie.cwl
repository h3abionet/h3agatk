#!/usr/bin/env cwl-runner
cwlVersion: "v1.0"
class: CommandLineTool
doc: |
  bowtie.cwl is developed for CWL consortium

  Usage: 
  bowtie [options]* <ebwt> {-1 <m1> -2 <m2> | --12 <r> | <s>} [<hit>]

    <m1>    Comma-separated list of files containing upstream mates (or the
            sequences themselves, if -c is set) paired with mates in <m2>
    <m2>    Comma-separated list of files containing downstream mates (or the
            sequences themselves if -c is set) paired with mates in <m1>
    <r>     Comma-separated list of files containing Crossbow-style reads.  Can be
            a mixture of paired and unpaired.  Specify "-"for stdin.
    <s>     Comma-separated list of files containing unpaired reads, or the
            sequences themselves, if -c is set.  Specify "-"for stdin.
    <hit>   File to write hits to (default: stdout)
  Input:
    -q                 query input files are FASTQ .fq/.fastq (default)
    -f                 query input files are (multi-)FASTA .fa/.mfa
    -r                 query input files are raw one-sequence-per-line
    -c                 query sequences given on cmd line (as <mates>, <singles>)
    -C                 reads and index are in colorspace
    -Q/--quals <file>  QV file(s) corresponding to CSFASTA inputs; use with -f -C
    --Q1/--Q2 <file>   same as -Q, but for mate files 1 and 2 respectively
    -s/--skip <int>    skip the first <int> reads/pairs in the input
    -u/--qupto <int>   stop after first <int> reads/pairs (excl. skipped reads)
    -5/--trim5 <int>   trim <int> bases from 5' (left) end of reads
    -3/--trim3 <int>   trim <int> bases from 3' (right) end of reads
    --phred33-quals    input quals are Phred+33 (default)
    --phred64-quals    input quals are Phred+64 (same as --solexa1.3-quals)
    --solexa-quals     input quals are from GA Pipeline ver. < 1.3
    --solexa1.3-quals  input quals are from GA Pipeline ver. >= 1.3
    --integer-quals    qualities are given as space-separated integers (not ASCII)
    --large-index      force usage of a 'large' index, even if a small one is present
  Alignment:
    -v <int>           report end-to-end hits w/ <=v mismatches; ignore qualities
      or
    -n/--seedmms <int> max mismatches in seed (can be 0-3, default: -n 2)
    -e/--maqerr <int>  max sum of mismatch quals across alignment for -n (def: 70)
    -l/--seedlen <int> seed length for -n (default: 28)
    --nomaqround       disable Maq-like quality rounding for -n (nearest 10 <= 30)
    -I/--minins <int>  minimum insert size for paired-end alignment (default: 0)
    -X/--maxins <int>  maximum insert size for paired-end alignment (default: 250)
    --fr/--rf/--ff     -1, -2 mates align fw/rev, rev/fw, fw/fw (default: --fr)
    --nofw/--norc      do not align to forward/reverse-complement reference strand
    --maxbts <int>     max # backtracks for -n 2/3 (default: 125, 800 for --best)
    --pairtries <int>  max # attempts to find mate for anchor hit (default: 100)
    -y/--tryhard       try hard to find valid alignments, at the expense of speed
    --chunkmbs <int>   max megabytes of RAM for best-first search frames (def: 64)
  Reporting:
    -k <int>           report up to <int> good alignments per read (default: 1)
    -a/--all           report all alignments per read (much slower than low -k)
    -m <int>           suppress all alignments if > <int> exist (def: no limit)
    -M <int>           like -m, but reports 1 random hit (MAPQ=0); requires --best
    --best             hits guaranteed best stratum; ties broken by quality
    --strata           hits in sub-optimal strata aren't reported (requires --best)
  Output:
    -t/--time          print wall-clock time taken by search phases
    -B/--offbase <int> leftmost ref offset = <int> in bowtie output (default: 0)
    --quiet            print nothing but the alignments
    --refout           write alignments to files refXXXXX.map, 1 map per reference
    --refidx           refer to ref. seqs by 0-based index rather than name
    --al <fname>       write aligned reads/pairs to file(s) <fname>
    --un <fname>       write unaligned reads/pairs to file(s) <fname>
    --max <fname>      write reads/pairs over -m limit to file(s) <fname>
    --suppress <cols>  suppresses given columns (comma-delim'ed) in default output
    --fullref          write entire ref name (default: only up to 1st space)
  Colorspace:
    --snpphred <int>   Phred penalty for SNP when decoding colorspace (def: 30)
       or
    --snpfrac <dec>    approx. fraction of SNP bases (e.g. 0.001); sets --snpphred
    --col-cseq         print aligned colorspace seqs as colors, not decoded bases
    --col-cqual        print original colorspace quals, not decoded quals
    --col-keepends     keep nucleotides at extreme ends of decoded alignment
  SAM:
    -S/--sam           write hits in SAM format
    --mapq <int>       default mapping quality (MAPQ) to print for SAM alignments
    --sam-nohead       supppress header lines (starting with @) for SAM output
    --sam-nosq         supppress @SQ header lines for SAM output
    --sam-RG <text>    add <text> (usually "lab=value") to @RG line of SAM header
  Performance:
    -o/--offrate <int> override offrate of index; must be >= index's offrate
    -p/--threads <int> number of alignment threads to launch (default: 1)
    --mm               use memory-mapped I/O for index; many 'bowtie's can share
    --shmem            use shared mem for index; many 'bowtie's can share
  Other:
    --seed <int>       seed for random number generator
    --verbose          verbose output (for debugging)
    --version          print version information and quit
    -h/--help          print this usage message
requirements:
- $import: envvar-global.yml
- class: InlineJavascriptRequirement
- class: ShellCommandRequirement
- class: DockerRequirement
  #dockerImageId: scidap/bowtie:v1.1.2 #not yet ready
  dockerPull: scidap/bowtie:v1.1.2
  dockerFile: |
    #################################################################
    # Dockerfile
    #
    # Software:         bowtie
    # Software Version: 1.1.2
    # Description:      Bowtie image for SciDAP
    # Website:          http://bowtie-bio.sourceforge.net, http://scidap.com/
    # Provides:         bowtie
    # Base Image:       scidap/scidap:v0.0.1
    # Build Cmd:        docker build --rm -t scidap/bowtie:v1.1.2 .
    # Pull Cmd:         docker pull scidap/bowtie:v1.1.2
    # Run Cmd:          docker run --rm scidap/bowtie:v1.1.2 bowtie
    #################################################################

    ### Base Image
    FROM scidap/scidap:v0.0.1
    MAINTAINER Andrey V Kartashov "porter@porter.st"
    ENV DEBIAN_FRONTEND noninteractive

    ################## BEGIN INSTALLATION ######################

    WORKDIR /tmp

    ### Installing bowtie

    ENV VERSION 1.1.2
    ENV NAME bowtie
    ENV URL "https://github.com/BenLangmead/bowtie/archive/v${VERSION}.tar.gz"

    RUN wget -q -O - $URL | tar -zxv && \
        cd ${NAME}-${VERSION} && \
        make -j 4 && \
        cd .. && \
        cp ./${NAME}-${VERSION}/${NAME} /usr/local/bin/ && \
        cp ./${NAME}-${VERSION}/${NAME}-* /usr/local/bin/ && \
        strip /usr/local/bin/*; true && \
        rm -rf ./${NAME}-${VERSION}/

inputs:
  ebwt:
    doc: |
      The basename of the index to be searched. The basename is the name of any of the index files up to but not including the final .1.ebwt / .rev.1.ebwt / etc. bowtie looks for the specified index first in the current directory, then in the indexes subdirectory under the directory where the bowtie executable is located, then looks in the directory specified in the BOWTIE_INDEXES environment variable.
    type: string
    inputBinding:
      position: 8

  filelist:
    doc: |
      {-1 <m1> -2 <m2> | --12 <r> | <s>}
      <m1>    Comma-separated list of files containing upstream mates (or the
            sequences themselves, if -c is set) paired with mates in <m2>
      <m2>    Comma-separated list of files containing downstream mates (or the
            sequences themselves if -c is set) paired with mates in <m1>
      <r>     Comma-separated list of files containing Crossbow-style reads.  Can be
            a mixture of paired and unpaired.  Specify "-"for stdin.
      <s>     Comma-separated list of files containing unpaired reads, or the
            sequences themselves, if -c is set.  Specify "-"for stdin.
    type:
      type: array
      items: File
    inputBinding:
      itemSeparator: ","
      position: 9

  filelist_mates:
    type: File[]?
    inputBinding:
      itemSeparator: ","
      position: 10

  filename:
    type: string
    inputBinding:
      position: 11

  q:
    doc: |
      query input files are FASTQ .fq/.fastq (default)
    type: boolean?
    inputBinding:
      position: 1
      prefix: '-q'

  f:
    doc: |
      query input files are (multi-)FASTA .fa/.mfa
    type: boolean?
    inputBinding:
      position: 1
      prefix: '-f'

  r:
    doc: |
      query input files are raw one-sequence-per-line
    type: boolean?
    inputBinding:
      position: 1
      prefix: '-r'

  c:
    doc: |
      query sequences given on cmd line (as <mates>, <singles>)
    type: boolean?
    inputBinding:
      position: 1
      prefix: '-c'

  C:
    doc: |
      reads and index are in colorspace
    type: boolean?
    inputBinding:
      position: 1
      prefix: '-C'
  Q:
    doc: |
      --quals <file>  QV file(s) corresponding to CSFASTA inputs; use with -f -C
    type: File?
    inputBinding:
      position: 1
      prefix: '-Q'
  Q1:
    doc: |
      --Q2 <file>   same as -Q, but for mate files 1 and 2 respectively
    type: boolean?
    inputBinding:
      position: 1
      prefix: '--Q1'
  s:
    doc: |
      --skip <int>    skip the first <int> reads/pairs in the input
    type: int?
    inputBinding:
      position: 1
      prefix: '-s'
  u:
    doc: |
      --qupto <int>   stop after first <int> reads/pairs (excl. skipped reads)
    type: int?
    inputBinding:
      position: 1
      prefix: '-u'
  '5':
    doc: |
      --trim5 <int>   trim <int> bases from 5' (left) end of reads
    type: int?
    inputBinding:
      position: 1
      prefix: '-5'
  '3':
    doc: |
      --trim3 <int>   trim <int> bases from 3' (right) end of reads
    type: int?
    inputBinding:
      position: 1
      prefix: '-3'
  phred33-quals:
    doc: |
      input quals are Phred+33 (default)
    type: boolean?
    inputBinding:
      position: 1
      prefix: '--phred33-quals'
  phred64-quals:
    doc: |
      input quals are Phred+64 (same as --solexa1.3-quals)
    type: boolean?
    inputBinding:
      position: 1
      prefix: '--phred64-quals'
  solexa-quals:
    doc: |
      input quals are from GA Pipeline ver. < 1.3
    type: boolean?
    inputBinding:
      position: 1
      prefix: '--solexa-quals'
  solexa1.3-quals:
    doc: |
      input quals are from GA Pipeline ver. >= 1.3
    type: boolean?
    inputBinding:
      position: 1
      prefix: '--solexa1.3-quals'
  integer-quals:
    doc: |
      qualities are given as space-separated integers (not ASCII)
    type: boolean?
    inputBinding:
      position: 1
      prefix: '--integer-quals'
  large-index:
    doc: |
      force usage of a 'large' index, even if a small one is present
      Alignment:
    type: boolean?
    inputBinding:
      position: 1
      prefix: '--large-index'
  v:
    doc: |
      <int>           report end-to-end hits w/ <=v mismatches; ignore qualities
      or
    type: int?
    inputBinding:
      position: 1
      prefix: '-v'
  n:
    doc: |
      --seedmms <int> max mismatches in seed (can be 0-3, default: -n 2)
    type: int?
    inputBinding:
      position: 1
      prefix: '-n'
  e:
    doc: |
      --maqerr <int>  max sum of mismatch quals across alignment for -n (def: 70)
    type: int?
    inputBinding:
      position: 1
      prefix: '-e'
  l:
    doc: |
      --seedlen <int> seed length for -n (default: 28)
    type: int?
    inputBinding:
      position: 1
      prefix: '-l'
  nomaqround:
    doc: |
      disable Maq-like quality rounding for -n (nearest 10 <= 30)
    type: boolean?
    inputBinding:
      position: 1
      prefix: '--nomaqround'
  I:
    doc: |
      --minins <int>  minimum insert size for paired-end alignment (default: 0)
    type: int?
    inputBinding:
      position: 1
      prefix: '-I'
  X:
    doc: |
      --maxins <int>  maximum insert size for paired-end alignment (default: 250)
    type: int?
    inputBinding:
      position: 1
      prefix: '-X'
  fr:
    doc: |
      --rf/--ff     -1, -2 mates align fw/rev, rev/fw, fw/fw (default: --fr)
    type: boolean?
    inputBinding:
      position: 1
      prefix: '--fr'
  nofw:
    doc: |
      --norc      do not align to forward/reverse-complement reference strand
    type: boolean?
    inputBinding:
      position: 1
      prefix: '--nofw'
  maxbts:
    doc: |
      <int>     max # backtracks for -n 2/3 (default: 125, 800 for --best)
    type: int?
    inputBinding:
      position: 1
      prefix: '--maxbts'
  pairtries:
    doc: |
      <int>  max # attempts to find mate for anchor hit (default: 100)
    type: int?
    inputBinding:
      position: 1
      prefix: '--pairtries'
  y:
    doc: |
      --tryhard       try hard to find valid alignments, at the expense of speed
    type: boolean?
    inputBinding:
      position: 1
      prefix: '-y'
  chunkmbs:
    doc: |
      <int>   max megabytes of RAM for best-first search frames (def: 64)
      Reporting:
    type: int?
    inputBinding:
      position: 1
      prefix: '--chunkmbs'
  k:
    doc: |
      <int>           report up to <int> good alignments per read (default: 1)
    type: int?
    inputBinding:
      position: 1
      prefix: '-k'
  a:
    doc: |
      --all           report all alignments per read (much slower than low -k)
    type: boolean?
    inputBinding:
      position: 1
      prefix: '-a'
  m:
    doc: |
      <int>           suppress all alignments if > <int> exist (def: no limit)
    type: int?
    inputBinding:
      position: 1
      prefix: '-m'
  M:
    doc: |
      <int>           like -m, but reports 1 random hit (MAPQ=0); requires --best
    type: int?
    inputBinding:
      position: 1
      prefix: '-M'
  best:
    doc: |
      hits guaranteed best stratum; ties broken by quality
    type: boolean?
    inputBinding:
      position: 1
      prefix: '--best'
  strata:
    doc: |
      hits in sub-optimal strata aren't reported (requires --best)
      Output:
    type: boolean?
    inputBinding:
      position: 1
      prefix: '--strata'
  t:
    doc: |
      --time          print wall-clock time taken by search phases
    type: boolean?
    inputBinding:
      position: 1
      prefix: '-t'
  B:
    doc: |
      --offbase <int> leftmost ref offset = <int> in bowtie output (default: 0)
    type: int?
    inputBinding:
      position: 1
      prefix: '-B'
  quiet:
    doc: |
      print nothing but the alignments
    type: boolean?
    inputBinding:
      position: 1
      prefix: '--quiet'
  refout:
    doc: |
      write alignments to files refXXXXX.map, 1 map per reference
    type: boolean?
    inputBinding:
      position: 1
      prefix: '--refout'
  refidx:
    doc: |
      refer to ref. seqs by 0-based index rather than name
    type: boolean?
    inputBinding:
      position: 1
      prefix: '--refidx'
  al:
    doc: |
      <fname>       write aligned reads/pairs to file(s) <fname>
    type: boolean?
    inputBinding:
      position: 1
      prefix: '--al'
  un:
    doc: |
      <fname>       write unaligned reads/pairs to file(s) <fname>
    type: boolean?
    inputBinding:
      position: 1
      prefix: '--un'
  max:
    doc: |
      <fname>      write reads/pairs over -m limit to file(s) <fname>
    type: boolean?
    inputBinding:
      position: 1
      prefix: '--max'
  suppress:
    doc: |
      <cols>  suppresses given columns (comma-delim'ed) in default output
    type: boolean?
    inputBinding:
      position: 1
      prefix: '--suppress'
  fullref:
    doc: |
      write entire ref name (default: only up to 1st space)
      Colorspace:
    type: boolean?
    inputBinding:
      position: 1
      prefix: '--fullref'
  snpphred:
    doc: |
      <int>   Phred penalty for SNP when decoding colorspace (def: 30)
      or
    type: int?
    inputBinding:
      position: 1
      prefix: '--snpphred'
  snpfrac:
    doc: |
      <dec>    approx. fraction of SNP bases (e.g. 0.001); sets --snpphred
    type: boolean?
    inputBinding:
      position: 1
      prefix: '--snpfrac'
  col-cseq:
    doc: |
      print aligned colorspace seqs as colors, not decoded bases
    type: boolean?
    inputBinding:
      position: 1
      prefix: '--col-cseq'
  col-cqual:
    doc: |
      print original colorspace quals, not decoded quals
    type: boolean?
    inputBinding:
      position: 1
      prefix: '--col-cqual'
  col-keepends:
    doc: |
      keep nucleotides at extreme ends of decoded alignment
      SAM:
    type: boolean?
    inputBinding:
      position: 1
      prefix: '--col-keepends'
  sam:
    doc: |
      --sam           write hits in SAM format
    type: boolean?
    inputBinding:
      position: 1
      prefix: '-S'
  mapq:
    doc: |
      <int>       default mapping quality (MAPQ) to print for SAM alignments
    type: int?
    inputBinding:
      position: 1
      prefix: '--mapq'
  sam-nohead:
    doc: |
      supppress header lines (starting with @) for SAM output
    type: boolean?
    inputBinding:
      position: 1
      prefix: '--sam-nohead'
  sam-nosq:
    doc: |
      supppress @SQ header lines for SAM output
    type: boolean?
    inputBinding:
      position: 1
      prefix: '--sam-nosq'
  sam-RG:
    doc: |
      <text>    add <text> (usually "lab=value") to @RG line of SAM header
      Performance:
    type: string?
    inputBinding:
      position: 1
      prefix: '--sam-RG'
  o:
    doc: |
      --offrate <int> override offrate of index; must be >= index's offrate
    type: int?
    inputBinding:
      position: 1
      prefix: '-o'
  p:
    doc: |
      --threads <int> number of alignment threads to launch (default: 1)
    type: int?
    inputBinding:
      position: 1
      prefix: '-p'
  mm:
    doc: |
      use memory-mapped I/O for index; many 'bowtie's can share
    type: boolean?
    inputBinding:
      position: 1
      prefix: '--mm'
  shmem:
    doc: |
      use shared mem for index; many 'bowtie's can share
      Other:
    type: boolean?
    inputBinding:
      position: 1
      prefix: '--shmem'
  seed:
    doc: |
      <int>       seed for random number generator
    type: int?
    inputBinding:
      position: 1
      prefix: '--seed'
  verbose:
    doc: |
      verbose output (for debugging)
    type: boolean?
    inputBinding:
      position: 1
      prefix: '--verbose'

baseCommand: bowtie
arguments:
- valueFrom: $('2> ' + inputs.filename + '.log')
  position: 100000
  shellQuote: false

outputs:
  output:
    type: File
    outputBinding:
      glob: $(inputs.filename)

  output_bowtie_log:
    type: File
    outputBinding:
      glob: $(inputs.filename + '.log')

$namespaces:
  schema: http://schema.org/

$schemas:
- http://schema.org/version/9.0/schemaorg-current-http.rdf

schema:mainEntity:
#  $import: https://scidap.com/description/tools/bowtie.yaml
  class: schema:SoftwareSourceCode
  schema:name: "bowtie"
  schema:about: |
    Bowtie is an ultrafast, memory-efficient short read aligner. It aligns short DNA sequences (reads) to the human genome at a rate of over 25 million 35-bp reads per hour. Bowtie indexes the genome with a Burrows-Wheeler index to keep its memory footprint small: typically about 2.2 GB for the human genome (2.9 GB for paired-end).
  schema:url: http://bowtie-bio.sourceforge.net
  schema:codeRepository: https://github.com/BenLangmead/bowtie.git

  schema:license:
  - https://opensource.org/licenses/GPL-3.0

  schema:targetProduct:
    class: schema:SoftwareApplication
    schema:softwareVersion: "1.1.2"
    schema:applicationCategory: "commandline tool"

  schema:programmingLanguage: "C++"

  schema:publication:
  - class: schema:ScholarlyArticle
    id: http://dx.doi.org/10.1186/gb-2009-10-3-r25

schema:isPartOf:
  class: schema:CreativeWork
  schema:name: "Common Workflow Language"
  schema:url: http://commonwl.org/

schema:author:
  class: schema:Person
  schema:name: "Andrey Kartashov"
  schema:email: mailto:Andrey.Kartashov@cchmc.org
  schema:sameAs:
  - id: http://orcid.org/0000-0001-9102-5681
  schema:worksFor:
  - class: schema:Organization
    schema:name: "Cincinnati Children's Hospital Medical Center"
    schema:location: "3333 Burnet Ave, Cincinnati, OH 45229-3026"
    schema:department:
    - class: schema:Organization
      schema:name: "Barski Lab"
