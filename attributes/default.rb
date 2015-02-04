include_attribute "hadoop"

default[:hiway][:user]                              = "hiway"
default[:hiway][:group]                             = node[:hadoop][:group]
default[:hiway][:dir]                               = node[:hadoop][:dir]
default[:hiway][:version]                           = "1.0.0-SNAPSHOT"
default[:hiway][:home]                              = "#{default[:hiway][:dir]}/hiway-#{default[:hiway][:version]}"
default[:hiway][:github_url]                        = "https://github.com/marcbux/Hi-WAY.git"

default[:hiway][:cuneiform][:version]               = "2.0.0-SNAPSHOT"
default[:hiway][:cuneiform][:home]                  = "#{default[:hiway][:dir]}/cuneiform-#{default[:hiway][:cuneiform][:version]}"
default[:hiway][:cuneiform][:github_url]            = "https://github.com/joergen7/cuneiform.git"

default[:hiway][:galaxy][:repository]               = "https://bitbucket.org/galaxy/galaxy-dist/"
default[:hiway][:galaxy][:home]                     = "#{default[:hiway][:dir]}/galaxy" 

default[:hiway][:helloworld][:workflow]             = "helloworld.cf"

default[:hiway][:wordcount][:workflow]              = "wordcount.cf"
default[:hiway][:wordcount][:input]                 = "'gronemeyer.txt' 'benzko.txt'"

default[:hiway][:variantcall][:setupworkflow]       = "variantcall.setup.cf"
default[:hiway][:variantcall][:workflow]            = "variantcall.cf"
default[:hiway][:variantcall][:bowtie2][:version]   = "2.2.2"
default[:hiway][:variantcall][:bowtie2][:zip]       = "bowtie2-#{node[:hiway][:variantcall][:bowtie2][:version]}-linux-x86_64.zip"
default[:hiway][:variantcall][:bowtie2][:home]      = "#{default[:hiway][:dir]}/bowtie2-#{node[:hiway][:variantcall][:bowtie2][:version]}"
default[:hiway][:variantcall][:bowtie2][:url]       = "http://downloads.sourceforge.net/project/bowtie-bio/bowtie2/#{node[:hiway][:variantcall][:bowtie2][:version]}/#{node[:hiway][:variantcall][:bowtie2][:zip]}"
default[:hiway][:variantcall][:samtools][:version]  = "0.1.19"
default[:hiway][:variantcall][:samtools][:tarbz2]   = "samtools-#{node[:hiway][:variantcall][:samtools][:version]}.tar.bz2"
default[:hiway][:variantcall][:samtools][:home]     = "#{default[:hiway][:dir]}/samtools-#{node[:hiway][:variantcall][:samtools][:version]}"
default[:hiway][:variantcall][:samtools][:url]      = "http://garr.dl.sourceforge.net/project/samtools/samtools/#{node[:hiway][:variantcall][:samtools][:version]}/#{node[:hiway][:variantcall][:samtools][:tarbz2]}"
default[:hiway][:variantcall][:varscan][:version]   = "2.3.6"
default[:hiway][:variantcall][:varscan][:jar]       = "VarScan.v#{node[:hiway][:variantcall][:varscan][:version]}.jar"
default[:hiway][:variantcall][:varscan][:url]       = "http://downloads.sourceforge.net/project/varscan/#{node[:hiway][:variantcall][:varscan][:jar]}"
default[:hiway][:variantcall][:annovar][:targz]     = "annovar.latest.tar.gz"
default[:hiway][:variantcall][:annovar][:home]      = "#{default[:hiway][:dir]}/annovar"
default[:hiway][:variantcall][:annovar][:url]       = "http://www.openbioinformatics.org/annovar/download/g4EUwyphi9/#{node[:hiway][:variantcall][:annovar][:targz]}"
default[:hiway][:variantcall][:splitsize_reference] = 12000
default[:hiway][:variantcall][:paired_read_files]   = 1
default[:hiway][:variantcall][:iterations]          = 1
default[:hiway][:variantcall][:threads]             = 1
default[:hiway][:variantcall][:memory]              = 4096000000

default[:hiway][:montage_synthetic][:workflow]       = "Montage_25.xml"
default[:hiway][:montage_synthetic][:url]            = "https://confluence.pegasus.isi.edu/download/attachments/2490624/#{node[:hiway][:montage_synthetic][:workflow]}"

default[:hiway][:montage_m17_4][:workflow]           = "montage_m17_4.dax"
default[:hiway][:montage_m17_4][:montage][:version]  = "3.3"
default[:hiway][:montage_m17_4][:montage][:targz]    = "Montage_v#{node[:hiway][:montage_m17_4][:montage][:version]}.tar.gz"
default[:hiway][:montage_m17_4][:montage][:home]     = "#{default[:hiway][:dir]}/Montage_v#{node[:hiway][:montage_m17_4][:montage][:version]}"
default[:hiway][:montage_m17_4][:montage][:url]      = "http://montage.ipac.caltech.edu/download/#{node[:hiway][:montage_m17_4][:montage][:targz]}"

default[:hiway][:galaxy101][:workflow]               = "galaxy101.ga"

default[:hiway][:RNASeq][:workflow]                  = "RNASeq.ga"
